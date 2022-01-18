import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../modules/clubes/shared/models/clube.dart';
import '../../../modules/quiz/shared/models/assunto_model.dart';
import '../../../modules/quiz/shared/models/questao_model.dart';
import '../../models/db/remoto/linha_tabela_alternativas.dart';
import '../../models/db/remoto/linha_tabela_assuntos.dart';
import '../../models/db/remoto/linha_tabela_atividades.dart';
import '../../models/db/remoto/linha_tabela_clube_usuario.dart';
import '../../models/db/remoto/linha_tabela_clubes.dart';
import '../../models/db/remoto/linha_tabela_questao_assunto.dart';
import '../../models/db/remoto/linha_tabela_questao_atividade.dart';
import '../../models/db/remoto/linha_tabela_questoes.dart';
import '../../models/db/remoto/linha_tabela_questoes_caderno.dart';
import '../../models/db/remoto/linha_tabela_resposta_questao.dart';
import '../../models/db/remoto/linha_tabela_resposta_questao_atividade.dart';
import '../../models/db/remoto/linha_tabela_tipos_alternativa.dart';
import '../../models/db/remoto/linha_tabela_tipos_permissao.dart';
import '../../models/db/remoto/linha_tabela_usuarios.dart';
import '../../models/debug.dart';
import '../../models/exceptions/error_handler.dart';
import '../../models/exceptions/my_exception.dart';
import '../../utils/strings_db.dart';
import '../../utils/strings_db_sql.dart';
import '../interface_auth_repository.dart';
import '../interface_db_repository.dart';
import '../mixin_db_repository.dart';
import '../mixin_db_sql.dart';

/// O objeto [Map] usado pelo [Supabase] nas operações com o banco de dados.
///
/// Os valores desse objeto devem estar codificados.
typedef DataSupabaseDb = Map<String, dynamic>;

/// Gerencia a conexão com o banco de dados Supabase.
class SupabaseDbRepository
    with DbRepositoryMixin, DbSqlMixin
    implements IRemoteDbRepository {
  final SupabaseClient _client;
  final IAuthRepository _authRepository;

  SupabaseDbRepository(Supabase supabase, IAuthRepository authRepository)
      : _client = supabase.client,
        _authRepository = authRepository;

  /// Lançará uma exceção se não houver um usuário conectado.
  void _checkAuthentication(String memberName) {
    _authRepository.checkAuthentication('SupabaseDbRepository', memberName);
  }

  /// Obter dados da tabela [tabela].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<DataDocument>> _obterDados({
    required String tabela,
    DateTime? modificadoApos,
  }) async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository._obterDados()...'));
    final nomes = Sql.tbQuestoes;
    try {
      assert(Debug.print('[INFO] Solicitando os dados da tabela "$tabela"...'));
      PostgrestFilterBuilder filtro = _client.from(tabela).select();
      if (modificadoApos != null) {
        filtro = filtro.gt(nomes.dataModificacao, modificadoApos);
      }
      final resposta = await filtro.execute();
      if (resposta.error != null) {
        final error = resposta.error as PostgrestError;
        ErrorHandler.reportError(FlutterErrorDetails(
          exception: error,
          library: 'SupabaseDbRepository._obterDados('
              'tabela: $tabela '
              'modificadoApos: ${modificadoApos?.toIso8601String()})',
        ));
        throw 'PostgrestError';
      }
      return (resposta.data as List).cast();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$tabela".'));
      return [];
    }
  }

  /// Obter dados da tabela [Sql.tbQuestoes].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbQuestoesDbRemoto>> obterTbQuestoes(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbQuestoes.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbQuestoesDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbAssuntos].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbAssuntosDbRemoto>> obterTbAssuntos(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbAssuntos.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadoLin) => LinTbAssuntosDbRemoto.fromMap(dadoLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbQuestaoAssunto].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbQuestaoAssuntoDbRemoto>> obterTbQuestaoAssunto(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbQuestaoAssunto.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbQuestaoAssuntoDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbTiposAlternativa].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbTiposAlternativaDbRemoto>> obterTbTiposAlternativa(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbTiposAlternativa.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbTiposAlternativaDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbAlternativas].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbAlternativasDbRemoto>> obterTbAlternativas(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbAlternativas.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbAlternativasDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbAlternativas].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbQuestoesCadernoDbRemoto>> obterTbQuestoesCaderno(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbQuestoesCaderno.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbQuestoesCadernoDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbUsuarios].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbUsuariosDbRemoto>> obterTbUsuarios(
      {DateTime? modificadoApos}) async {
    /// TODO: ajustar as permissões.
    final dados = await _obterDados(
      tabela: Sql.tbUsuarios.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbUsuariosDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbClubes].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbClubesDbRemoto>> obterTbClubes(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbClubes.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbClubesDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbTiposPermissao].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbTiposPermissaoDbRemoto>> obterTbTiposPermissao(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbTiposPermissao.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbTiposPermissaoDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbClubeUsuario].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbClubeUsuarioDbRemoto>> obterTbClubeUsuario(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbClubeUsuario.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbClubeUsuarioDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbAtividades].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbAtividadesDbRemoto>> obterTbAtividades(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbAtividades.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbAtividadesDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbQuestaoAtividade].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbQuestaoAtividadeDbRemoto>> obterTbQuestaoAtividade(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbQuestaoAtividade.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbQuestaoAtividadeDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbRespostaQuestaoAtividade].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbRespostaQuestaoAtividadeDbRemoto>>
      obterTbRespostaQuestaoAtividade({DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbRespostaQuestaoAtividade.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) =>
            LinTbRespostaQuestaoAtividadeDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Obter dados da tabela [Sql.tbRespostaQuestao].
  /// Se não for nulo, [modificadoApos] será usado como filtro.
  Future<List<LinTbRespostaQuestaoDbRemoto>> obterTbRespostaQuestao(
      {DateTime? modificadoApos}) async {
    final dados = await _obterDados(
      tabela: Sql.tbRespostaQuestao.tbNome,
      modificadoApos: modificadoApos,
    );
    return dados
        .map((dadosLin) => LinTbRespostaQuestaoDbRemoto.fromMap(dadosLin))
        .toList();
  }

  /// Retorna, assincronamente um [DataUsuario] apenas com o ID do usuário.
  Future<DataDocument> getUser(String email) async {
    assert(Debug.print('[INFO] Chamando SupabaseDbRepository.getUser()...'));
    _checkAuthentication('getUser()');
    final table = CollectionType.usuarios.name;
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados do usuário com o email "$email" '
          'na tabela "$table"...'));
      final response = await _client
          .from(table)
          .select(DbConst.kDbDataUserKeyId)
          .eq(DbConst.kDbDataUserKeyEmail, email)
          .execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(Debug.print(
            '[ERROR] Erro ao solicitar os dados do usuário com o email "$email" '
            'na tabela "$table"...'));
        throw MyException(
          error.message,
          originClass: 'SupabaseDbRepository',
          originField: 'getUser()',
          error: error,
        );
      }
      final list = (response.data as List).cast<DataUsuario>();
      assert(Debug.call(() {
        if (list.length > 1)
          Debug.print(
            '[ATTENTION] A solicitação retornou ${list.length} usuário(s) com o email "$email".',
          );
      }));
      return list.isNotEmpty ? list[0] : DataUsuario();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$table".'));
      rethrow;
    }
  }

  @override
  Future<List<Assunto>> getAssuntos() async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.getAssuntos()...'));
    //_checkAuthentication('getAssuntos()');
    final table = CollectionType.assuntos.name;
    try {
      assert(Debug.print('[INFO] Solicitando os dados da tabela "$table"...'));
      final response = await _client.from(table).select().execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: 'SupabaseDbRepository',
          originField: 'getAssuntos()',
          error: error,
        );
      }
      return (response.data as List).cast<DataAssunto>().map((dados) {
        return Assunto.fromDataAssunto(_decodeDataModificacao(dados));
      }).toList();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$table".'));
      rethrow;
    }
  }

  /// Decodifica a string da data de modificação em [dados] para o número de milissegundos
  /// (no fuso horário UTC) após a época Unix.
  DataDocument _decodeDataModificacao(Map<String, dynamic> dados) {
    final keyDataModificacao = DbConst.kDbDataDocumentKeyDataModificacao;
    final stringData = dados[keyDataModificacao] as String;
    final _dados = DataAssunto.from(dados)
      ..[keyDataModificacao] =
          DateTime.parse(stringData).toUtc().millisecondsSinceEpoch;
    return _dados;
  }

  /// [data] tem a estrutura {"assunto": [String], "id_assunto_pai": [int?]}.
  @override
  Future<bool> insertAssunto(RawAssunto data) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.insertAssunto()...'));
    _checkAuthentication('insertAssunto()');
    try {
      assert(Debug.print('[INFO] Inserindo o assunto ${data.toString()}...'));
      final response =
          await _client.from('assunto_x_assunto_pai').insert(data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: 'SupabaseDbRepository',
          originField: 'insertAssunto()',
          error: error,
        );
      }
      return (response.count ?? 0) > 0;
    } catch (_) {
      assert(
          Debug.print('[ERROR] Erro ao inserir o assunto ${data.toString()}.'));
      rethrow;
    }
  }

  @override
  Future<List<Questao>> getQuestoes() async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.getQuestoes()...'));
    //_checkAuthentication('getQuestoes()');
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados da tabela "$viewQuestoes"...'));
      final response = await _client.from(viewQuestoes).select().execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: 'SupabaseDbRepository',
          originField: 'getQuestoes()',
          error: error,
        );
      }
      return (response.data as List)
          .cast<DataQuestao>()
          .map((dados) => Questao.fromJson(dados))
          .toList();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$viewQuestoes".'));
      rethrow;
    }
  }

  @override
  Future<bool> insertQuestao(DataQuestao data) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.insertQuestao()...'));
    _checkAuthentication('insertQuestao()');
    try {
      assert(Debug.print('[INFO] Inserindo a questão ${data.toString()}...'));
      final response = await _client.from(viewQuestoes).insert(data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: 'SupabaseDbRepository',
          originField: 'insertQuestao()',
          error: error,
        );
      }
      return (response.count ?? 0) > 0;
    } catch (_) {
      assert(
          Debug.print('[ERROR] Erro ao inserir a questão ${data.toString()}.'));
      rethrow;
    }
  }

  @override
  Future<List<Clube>> getClubes(int idUsuario) async {
    assert(Debug.print('[INFO] Chamando SupabaseDbRepository.getClubes()...'));
    _checkAuthentication('getClubes()');
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados dos clubes do usuário cujo ID é $idUsuario...'));
      final response = await _client.rpc(
        'get_clubes',
        params: {'id_usuario': idUsuario},
      ).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: 'SupabaseDbRepository',
          originField: 'getClubes()',
          error: error,
        );
      }

      final clubes = (response.data as List)
          .cast<DataClube>()
          .map((dataClube) => Clube.fromDataClube(dataClube))
          .toList();
      return clubes;
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados dos clubes do usuário cujo ID é $idUsuario.'));
      rethrow;
    }
  }

  @override
  Future<DataClube> insertClube(DataClube dados) async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.insertClube()...'));
    _checkAuthentication('insertClube()');
    // As chaves devem coincidir com os nomes dos parâmetros da função no banco de dados.
    final data = _prepareInsertClube(dados);
    if (data.isEmpty) return DataClube();
    try {
      assert(Debug.print('[INFO] Inserindo o clube ${data.toString()}...'));
      final response =
          await _client.rpc('inserir_clube', params: data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(
            Debug.print('[ERROR] Erro ao inserir o clube ${data.toString()}. '
                '\n${error.toString()}'));
        return DataClube();
      }
      final list = (response.data as List).cast<DataClube>();
      return list.isNotEmpty ? list[0] : DataClube();
    } catch (_) {
      assert(
          Debug.print('[ERROR] Erro ao inserir o clube ${data.toString()}.'));
      rethrow;
    }
  }

  Map<String, dynamic> _prepareInsertClube(DataClube data) {
    final nome = data[DbConst.kDbDataClubeKeyNome] as String?;
    final proprietario = data[DbConst.kDbDataClubeKeyProprietario] as int?;
    final codigo = data[DbConst.kDbDataClubeKeyCodigo] as String?;

    final condicao = ![nome, proprietario, codigo].contains(null);
    assert(condicao);
    if (!condicao) return {};

    final dados = {
      DbConst.kDbDataClubeKeyNome: nome,
      DbConst.kDbDataClubeKeyProprietario: proprietario,
      DbConst.kDbDataClubeKeyCodigo: codigo,
      DbConst.kDbDataClubeKeyDescricao: data[DbConst.kDbDataClubeKeyDescricao],
      DbConst.kDbDataClubeKeyPrivado:
          data[DbConst.kDbDataClubeKeyPrivado] ?? false,
      DbConst.kDbDataClubeKeyAdministradores:
          data[DbConst.kDbDataClubeKeyAdministradores],
      DbConst.kDbDataClubeKeyMembros: data[DbConst.kDbDataClubeKeyMembros],
      DbConst.kDbDataClubeKeyCapa: data[DbConst.kDbDataClubeKeyCapa],
    };

    return dados;
  }

  @override
  Future<bool> exitClube(int idClube, int idUser) async {
    assert(Debug.print('[INFO] Chamando SupabaseDbRepository.exitClube()...'));
    _checkAuthentication('exitClube()');
    try {
      assert(Debug.print(
          '[INFO] Excluindo o usuário cujo "idUser = $idUser" do clube cujo '
          '"idClube = $idClube" na tabela "$tbClubeXUsuario"...'));
      final response = await _client
          .from(tbClubeXUsuario)
          .update({Sql.tbClubeUsuario.excluir: true})
          .eq(tbClubeXUsuarioColIdUsuario, idUser)
          .eq(tbClubeXUsuarioColIdClube, idClube)
          .execute();

      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(Debug.print(
            '[ERROR] Erro ao excluir o usuário cujo "idUser = $idUser" do clube cujo '
            '"idClube = $idClube" na tabela "$tbClubeXUsuario".'));
        assert(Debug.printBetweenLine(error));
        return false;
      }
      return true;
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao excluir o usuário cujo "idUser = $idUser" do clube cujo '
          '"idClube = $idClube" na tabela "$tbClubeXUsuario".'));
      rethrow;
    }
  }

  @override
  Future<DataClube> enterClube(String accessCode, int idUser) async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.enterClube()...'));
    _checkAuthentication('enterClube()');
    try {
      assert(Debug.print(
          '[INFO] Incluindo o usuário cujo "idUser = $idUser" no clube cujo '
          'código de acesso é "$accessCode"...'));
      final data = {
        'id_usuario': idUser,
        'codigo_clube': accessCode,
        'id_permissao': 2,
      };
      final response =
          await _client.rpc('entrar_clube', params: data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(Debug.print(
            '[ERROR] Erro ao incluir o usuário cujo "idUser = $idUser" no clube cujo '
            'código de acesso é "$accessCode". '
            '\n${error.toString()}'));
        return DataClube();
      }
      final list = (response.data as List).cast<DataClube>();
      return list.isNotEmpty ? list[0] : DataClube();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao incluir o usuário cujo "idUser = $idUser" no clube cujo '
          'código de acesso é "$accessCode".'));
      rethrow;
    }
  }

  @override
  Future<DataClube> updateClube(DataClube data) async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.updateClube()...'));
    _checkAuthentication('updateClube()');
    final tbClubes = CollectionType.clubes.name;
    final id = data[DbConst.kDbDataClubeKeyId] as int?;
    if (data[DbConst.kDbDataClubeKeyAdministradores] != null) {
      throw UnimplementedError(
          'A atualização da lista de administradores não foi implementada.');
    }
    if (data[DbConst.kDbDataClubeKeyMembros] != null) {
      throw UnimplementedError(
          'A atualização da lista de membros não foi implementada.');
    }
    if (id == null) {
      assert(Debug.print('[ERROR] O ID do clube não pode ser nulo.'));
      return DataClube();
    }
    try {
      assert(Debug.print('[INFO] Atualizando os dados do clube cujo "id = $id" '
          'na tabela "$tbClubes"...'));
      final response =
          await _client.rpc('atualizar_clube', params: data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(Debug.print(
            '[ERROR] Erro ao atualizar o clube. \n${error.toString()}'));
        return DataClube();
      }
      final list = (response.data as List).cast<DataClube>();
      return list.isNotEmpty ? list[0] : DataClube();
    } catch (_) {
      assert(Debug.print('[ERROR] Erro ao atualizar o clube com os dados: '
          '\n${data.toString()}'));
      rethrow;
    }
  }

  @override
  Future<bool> updatePermissionUserClube(
    int idClube,
    int idUser,
    int idPermission,
  ) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.updatePermissionUserClube()...'));
    _checkAuthentication('updatePermissionUserClube()');
    try {
      assert(Debug.print(
          '[INFO] Atualizando a permissão de acesso do usuário ao clube de acordo '
          'com os correspondentes idPermission = $idPermission, idUser = $idUser e '
          'idClube = $idClube na tabela "$tbClubeXUsuario"...'));
      final response = await _client
          .from(tbClubeXUsuario)
          .update({tbClubeXUsuarioColIdPermissao: idPermission})
          .eq(tbClubeXUsuarioColIdUsuario, idUser)
          .eq(tbClubeXUsuarioColIdClube, idClube)
          .execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(
            Debug.print('[ERROR] Erro ao atualizar a permissão do usuário.'));
        assert(Debug.printBetweenLine(error));
        return false;
      }
      return true;
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao atualizar a permissão de acesso do usuário ao clube'));
      rethrow;
    }
  }

  @override
  Future<DataCollection> getAtividades(int idClube) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.getAtividades()...'));
    _checkAuthentication('getAtividades()');
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados da tabela "$viewAtividades"...'));
      final response = await _client
          .from(viewAtividades)
          .select()
          .eq(DbConst.kDbDataAtividadeKeyIdClube, idClube)
          .execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(Debug.print(
            '[ERROR] Erro ao solicitar as atividades para o clube com o ID $idClube. '
            '\n${error.toString()}'));
        return DataCollection.empty();
      }
      return (response.data as List).cast<DataAtividade>();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$viewAtividades".'));
      rethrow;
    }
  }

  /// {@macro app.IDbRepository.insertAtividade}
  @override
  Future<DataAtividade> insertAtividade(DataAtividade dados) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.insertAtividade()...'));
    _checkAuthentication('insertAtividade()');
    // As chaves devem coincidir com os nomes dos parâmetros da função no banco de dados.
    final data = _prepareInsertAtividade(dados);
    if (data.isEmpty) return DataAtividade();
    try {
      assert(Debug.print('[INFO] Inserindo a atividade ${data.toString()}...'));
      final response =
          await _client.rpc('inserir_atividade', params: data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(Debug.print(
            '[ERROR] Erro ao inserir a atividade ${data.toString()}. '
            '\n${error.toString()}'));
        return DataAtividade();
      }
      final list = (response.data as List).cast<DataAtividade>();
      return list.isNotEmpty ? list[0] : DataAtividade();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao inserir a atividade ${data.toString()}.'));
      rethrow;
    }
  }

  Map<String, dynamic> _prepareInsertAtividade(DataAtividade data) {
    final idClube = data[DbConst.kDbDataAtividadeKeyIdClube] as int?;
    final idAutor = data[DbConst.kDbDataAtividadeKeyIdAutor] as int?;
    final titulo = data[DbConst.kDbDataAtividadeKeyTitulo] as String?;
    final dataLiberacao =
        data[DbConst.kDbDataAtividadeKeyDataLiberacao] as int?;

    final condicao = ![idClube, idAutor, titulo, dataLiberacao].contains(null);
    assert(condicao);
    if (!condicao) return {};

    final questoes = (data[DbConst.kDbDataAtividadeKeyQuestoes] as List?)
        ?.cast<Map>()
        .map((e) =>
            e[DbConst.kDbDataQuestaoAtividadeKeyIdQuestaoCaderno] as String)
        .toList();
    final dataEncerramento =
        data[DbConst.kDbDataAtividadeKeyDataEncerramento] as int?;

    final dados = {
      DbConst.kDbDataAtividadeKeyIdClube: idClube,
      DbConst.kDbDataAtividadeKeyIdAutor: idAutor,
      DbConst.kDbDataAtividadeKeyTitulo: titulo,
      DbConst.kDbDataAtividadeKeyDescricao:
          data[DbConst.kDbDataAtividadeKeyDescricao],
      DbConst.kDbDataAtividadeKeyQuestoes: questoes,
      DbConst.kDbDataAtividadeKeyDataLiberacao:
          dataLiberacao == null ? null : dataLiberacao / 1000,
      DbConst.kDbDataAtividadeKeyDataEncerramento:
          dataEncerramento == null ? null : dataEncerramento / 1000,
    };

    return dados;
  }

  /// {@macro app.IDbRepository.updateAtividade}
  @override
  Future<DataAtividade> updateAtividade(DataAtividade dados) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.updateAtividade()...'));
    _checkAuthentication('updateAtividade()');
    // As chaves devem coincidir com os nomes dos parâmetros da função no banco de dados.
    final data = _prepareUpdateAtividade(dados);
    if (data.isEmpty) return DataAtividade();

    try {
      assert(Debug.print('[INFO] Atualizando os dados da atividade cujo '
          '"id = ${data[DbConst.kDbDataAtividadeKeyId]}".'));
      final response =
          await _client.rpc('atualizar_atividade', params: data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(Debug.print(
            '[ERROR] Erro ao atualizar a atividade. \n${error.toString()}'));
        return DataAtividade();
      }
      final list = (response.data as List).cast<DataAtividade>();
      return list.isNotEmpty ? list[0] : DataAtividade();
    } catch (_) {
      assert(Debug.print('[ERROR] Erro ao atualizar a atividade com os dados: '
          '\n${data.toString()}'));
      rethrow;
    }
  }

  Map<String, dynamic> _prepareUpdateAtividade(DataAtividade data) {
    final id = data[DbConst.kDbDataAtividadeKeyId] as int?;
    final titulo = data[DbConst.kDbDataAtividadeKeyTitulo] as String?;

    final condicao = ![titulo, id].contains(null);
    assert(condicao);
    if (!condicao) return {};

    final questoes = (data[DbConst.kDbDataAtividadeKeyQuestoes] as List?)
        ?.cast<Map>()
        .map((e) =>
            e[DbConst.kDbDataQuestaoAtividadeKeyIdQuestaoCaderno] as String)
        .toList();
    final dataLiberacao =
        data[DbConst.kDbDataAtividadeKeyDataLiberacao] as int?;
    final dataEncerramento =
        data[DbConst.kDbDataAtividadeKeyDataEncerramento] as int?;

    final dados = {
      DbConst.kDbDataAtividadeKeyId: id,
      DbConst.kDbDataAtividadeKeyTitulo: titulo,
      DbConst.kDbDataAtividadeKeyDescricao:
          data[DbConst.kDbDataAtividadeKeyDescricao],
      DbConst.kDbDataAtividadeKeyQuestoes: questoes,
      DbConst.kDbDataAtividadeKeyDataLiberacao:
          dataLiberacao == null ? null : dataLiberacao / 1000,
      DbConst.kDbDataAtividadeKeyDataEncerramento:
          dataEncerramento == null ? null : dataEncerramento / 1000,
    };

    return dados;
  }

  @override
  Future<List<DataRespostaQuestaoAtividade>> getRespostasAtividade(
    int idAtividade, [
    int? idUsuario,
  ]) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.getRespostasAtividade()...'));
    _checkAuthentication('getRespostasAtividade()');
    final table = CollectionType.respostasQuestaoAtividade.name;
    final data = {
      'id_atividade': idAtividade,
      DbConst.kDbDataRespostaQuestaoAtividadeKeyIdUsuario: idUsuario,
    };
    try {
      assert(Debug.print('[INFO] Solicitando os dados da tabela "$table"...'));
      final response = await _client
          .rpc('get_respostas_x_questoes_x_atividade', params: data)
          .execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(Debug.print(
            '[ERROR] Erro ao solicitar as respostas para a atividade com o '
            'ID $idAtividade para o usuário com o ID $idUsuario.'
            '\n${error.toString()}'));
        return List<DataRespostaQuestaoAtividade>.empty();
      }
      return (response.data as List)
          .cast<Map>()
          .map((e) => e.cast<String, int>())
          .toList();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$table".'));
      rethrow;
    }
  }

  @override
  Future<bool> upsertRespostasAtividade(
      List<DataRespostaQuestaoAtividade> data) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.upsertRespostasAtividade()...'));
    _checkAuthentication('upsertRespostasAtividade()');
    final table = CollectionType.respostasQuestaoAtividade.name;
    try {
      assert(Debug.print('[INFO] Inserindo os dados na tabela "$table"...'));
      final response = await _client
          .from(table)
          .upsert(data
              .map((e) => e[Sql.tbRespostaQuestaoAtividade.excluir] = false)
              .toList())
          .execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        assert(Debug.print('[ERROR] Erro ao inserir os dados na tabela $table.'
            '\n${error.toString()}'));
        return false;
      }
      return true;
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$table".'));
      rethrow;
    }
  }
}

import 'dart:async';

import 'package:clubedematematica/app/modules/clubes/modules/atividades/models/atividade.dart';
import 'package:clubedematematica/app/modules/clubes/modules/atividades/models/resposta_questao_atividade.dart';
import 'package:clubedematematica/app/shared/utils/db/codificacao.dart';
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
    try {
      assert(Debug.print('[INFO] Solicitando os dados da tabela "$tabela"...'));
      PostgrestFilterBuilder filtro = _client.from(tabela).select();
      if (modificadoApos != null) {
        filtro = filtro.gt(Sql.dataModificacao, modificadoApos);
      }
      final resposta = await filtro.execute();
      if (resposta.error != null) throw resposta.error!;
      return (resposta.data as List).cast();
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$tabela".'));
      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message('SupabaseDbRepository._obterDados('
            'tabela: $tabela '
            'modificadoApos: ${modificadoApos?.toIso8601String()})'),
      ));
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
    final tabela = CollectionType.usuarios.name;
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados do usuário com o email "$email" '
          'na tabela "$tabela"...'));
      final response = await _client
          .from(tabela)
          .select(DbConst.kDbDataUserKeyId)
          .eq(DbConst.kDbDataUserKeyEmail, email)
          .execute();
      if (response.error != null) throw response.error!;
      final list = (response.data as List).cast<DataUsuario>();
      assert(Debug.call(() {
        if (list.length > 1)
          Debug.print(
            '[ATTENTION] A solicitação retornou ${list.length} usuário(s) com o email "$email".',
          );
      }));
      return list.isNotEmpty ? list.first : DataUsuario();
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados do usuário com o email "$email" '
          'na tabela "$tabela"...'));
      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context:
            DiagnosticsNode.message('SupabaseDbRepository.getUser($email)'),
      ));
      return DataDocument();
    }
  }

  @override
  Future<List<Assunto>> getAssuntos() async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.getAssuntos()...'));
    //_checkAuthentication('getAssuntos()');
    final tabela = CollectionType.assuntos.name;
    try {
      assert(Debug.print('[INFO] Solicitando os dados da tabela "$tabela"...'));
      final resposta = await _client.from(tabela).select().execute();

      if (resposta.error != null) throw resposta.error!;

      return (resposta.data as List).cast<DataAssunto>().map((dados) {
        return Assunto.fromDataAssunto(_decodeDataModificacao(dados));
      }).toList();
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$tabela".'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message('SupabaseDbRepository.getAssuntos()'),
      ));

      return [];
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
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.insertAssunto()...'));
    _checkAuthentication('insertAssunto()');
    try {
      assert(Debug.print('[INFO] Inserindo o assunto $data...'));
      final response =
          await _client.from('assunto_x_assunto_pai').insert(data).execute();

      if (response.error != null) throw response.error!;

      return (response.count ?? 0) > 0;
    } catch (erro, stack) {
      assert(Debug.print('[ERROR] Erro ao inserir o assunto $data.'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context:
            DiagnosticsNode.message('SupabaseDbRepository.insertAssunto()'),
      ));

      return false;
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

      if (response.error != null) throw response.error!;

      return Future.wait(
        (response.data as List)
            .cast<DataQuestao>()
            .map((dados) => Questao.fromDataQuestao(dados)),
      );
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$viewQuestoes".'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message('SupabaseDbRepository.getQuestoes()'),
      ));

      return [];
    }
  }

  @override
  Future<bool> insertQuestao(DataQuestao data) async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.insertQuestao()...'));
    _checkAuthentication('insertQuestao()');
    try {
      assert(Debug.print('[INFO] Inserindo a questão ${data.toString()}...'));
      final response = await _client.from(viewQuestoes).insert(data).execute();

      if (response.error != null) throw response.error!;

      return (response.count ?? 0) > 0;
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$viewQuestoes".'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context:
            DiagnosticsNode.message('SupabaseDbRepository.insertQuestao()'),
      ));

      return false;
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

      if (response.error != null) throw response.error!;

      final clubes = (response.data as List)
          .cast<DataClube>()
          .map((dataClube) => Clube.fromDataClube(dataClube))
          .toList();
      return clubes;
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados dos clubes do usuário cujo ID é $idUsuario.'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message(
            'SupabaseDbRepository.getClubes($idUsuario)'),
      ));

      return [];
    }
  }

  @override
  Future<Clube?> insertClube(RawClube dados) async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.insertClube()...'));
    _checkAuthentication('insertClube()');
    // As chaves devem coincidir com os nomes dos parâmetros da função no banco de dados.
    final data = _prepareInsertClube(dados);
    if (data.isEmpty) return null;
    try {
      assert(Debug.print('[INFO] Inserindo o clube ${data.toString()}...'));
      final response =
          await _client.rpc('inserir_clube', params: data).execute();

      if (response.error != null) throw response.error!;

      final list = (response.data as List).cast<DataClube>();
      return list.isNotEmpty ? Clube.fromDataClube(list.first) : null;
    } catch (erro, stack) {
      assert(Debug.print('[ERROR] Erro ao inserir o clube $data. \n$erro'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message('SupabaseDbRepository.insertClube()'),
      ));

      return null;
    }
  }

  Map<String, dynamic> _prepareInsertClube(RawClube data) {
    final usuarios = data.usuarios;

    administradores() {
      return usuarios
          ?.where((usuario) {
            return usuario.permissao == PermissoesClube.administrador &&
                usuario.id != null;
          })
          .map((e) => e.id!)
          .toList();
    }

    membros() {
      return usuarios
          ?.where((usuario) {
            return usuario.permissao == PermissoesClube.membro &&
                usuario.id != null;
          })
          .map((e) => e.id!)
          .toList();
    }

    capa() {
      final cor = data.capa;
      if (cor != null) return DbRemoto.codificarCapaClube(cor);
    }

    final condicao = ![data.nome, data.codigo].contains(null);
    assert(condicao);
    if (!condicao) return {};

    final dados = {
      '_nome': data.nome,
      '_codigo': data.codigo,
      '_descricao': data.descricao,
      '_privado': data.privado ?? false,
      '_capa': capa(),
      '_administradores': administradores(),
      '_membros': membros(),
    };

    return dados;
  }

  /// * [List]<[DataUsuarioClube]> para [DbConst.kDbDataClubeKeyUsuarios].
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

      if (response.error != null) throw response.error!;

      return true;
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao excluir o usuário cujo "idUser = $idUser" do clube cujo '
          '"idClube = $idClube" na tabela "$tbClubeXUsuario".'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message(
            'SupabaseDbRepository.exitClube($idClube, $idUser)'),
      ));

      return false;
    }
  }

  @override
  Future<DataClube> enterClube(String accessCode, int idUser) async {
    assert(Debug.print('[INFO] Chamando SupabaseDbRepository.enterClube()...'));
    _checkAuthentication('enterClube()');
    try {
      assert(Debug.print(
          '[INFO] Incluindo o usuário cujo "idUser = $idUser" no clube cujo '
          'código de acesso é "$accessCode"...'));
      final data = {
        '_id_usuario': idUser,
        '_codigo_clube': accessCode,
        '_id_permissao': 2,
      };
      final response =
          await _client.rpc('entrar_clube', params: data).execute();

      if (response.error != null) throw response.error!;

      final list = (response.data as List).cast<DataClube>();
      return list.isNotEmpty ? list[0] : DataClube();
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao incluir o usuário cujo "idUser = $idUser" no clube cujo '
          'código de acesso é "$accessCode". '
          '\n$erro'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message(
            'SupabaseDbRepository.enterClube($accessCode, $idUser)'),
      ));

      return DataClube();
    }
  }

  @override
  Future<Clube?> updateClube(RawClube dados) async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.updateClube()...'));
    _checkAuthentication('updateClube()');
    final data = _prepareUpdateClube(dados);
    try {
      assert(Debug.print(
          '[INFO] Atualizando os dados do clube cujo "id = ${dados.id}"...'));
      final response =
          await _client.rpc('atualizar_clube', params: data).execute();

      if (response.error != null) throw response.error!;

      final list = (response.data as List).cast<DataClube>();
      return list.isNotEmpty ? Clube.fromDataClube(list.first) : null;
    } catch (erro, stack) {
      assert(Debug.print('[ERROR] Erro ao atualizar o clube com os dados: '
          '\n$data'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context:
            DiagnosticsNode.message('SupabaseDbRepository.updateClube($dados)'),
      ));

      return null;
    }
  }

  Map<String, dynamic> _prepareUpdateClube(RawClube data) {
    final usuarios = data.usuarios;

    administradores() {
      return usuarios
          ?.where((usuario) {
            return usuario.permissao == PermissoesClube.administrador &&
                usuario.id != null;
          })
          .map((e) => e.id!)
          .toList();
    }

    membros() {
      return usuarios
          ?.where((usuario) {
            return usuario.permissao == PermissoesClube.membro &&
                usuario.id != null;
          })
          .map((e) => e.id!)
          .toList();
    }

    capa() {
      final cor = data.capa;
      if (cor != null) return DbRemoto.codificarCapaClube(cor);
    }

    final condicao = data.id != null;
    assert(condicao);
    if (!condicao) return {};

    final dados = {
      'id': data.id,
      'nome': data.nome,
      'codigo': data.codigo,
      'descricao': data.descricao,
      'privado': data.privado ?? false,
      'capa': capa(),
      'administradores': administradores(),
      'membros': membros(),
    };

    return dados;
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

      if (response.error != null) throw response.error!;

      return true;
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao atualizar a permissão de acesso do usuário ao clube'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message(
            'SupabaseDbRepository.updatePermissionUserClube($idClube, $idUser, $idPermission)'),
      ));

      return false;
    }
  }

  @override
  Future<bool> deleteClube(int idClube) async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.deleteClube()...'));
    _checkAuthentication('deleteClube()');
    final id = idClube;
    final tabela = Sql.tbClubes.tbNome;
    try {
      assert(Debug.print(
          '[INFO] Marcando como excluído o clube cuso ID é "$id"...'));
      final response = await _client
          .from(tabela)
          .update({Sql.tbClubes.excluir: true})
          .eq(Sql.tbClubes.id, id)
          .execute();

      if (response.error != null) throw response.error!;

      return true;
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao marcar como excluído o clube cuso ID é "$id". '
          '\n$erro'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message(
            'SupabaseDbRepository.deleteClube($idClube)'),
      ));

      return false;
    }
  }

  @override
  Future<DataCollection> getAtividades(int idClube) async {
    assert(
        Debug.print('[INFO] Chamando SupabaseDbRepository.getAtividades()...'));
    _checkAuthentication('getAtividades()');
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados da tabela "$viewAtividades"...'));
      final response = await _client
          .from(viewAtividades)
          .select()
          .eq(DbConst.kDbDataAtividadeKeyIdClube, idClube)
          .execute();

      if (response.error != null) throw response.error!;

      return (response.data as List).cast<DataAtividade>();
    } catch (erro, stack) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar as atividades para o clube com o ID $idClube. '
          '\n$erro'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message(
            'SupabaseDbRepository.getAtividades($idClube)'),
      ));

      return [];
    }
  }

  /// {@macro app.IDbRepository.insertAtividade}
  @override
  Future<Atividade?> insertAtividade(RawAtividade dados) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.insertAtividade()...'));
    _checkAuthentication('insertAtividade()');
    final data = _prepareInsertAtividade(dados);
    if (data.isEmpty) return null;
    try {
      assert(Debug.print('[INFO] Inserindo a atividade ${data.toString()}...'));
      final response =
          await _client.rpc('inserir_atividade', params: data).execute();

      if (response.error != null) throw response.error!;

      final list = (response.data as List).cast<DataAtividade>();
      return list.isNotEmpty ? Atividade.fromDataAtividade(list[0]) : null;
    } catch (erro, stack) {
      assert(Debug.print('[ERROR] Erro ao inserir a atividade $data. '
          '\n$erro'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message(
            'SupabaseDbRepository.insertAtividade($dados)'),
      ));

      return null;
    }
  }

  Map<String, dynamic> _prepareInsertAtividade(RawAtividade data) {
    final condicao = ![
      data.idClube,
      data.idAutor,
      data.titulo,
      data.liberacao,
    ].contains(null);
    assert(condicao);
    if (!condicao) return {};

    questoes() {
      return data.questoes
          ?.where((questao) => questao.idQuestao != null)
          .map((questao) => questao.idQuestao!)
          .toList();
    }

    // As chaves devem coincidir com os nomes dos parâmetros da função no banco de dados.
    final dados = {
      'id_clube': data.idClube,
      'id_autor': data.idAutor,
      'titulo': data.titulo,
      'descricao': data.descricao,
      'questoes': questoes(),
      'data_liberacao': data.liberacao == null
          ? null
          : data.liberacao!.toUtc().millisecondsSinceEpoch / 1000,
      'data_encerramento': data.encerramento == null
          ? null
          : data.encerramento!.toUtc().millisecondsSinceEpoch / 1000,
    };

    return dados;
  }

  /// {@macro app.IDbRepository.updateAtividade}
  @override
  Future<Atividade?> updateAtividade(RawAtividade dados) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.updateAtividade()...'));
    _checkAuthentication('updateAtividade()');
    final data = _prepareUpdateAtividade(dados);
    if (data.isEmpty) return null;

    try {
      assert(Debug.print(
          '[INFO] Atualizando os dados da atividade cujo "id = ${dados.id}".'));
      final response =
          await _client.rpc('atualizar_atividade', params: data).execute();

      if (response.error != null) throw response.error!;

      final list = (response.data as List).cast<DataAtividade>();
      return list.isNotEmpty ? Atividade.fromDataAtividade(list[0]) : null;
    } catch (erro, stack) {
      assert(Debug.print('[ERROR] Erro ao atualizar a atividade. \n$erro'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message(
            'SupabaseDbRepository.updateAtividade($dados)'),
      ));

      return null;
    }
  }

  Map<String, dynamic> _prepareUpdateAtividade(RawAtividade data) {
    final condicao = ![data.titulo, data.id].contains(null);
    assert(condicao);
    if (!condicao) return {};

    questoes() {
      return data.questoes
          ?.where((questao) => questao.idQuestao != null)
          .map((questao) => questao.idQuestao!)
          .toList();
    }

    // As chaves devem coincidir com os nomes dos parâmetros da função no banco de dados.
    final dados = {
      'id': data.id,
      'titulo': data.titulo,
      'descricao': data.descricao,
      'questoes': questoes(),
      'data_liberacao': data.liberacao == null
          ? null
          : data.liberacao!.toUtc().millisecondsSinceEpoch / 1000,
      'data_encerramento': data.encerramento == null
          ? null
          : data.encerramento!.toUtc().millisecondsSinceEpoch / 1000,
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
      Iterable<RawRespostaQuestaoAtividade> data) async {
    assert(Debug.print(
        '[INFO] Chamando SupabaseDbRepository.upsertRespostasAtividade()...'));
    _checkAuthentication('upsertRespostasAtividade()');
    final dados = _prepareUpsertRespostasAtividade(data);
    if (dados.isEmpty) return false;
    final table = Sql.tbRespostaQuestaoAtividade.tbNome;
    try {
      assert(Debug.print('[INFO] Inserindo os dados na tabela "$table"...'));
      final response = await _client.from(table).upsert(dados).execute();

      if (response.error != null) throw response.error!;

      return true;
    } catch (erro, stack) {
      assert(Debug.print('[ERROR] Erro ao inserir os dados na tabela $table.'
          '\n$erro'));

      ErrorHandler.reportError(FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'supabase_db_repository.dart',
        context: DiagnosticsNode.message(
            'SupabaseDbRepository.upsertRespostasAtividade($data)'),
      ));

      return false;
    }
  }

  List<Map<String, dynamic>> _prepareUpsertRespostasAtividade(
      Iterable<RawRespostaQuestaoAtividade> dados) {
    final inconsistente =
        dados.any((e) => [e.idQuestaoAtividade, e.idUsuario].contains(null));
    assert(!inconsistente);
    if (inconsistente) return [];
    return dados.map((e) => e.toDataRespostaQuestaoAtividade()).toList();
  }
}

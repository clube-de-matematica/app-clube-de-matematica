import 'dart:async';
import 'dart:developer';

import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/debug.dart';
import '../../models/exceptions/my_exception.dart';
import '../../utils/strings_db.dart';
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
  static const _debugName = 'SupabaseDbRepository';
  final SupabaseClient _client;
  final IAuthRepository _authRepository;

  SupabaseDbRepository(Supabase supabase, IAuthRepository authRepository)
      : _client = supabase.client,
        _authRepository = authRepository;

  /// Lançará uma exceção se não houver um usuário conectado.
  void _checkAuthentication(String memberName) {
    _authRepository.checkAuthentication(_debugName, memberName);
  }

  /// TODO: Retorna, assincronamente um [DataUser] apenas com o ID do usuário.
  Future<DataDocument> getUser(String email) async {
    assert(Debug.print('[INFO] Chamando $_debugName.getUser()...'));
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
          originClass: _debugName,
          originField: 'getUser()',
          error: error,
        );
      }
      final list = (response.data as List).cast<DataUser>();
      assert(Debug.call(() {
        if (list.length > 1)
          Debug.print(
            '[ATTENTION] A solicitação retornou ${list.length} usuário(s) com o email "$email".',
          );
      }));
      return list.isNotEmpty ? list[0] : DataUser();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$table".'));
      rethrow;
    }
  }

  @override
  Future<DataCollection> getAssuntos() async {
    assert(Debug.print('[INFO] Chamando $_debugName.getAssuntos()...'));
    //_checkAuthentication('getAssuntos()');
    final table = CollectionType.assuntos.name;
    try {
      assert(Debug.print('[INFO] Solicitando os dados da tabela "$table"...'));
      final response = await _client.from(table).select().execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: _debugName,
          originField: 'getAssuntos()',
          error: error,
        );
      }
      return (response.data as List).cast<DataAssunto>();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$table".'));
      rethrow;
    }
  }

  /// [data] tem a estrutura {"assunto": [String], "id_assunto_pai": [int?]}.
  @override
  Future<bool> insertAssunto(DataAssunto data) async {
    assert(Debug.print('[INFO] Chamando $_debugName.insertAssunto()...'));
    _checkAuthentication('insertAssunto()');
    try {
      assert(Debug.print('[INFO] Inserindo o assunto ${data.toString()}...'));
      final response =
          await _client.from('assunto_x_assunto_pai').insert(data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: _debugName,
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
  Future<DataCollection> getQuestoes() async {
    assert(Debug.print('[INFO] Chamando $_debugName.getQuestoes()...'));
    //_checkAuthentication('getQuestoes()');
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados da tabela "$viewQuestoes"...'));
      final response = await _client.from(viewQuestoes).select().execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: _debugName,
          originField: 'getQuestoes()',
          error: error,
        );
      }
      return (response.data as List).cast<DataQuestao>();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da tabela "$viewQuestoes".'));
      rethrow;
    }
  }

  @override
  Future<bool> insertQuestao(DataQuestao data) async {
    assert(Debug.print('[INFO] Chamando $_debugName.insertQuestao()...'));
    _checkAuthentication('insertQuestao()');
    try {
      assert(Debug.print('[INFO] Inserindo a questão ${data.toString()}...'));
      final response = await _client.from(viewQuestoes).insert(data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: _debugName,
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
  Future<DataCollection> getClubes(int idUsuario) async {
    assert(Debug.print('[INFO] Chamando $_debugName.getClubes()...'));
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
          originClass: _debugName,
          originField: 'getClubes()',
          error: error,
        );
      }
      return (response.data as List).cast<DataClube>();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados dos clubes do usuário cujo ID é $idUsuario.'));
      rethrow;
    }
  }

  @override
  Future<DataClube> insertClube({
    required String nome,
    required int proprietario,
    required String codigo,
    String? descricao,
    bool privado = false,
    List<int>? administradores,
    List<int>? membros,
    String? capa,
  }) async {
    assert(Debug.print('[INFO] Chamando $_debugName.insertClube()...'));
    _checkAuthentication('insertClube()');
    // As chaves devem coincidir com os nomes dos parâmetros da função no banco de dados.
    final data = {
      'nome': nome,
      'proprietario': proprietario,
      'codigo': codigo,
      'descricao': descricao,
      'privado': privado,
      'administradores': administradores,
      'membros': membros,
      'capa': capa,
    };
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

  @override
  Future<bool> exitClube(int idClube, int idUser) async {
    assert(Debug.print('[INFO] Chamando $_debugName.exitClube()...'));
    _checkAuthentication('exitClube()');
    try {
      assert(Debug.print(
          '[INFO] Excluindo o usuário cujo "idUser = $idUser" do clube cujo '
          '"idClube = $idClube" na tabela "$tbClubeXUsuario"...'));
      final response = await _client
          .from(tbClubeXUsuario)
          .delete()
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
    assert(Debug.print('[INFO] Chamando $_debugName.enterClube()...'));
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
    assert(Debug.print('[INFO] Chamando $_debugName.updateClube()...'));
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
      assert(Debug.print(
          '[INFO] Atualizando os dados do clube cujo "id = $id" do clube cujo '
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
      assert(Debug.print('[ERROR] Erro ao atualizar o clube cujo com os dados: '
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
        '[INFO] Chamando $_debugName.updatePermissionUserClube()...'));
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
    assert(Debug.print('[INFO] Chamando $_debugName.getAtividades()...'));
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
}

import 'dart:async';

import '../../models/exceptions/my_exception.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/debug.dart';
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
    final table = DbConst.kDbDataCollectionUsuarios;
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados do usuário com o email "$email" '
          'na tabela "$table"...'));
      final response = await _client
          .from(DbConst.kDbDataCollectionUsuarios)
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
    final table = DbConst.kDbDataCollectionAssuntos;
    try {
      assert(Debug.print('[INFO] Solicitando os dados da tabela "$table"...'));
      final response = await _client
          .from(DbConst.kDbDataCollectionAssuntos)
          .select()
          .execute();
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
  Future<bool> setAssunto(DataAssunto data) async {
    assert(Debug.print('[INFO] Chamando $_debugName.setAssunto()...'));
    _checkAuthentication('setAssunto()');
    try {
      assert(Debug.print('[INFO] Inserindo o assunto ${data.toString()}...'));
      final response =
          await _client.from('assunto_x_assunto_pai').insert(data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: _debugName,
          originField: 'setAssunto()',
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
  Future<bool> setQuestao(DataQuestao data) async {
    assert(Debug.print('[INFO] Chamando $_debugName.setQuestao()...'));
    _checkAuthentication('setQuestao()');
    try {
      assert(Debug.print('[INFO] Inserindo a questão ${data.toString()}...'));
      final response = await _client.from(viewQuestoes).insert(data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: _debugName,
          originField: 'setQuestao()',
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
  Future<bool> setClube(DataDocument data) async {
    assert(Debug.print('[INFO] Chamando $_debugName.setClube()...'));
    _checkAuthentication('setClube()');
    try {
      assert(Debug.print('[INFO] Inserindo o clube ${data.toString()}...'));
      final response =
          await _client.rpc('inserir_clube', params: data).execute();
      if (response.error != null) {
        final error = response.error as PostgrestError;
        throw MyException(
          error.message,
          originClass: _debugName,
          originField: 'setClube()',
          error: error,
        );
      }
      return (response.count ?? 0) > 0;
    } catch (_) {
      assert(
          Debug.print('[ERROR] Erro ao inserir o clube ${data.toString()}.'));
      rethrow;
    }
  }
}

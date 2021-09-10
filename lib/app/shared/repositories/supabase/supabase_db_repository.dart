import 'dart:async';

import '../../models/exceptions/my_exception.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/debug.dart';
import '../../utils/strings_db.dart';
import '../firebase/auth_repository.dart';
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
  final Future<Supabase> supabase;
  Future<SupabaseClient> get client async => (await supabase).client;
  final AuthRepository _authRepository;

  SupabaseDbRepository(this.supabase, AuthRepository authRepository)
      : _authRepository = authRepository;

  /// Lançará uma exceção se não houver um usuário conectado.
  void _checkAuthentication(String memberName) {
    _authRepository.checkAuthentication(_debugName, memberName);
  }

  @override
  Future<DataCollection> getAssuntos() async {
    assert(Debug.print('[INFO] Chamando $_debugName.getAssuntos()...'));
    _checkAuthentication('getAssuntos()');
    final table = DbConst.kDbDataCollectionAssuntos;
    try {
      assert(Debug.print('[INFO] Solicitando os dados da coleção "$table"...'));
      final response = await (await client)
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
          '[ERROR] Erro ao solicitar os dados da coleção "$table".'));
      rethrow;
    }
  }

  @override
  Future<DataCollection> getQuestoes() async {
    assert(Debug.print('[INFO] Chamando $_debugName.getQuestoes()...'));
    _checkAuthentication('getQuestoes()');
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados da coleção "$view_questoes"...'));
      final response =
          await (await client).from(view_questoes).select().execute();
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
          '[ERROR] Erro ao solicitar os dados da coleção "$view_questoes".'));
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
      final response = await (await client)
          .from('assunto_x_assunto_pai')
          .insert(data)
          .execute();
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
  Future<bool> setQuestao(DataQuestao data) async {
    assert(Debug.print('[INFO] Chamando $_debugName.setQuestao()...'));
    _checkAuthentication('setQuestao()');
    try {
      assert(Debug.print('[INFO] Inserindo a questão ${data.toString()}...'));
      final response =
          await (await client).from(view_questoes).insert(data).execute();
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
      assert(Debug.print(
          '[ERROR] Erro ao inserir a questão ${data.toString()}.'));
      rethrow;
    }
  }
}

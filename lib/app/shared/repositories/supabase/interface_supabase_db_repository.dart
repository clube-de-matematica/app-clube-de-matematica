import 'dart:async';

import 'package:clubedematematica/app/shared/models/debug.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';

import '../../utils/strings_db.dart';
import '../firebase/auth_repository.dart';
import '../interface_db_repository.dart';
import '../mixin_db_repository.dart';

/// O objeto [Map] usado pelo [Supabase] nas operações com o banco de dados.
///
/// Os valores desse objeto devem estar codificados.
typedef DataSupabaseDb = Map<String, dynamic>;

///Gerencia a conexão com o banco de dados Supabase.
class SupabaseDbRepository
    with DbRepositoryMixin
    implements IRemoteDbRepository {
  static const _debugName = "SupabaseDbRepository";
  final SupabaseClient supabase;
  //final AuthRepository _authRepository;

  SupabaseDbRepository(this.supabase);
  /* , AuthRepository authRepository)
      : _authRepository = authRepository; */

  /// Lançará uma exceção se não houver um usuário conectado.
  void _checkAuthentication(String memberName) {
    //_authRepository.checkAuthentication(_debugName, memberName);
  }

  @override
  Future<DataCollection> getAssuntos() async {
    final response = await supabase
        .from(DbConst.kDbDataCollectionAssuntos)
        .select()
        .execute();
    return response.data;
  }

  @override
  Future<DataCollection> getQuestoes() async {
    final response = await supabase.from('view_questoes').select().execute();
    return response.data;
  }

  /// [data] tem a estrutura {"assunto": [String], "id_assunto_pai": [int?]}.
  @override
  Future<bool> setAssunto(DataAssunto data) async {
    final response = await supabase
        .from('assunto_x_assunto_pai')
        //.from('new2')
        .insert(data)
        //.insert([{"assunto": 'novo assunto 2'}])
        //.insert([{"valor": 'novo assunto 1'}])
        //.insert([{"valor": 'novo assunto 2'}])
        //.insert([{"assunto": 'novo assunto 3'},{"assunto": 'novo assunto 4'}])
        .execute();
        
        if(response.data==null) {
          Debug.printBetweenLine(response.error?.details);
          Debug.printBetweenLine(response.error?.message);
        }
        else Debug.printBetweenLine(response.data);
    return (response.count ?? 0) > 0;
  }

  @override
  Future<bool> setQuestao(DataQuestao data) async {
    final response =
        await supabase.from('view_questoes').insert(data).execute();
    return (response.count ?? 0) > 0;
  }

  /// =========================================

  @override
  Future<DataCollection> getCollection(CollectionType collection) {
    throw UnimplementedError();
  }

  @override
  Future<DataDocument> getDoc(DataWhere where) {
    throw UnimplementedError();
  }

  @override
  Future<bool> setDocumentIfNotExist(
      CollectionType collection, Map<String, dynamic> data,
      {String? id}) {
    throw UnimplementedError();
  }

  // @override
  // String getDocId(ref) => (ref as DocumentReference).id;

}

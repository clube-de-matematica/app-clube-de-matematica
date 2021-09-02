import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/debug.dart';
import '../../utils/strings_db.dart';
import '../interface_db_repository.dart';
import '../mixin_db_repository.dart';
import 'auth_repository.dart';

/// O objeto [Map] usado pelo [FirebaseFirestore] nas operações com o banco de dados.
///
/// Os valores desse objeto devem estar codificados.
typedef DataFirestore = Map<String, dynamic>;

///Gerencia a conexão com o Firebase Firestore.
class FirestoreRepository with DbRepositoryMixin implements IDbRepository {
  static const _debugName = "FirestoreRepository";
  final FirebaseFirestore firestore;
  final AuthRepository _authRepository;

  FirestoreRepository(this.firestore, AuthRepository authRepository)
      : _authRepository = authRepository;

  /// Lançará uma exceção se não houver um usuário conectado.
  void _checkAuthentication(String memberName) {
    _authRepository.checkAuthentication(_debugName, memberName);
  }

  /// Retorna um objeto [CollectionReference] associado a [collection].
  CollectionReference<DataFirestore> _getCollectionRef(
          CollectionType collection) =>
      firestore.collection(collection.name);

  @override
  Future<DataCollection> getCollection(
    CollectionType collection, {
    FutureOr<DataCollection> onError(Object error)?,
  }) async {
    assert(Debug.print("[INFO] Chamando $_debugName.getCollection..."));

    _checkAuthentication("getCollection()");

    final collectionRef = _getCollectionRef(collection);
    try {
      assert(Debug.print(
          "[INFO] Solicitando os dados da coleção \"${collection.name}\"..."));
      return (await collectionRef.get())
          .docs
          .map((e) => _decode(e.data(), collection))
          .toList();
    } catch (error) {
      assert(Debug.print(
          "[ERROR] Erro ao solicitar os dados da coleção \"${collection.name}\"."));
      if (onError != null) {
        assert(Debug.print("[INFO] Chamando a função \"onError\"..."));
        return onError(error);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<DataDocument> getDoc(
    DataWhere where, {
    FutureOr<DataDocument> onError(Object error)?,
  }) async {
    assert(Debug.print("[INFO] Chamando $_debugName.getDoc..."));

    _checkAuthentication("getDoc()");
    final args = where.args;
    final collectionRef = _getCollectionRef(where.collection);

    /// Usado quando `args` contém o id do documento.
    DocumentReference<DataFirestore>? docRef;

    /// Usado quando `args` não contém o id do documento.
    Query<DataFirestore> query = collectionRef;

    /// Se a chave não existir, `args[DbConst.kDbDataItemKeyId]` retorn `null`.
    final String id = args[DbConst.kDbDataQuestaoKeyId] ?? '';
    if (where.collection == CollectionType.questoes && id.isNotEmpty) {
      docRef = collectionRef.doc(id);
    } else {
      _encode(where.args, where.collection).forEach((key, value) {
        query = query.where(key, isEqualTo: value);
      });
    }

    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados de "${where.collection.name}" onde '
          '\n"${args.toString().replaceAll(",", ",\n")}"...'));
      DataFirestore? data;
      if (docRef != null) {
        data = (await docRef.get()).data();
      } else {
        final snapshots = (await query.get()).docs;
        if (snapshots.isNotEmpty) {
          data = snapshots[0].data();
        }
      }
      return data == null ? DataDocument() : _decode(data, where.collection);
    } catch (error) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados de "${where.collection.name}".'));
      if (onError != null) {
        assert(Debug.print('[INFO] Chamando a função "onError"...'));
        return onError(error);
      } else {
        rethrow;
      }
    }
  }

  Future<bool> setDocumentIfNotExist(
    CollectionType collection,
    DataDocument data, {
    String? id,
    FutureOr<bool> onExist()?,
    VoidCallback? onSuccess,
    FutureOr<bool> onError(Object error)?,
  }) async {
    assert(Debug.print("[INFO] Chamando $_debugName.setDocumentIfNotExist..."));
    assert(Debug.print("[INFO] Verificando altenticação..."));

    _checkAuthentication("setDocumentIfNotExist()");

    final _ref = _getCollectionRef(collection).doc(id);
    assert(Debug.print("[INFO] Iniciando transação..."));
    return firestore.runTransaction<bool>((transaction) async {
      assert(Debug.print(
          "[INFO] Verificando de o documento \"${_ref.path}\" já existe..."));

      if (id != null) {
        ///Fazer uma consulta para verificar se já existe um documento com a referência fornecida.
        final snapshot = await transaction.get(_ref);
        if (snapshot.exists) {
          assert(Debug.print(
              "[INFO] O documento \"${snapshot.reference.path}\" já existe."));
          if (onExist != null) {
            assert(Debug.print("[INFO] Chamando a função \"onExist\"..."));
            return onExist();
          } else {
            return false;
          }
        }
      }
      assert(Debug.print("[INFO] Inserindo o documento \"${_ref.path}\"..."));
      transaction.set(_ref, _encode(data, collection));
      return true;
    }).then((success) {
      assert(Debug.print("[INFO] Transação concluída com \"$success\"."));
      if (success && onSuccess != null) {
        assert(Debug.print("[INFO] Chamando a função \"onSuccess\"..."));
        onSuccess();
      }
      return success;
    }).catchError((error) {
      if (onError != null) {
        assert(Debug.print("[INFO] Chamando a função \"onError\"..."));
        return onError(error);
      } else {
        assert(Debug.print(error));
        return false;
      }
    });
  }

  /// Codifica os dados para serem inseridos no banco de dados.
  DataFirestore _encode(DataDocument data, CollectionType collection) {
    if (collection == CollectionType.questoes &&
        data.containsKey(DbConst.kDbDataQuestaoKeyReferencia)) {
      // Substituir o objeto de referência pelo id.
      final idRef = data[DbConst.kDbDataQuestaoKeyReferencia] as String;
      final ref = _getCollectionRef(collection).doc(idRef);
      data[DbConst.kDbDataQuestaoKeyReferencia] = ref;
    }
    return data;
  }

  /// Decodifica os dados retornados do banco de dados.
  DataDocument _decode(DataFirestore data, CollectionType collection) {
    if (collection == CollectionType.questoes &&
        data.containsKey(DbConst.kDbDataQuestaoKeyReferencia)) {
      // Substituir o objeto de referência pelo id.
      final idRef =
          (data[DbConst.kDbDataQuestaoKeyReferencia] as DocumentReference).id;
      data[DbConst.kDbDataQuestaoKeyReferencia] = idRef;
    }
    return data;
  }

  // @override
  // String getDocId(ref) => (ref as DocumentReference).id;

}

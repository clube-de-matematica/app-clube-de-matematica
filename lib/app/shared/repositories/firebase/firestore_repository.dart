import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../modules/quiz/shared/utils/strings_db_remoto.dart';
import '../../models/debug.dart';
import '../interface_db_repository.dart';
import 'auth_repository.dart';

///Gerencia a conexão com o Firebase Firestore.
class FirestoreRepository implements IDbRepository {
  static const _debugName = "FirestoreRepository";
  final FirebaseFirestore firestore;
  final AuthRepository _authRepository;

  FirestoreRepository(this.firestore, AuthRepository authRepository)
      : _authRepository = authRepository;

  @override
  String get pathAssuntos =>
      firestore.collection(DB_FIRESTORE_COLEC_ASSUNTOS).path;

  @override
  String get pathItens => firestore.collection(DB_FIRESTORE_COLEC_ITENS).path;

  /// Retorna um objeto [CollectionReference] associado ao [path].
  CollectionReference<Map<String, dynamic>> _getCollectionRef(String path) =>
      firestore.collection(path);

  @override
  Future<DataCollection> getCollection(
    String path, {
    FutureOr<DataCollection> onError(Object error)?,
  }) async {
    assert(Debug.print("[INFO] Chamando FirestoreRepository.getCollection..."));
    final collection = _getCollectionRef(path);
    
    assert(Debug.print("[INFO] Verificando altenticação..."));
    if (!_authRepository.connected) {
      assert(Debug.print("[ERROR] Usuário não altenticado."));
      throw MyExceptionAuthRepository(
        originClass: _debugName,
        originField: "getCollection()",
        type: TypeErroAuthentication.unauthenticatedUser,
      );
    } else {
      try {
        assert(
            Debug.print("[INFO] Solicitando os dados da coleção \"$path\"..."));
        return (await collection.get()).docs.map((e) => e.data()).toList();
      } catch (error) {
        assert(Debug.print(
            "[ERROR] Erro ao solicitar os dados da coleção \"$path\"."));
        if (onError != null) {
          assert(Debug.print("[INFO] Chamando a função \"$onError\"..."));
          return onError(error);
        } else {
          rethrow;
        }
      }
    }
  }

  @override
  Future<DataDocument> getDoc(
    String collectionPath,
    String id, {
    FutureOr<DataDocument> onError(Object error)?,
  }) async {
    assert(Debug.print("[INFO] Chamando FirestoreRepository.getDoc..."));
    final docRef = _getCollectionRef(collectionPath).doc(id);

    assert(Debug.print("[INFO] Verificando altenticação..."));
    if (!_authRepository.connected) {
      assert(Debug.print("[ERROR] Usuário não altenticado."));
      throw MyExceptionAuthRepository(
        originClass: _debugName,
        originField: "getCollection()",
        type: TypeErroAuthentication.unauthenticatedUser,
      );
    } else {
      try {
        assert(Debug.print(
            "[INFO] Solicitando os dados de \"${docRef.path}\"..."));
        final snapshot = await docRef.get();
        return snapshot.data() ?? DataDocument();
      } catch (error) {
        assert(Debug.print(
            "[ERROR] Erro ao solicitar os dados de \"${docRef.path}\"."));
        if (onError != null) {
          assert(Debug.print("[INFO] Chamando a função \"$onError\"..."));
          return onError(error);
        } else {
          rethrow;
        }
      }
    }
  }

  @override
  String getDocId(ref) => (ref as DocumentReference).id;

  Future<bool> setDocumentIfNotExist(
    String collectionPath,
    Map<String, dynamic> data, {
    String? id,
    FutureOr<bool> onExist()?,
    VoidCallback? onSuccess,
    FutureOr<bool> onError(Object error)?,
  }) async {
    assert(Debug.print(
        "[INFO] Chamando FirestoreRepository.setDocumentIfNotExist..."));
    assert(Debug.print("[INFO] Verificando altenticação..."));
    if (!_authRepository.connected) {
      assert(Debug.print("[ERROR] Usuário não altenticado."));
      throw MyExceptionAuthRepository(
        originClass: _debugName,
        originField: "setDocumentIfNotExist()",
        type: TypeErroAuthentication.unauthenticatedUser,
      );
    }
    final _ref = _getCollectionRef(collectionPath).doc(id);
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
            assert(Debug.print("[INFO] Chamando a função \"$onExist\"..."));
            return onExist();
          } else {
            return false;
          }
        }
      }
      assert(Debug.print("[INFO] Inserindo o documento \"${_ref.path}\"..."));
      transaction.set(_ref, data);
      return true;
    }).then((success) {
      assert(Debug.print("[INFO] Transação concluída com \"$success\"."));
      if (success && onSuccess != null) {
        assert(Debug.print("[INFO] Chamando a função \"$onSuccess\"..."));
        onSuccess();
      }
      return success;
    }).catchError((error) {
      if (onError != null) {
        assert(Debug.print("[INFO] Chamando a função \"$onError\"..."));
        return onError(error);
      } else {
        assert(Debug.print(error));
        return false;
      }
    });
  }
}

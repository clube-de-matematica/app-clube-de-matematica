import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/exceptions/my_exception.dart';
import 'auth_repository.dart';

///Gerencia a conexão com o Firebase Firestore.
class FirestoreRepository {
  static const _className = "FirestoreRepository";
  final FirebaseFirestore firestore;
  final AuthRepository _authRepository;

  FirestoreRepository(this.firestore, AuthRepository authRepository)
      : _authRepository = authRepository;

  ///Retorna os dados da coleção [collection] no banco de dados.
  Future<QuerySnapshot> getCollection(CollectionReference collection,
      {onError(error)?}) async {
    if (!_authRepository.connected)
      throw MyExceptionAuthRepository(
          originClass: _className,
          originField: "getCollection()",
          type: TypeErroAuthentication.unauthenticatedUser);
    else
      try {
        return collection.get();
      } catch (error) {
        if (onError != null) return onError(error);
        throw MyExceptionFirestoreRepository(
            error: error,
            originField: "getCollection()",
            fieldDetails: "{collection: ${collection.path}}",
            type: TypeErroFirestoreRepository.getCollection);
      }
  }

  ///Salvar [data] em [ref] se ainda não existir um documento em [ref].
  ///Se fornecida, [onExist] será executada quando já existir um documento em [ref].
  ///Se fornecida, [onSuccess] será executada quando o documento for inserido com exito.
  ///Se fornecida, [onError] será executada quando ocorrer um erro na transação.
  ///################################################################################
  ///Ainda é necessário testar se as funções [onError], [onSuccess] e [onExist] estão
  ///sendo executadas corretamente.
  ///################################################################################
  Future<bool> setDocumentIfNotExist(
      DocumentReference ref, Map<String, dynamic> data,
      {Function()? onExist, Function()? onSuccess, onError(error)?}) async {
    if (!_authRepository.connected)
      throw MyExceptionAuthRepository(
          originClass: _className,
          originField: "setDocumentIfNotExist()",
          type: TypeErroAuthentication.unauthenticatedUser);
    return firestore.runTransaction<bool>((transaction) async {
      ///Fazer uma consulta para verificar se já existe um documento com a referência fornecida.
      final snapshot = await transaction.get(ref);
      if (snapshot.exists) {
        if (onExist != null) {
          onExist();
          return false;
        }
        throw MyExceptionFirestoreRepository(
            originField: "setDocumentIfNotExist()",
            fieldDetails:
                "{Referência: ${ref.path}, Documento não inserido: $data}",
            causeError: "Documento já existente: ${snapshot.data()}",
            type: TypeErroFirestoreRepository.setDocumentExisting);
      } else {
        transaction.set(ref, data);
        return true;
      }
    }).then((success) {
      if (success && onSuccess != null) onSuccess();
      return success;
    }).catchError((error) {
      if (onError != null) {
        onError(error);
        return false;
      }
      throw MyExceptionFirestoreRepository(
          error: error,
          originField: "setDocumentIfNotExist()",
          fieldDetails:
              "{Referência: ${ref.path}, Documento não inserido: $data}",
          type: TypeErroFirestoreRepository.setDocument);
    });
  }
}

///Uma enumeração para todos os tipos de erro [MyExceptionFirestoreRepository].
///[getCollection]: [_MSG_ERRO_GET_COLLECTION].
///[setDocumentExisting]: [_MSG_ERRO_SET_DOCUMENT_EXIST].
///[setDocument]: [_MSG_ERRO_SET_DOCUMENT].
enum TypeErroFirestoreRepository {
  getCollection,
  setDocumentExisting,
  setDocument,
}

///Mensagem para o erro [TypeErroFirestoreRepository.getCollection].
const _MSG_ERRO_GET_COLLECTION = "Falha ao buscar a coleção no banco de dados.";

///Mensagem para o erro [TypeErroFirestoreRepository.setDocumentExisting].
const _MSG_ERRO_SET_DOCUMENT_EXIST =
    "Operação abortada. Já existe um documento na referência fornecida.";

///Mensagem para o erro [TypeErroFirestoreRepository.getCollection].
const _MSG_ERRO_SET_DOCUMENT =
    "Falha ao inserir o documento no banco de dados.";

class MyExceptionFirestoreRepository extends MyException {
  MyExceptionFirestoreRepository({
    String? message,
    Object? error,
    String? originField,
    String? fieldDetails,
    String? causeError,
    TypeErroFirestoreRepository? type,
  }) : super(
          (type == null) ? null : _getMessage(type),
          error: error,
          originClass: FirestoreRepository._className,
          originField: originField,
          fieldDetails: fieldDetails,
          causeError: causeError,
        );

  ///Retorna a mensagem correspondente ao tipo do erro em [type].
  static String _getMessage(TypeErroFirestoreRepository type) {
    switch (type) {
      case TypeErroFirestoreRepository.getCollection:
        return _MSG_ERRO_GET_COLLECTION;
      case TypeErroFirestoreRepository.setDocumentExisting:
        return _MSG_ERRO_SET_DOCUMENT_EXIST;
      case TypeErroFirestoreRepository.setDocument:
        return _MSG_ERRO_SET_DOCUMENT;
    }
  }
}

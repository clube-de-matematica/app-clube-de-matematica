import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/exceptions/my_exception.dart';

import 'auth_repository.dart';

///Gerencia a conexão com o Firebase Firestore.
class FirestoreRepository {
  final FirebaseFirestore firestore;
  final AuthRepository _authRepository;

  FirestoreRepository(this.firestore, AuthRepository authRepository): 
  _authRepository = authRepository;

  ///Retorna os dados da coleção [collection] no banco de dados.
  Future<QuerySnapshot> getCollection(
    CollectionReference collection, 
    {onError(error)}
  ) async {
    if (!_authRepository.loggedAnonymously) throw MyExceptionAuthRepository();
    else try {
      return collection.get();
    } catch (error) {
      if (onError != null) return onError(error);
      throw MyExceptionFirestoryRepository(
        error: error, 
        detalhes: "{collection: ${collection.path}}",
        type: TypeErroFirestoryRepository.getCollection
      );
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
    DocumentReference ref, 
    Map<String, dynamic> data,
    {Function() onExist, 
    Function() onSuccess, 
    onError(error)}
  ) async {
    if (!_authRepository.loggedAnonymously) throw MyExceptionAuthRepository();
    return firestore.runTransaction<bool>((transaction) async {
      ///Fazer uma consulta para verificar se já existe um documento com a referência fornecida.
      /* final snapshot = await transaction.get(ref);
      if (snapshot.exists) {
        if (onExist != null) return onExist();
        throw MyExceptionFirestoryRepository(
          detalhes: "{Referência: ${ref.path}, \n"
              "Documento já existente: ${snapshot.data()}, \n"
              "Documento não inserido: $data}",
          type: TypeErroFirestoryRepository.setDocumentExisting
        );
      } */
      transaction.set(ref, data);
      return true;
    }).then((_){
      if (onSuccess != null) return onSuccess();
      return true;
    }).catchError((error){
      if (onError != null) return onError(error);
      throw MyExceptionFirestoryRepository(
        detalhes: "{Referência: ${ref.path}, \n"
              "Documento não inserido: $data}",
        error: error,
        type: TypeErroFirestoryRepository.setDocument
      );
    });
  }
}

///Uma enumeração para todos os tipos de erro [MyExceptionFirestoryRepository].
///[getCollection]: [_MSG_ERRO_GET_COLLECTION].
///[setDocumentExisting]: [_MSG_ERRO_SET_DOCUMENT_EXIST].
///[setDocument]: [_MSG_ERRO_SET_DOCUMENT].
enum TypeErroFirestoryRepository {
  getCollection,
  setDocumentExisting,
  setDocument,
}

///Mensagem para o erro [TypeErroFirestoryRepository.getCollection].
const _MSG_ERRO_GET_COLLECTION = "Falha ao buscar a coleção no banco de dados.";
///Mensagem para o erro [TypeErroFirestoryRepository.setDocumentExisting].
const _MSG_ERRO_SET_DOCUMENT_EXIST = "Operação abortada. Já existe um documento na referência fornecida.";
///Mensagem para o erro [TypeErroFirestoryRepository.getCollection].
const _MSG_ERRO_SET_DOCUMENT = "Falha ao inserir o documento no banco de dados.";

class MyExceptionFirestoryRepository extends MyException {
  final TypeErroFirestoryRepository type;

  MyExceptionFirestoryRepository._(
    {String message, 
    Exception error,
    String detalhes,
    this.type}) : super(message, error, detalhes);

  factory MyExceptionFirestoryRepository(
    {String message, 
    Exception error,
    String detalhes,
    TypeErroFirestoryRepository type}
  ) {
    if (type != null) message = _getMessage(type);
    return MyExceptionFirestoryRepository._(
      message: message, 
      error: error, 
      detalhes: detalhes, 
      type: type
    );
  }

  ///Retorna a mensagem correspondente ao tipo do erro em [type].
  static String _getMessage(TypeErroFirestoryRepository type){
    switch (type) {
      case TypeErroFirestoryRepository.getCollection:
        return _MSG_ERRO_GET_COLLECTION;
      case TypeErroFirestoryRepository.setDocumentExisting:
        return _MSG_ERRO_SET_DOCUMENT_EXIST;
      case TypeErroFirestoryRepository.setDocument:
        return _MSG_ERRO_SET_DOCUMENT;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return "MyExceptionFirestoryRepository (${super.toString()})";
  }
}

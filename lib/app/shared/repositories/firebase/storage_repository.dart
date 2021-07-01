import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/exceptions/my_exception.dart';
import 'auth_repository.dart';

///Gerencia a conexão com o Firebase Strorage.
class StorageRepository {
  static const _className = "StorageRepository";
  final FirebaseStorage storage;
  final AuthRepository _authRepository;

  StorageRepository(this.storage, AuthRepository authRepository)
      : _authRepository = authRepository;

  ///Retorna o arquivo referenciado após fazer o download e salvar em [fileTemp].
  ///Se ocorrer um erro ele será repassado e precisa ser tratado na sequência da pilha.
  Future<File> downloadFile(Reference ref, File fileTemp) async {
    ///Verificar se há algum usuário logado.
    if (!_authRepository.connected)
      throw MyExceptionAuthRepository(
          originClass: _className,
          originField: "downloadFile()",
          type: TypeErroAuthentication.unauthenticatedUser);

    ///Fazer o download e salvar em [fileTemp].
    return ref
        .writeToFile(fileTemp)

        ///Retornar [fileTemp] após o download bem sucedido.
        .then<File>((_) => fileTemp)

        ///Repassar o erro, caso ocorra.
        .catchError((error) => throw MyExceptionStorageRepository(
            error: error,
            originField: "downloadFile()",
            fieldDetails:
                "{Origem: ${ref.fullPath}, \nDestino: ${fileTemp.path}}",
            type: TypeErroStorageRepository.downloadFile));
  }

  ///Retorna assincronamente uma URL para download do arquivo no Firebase Storage.
  ///Se ocorrer um erro ele será repassado e precisa ser tratado na sequência da pilha.
  Future<String> getUrlInDb(Reference ref) async {
    ///Verificar se há algum usuário logado.
    if (!_authRepository.connected)
      throw MyExceptionAuthRepository(
          originClass: _className,
          originField: "getUrlInDb()",
          type: TypeErroAuthentication.unauthenticatedUser);
    try {
      ///Buscar a URL.
      return ref.getDownloadURL();
    } on FirebaseException catch (error) {
      //Repassar o erro, caso ocorra.
      throw MyExceptionStorageRepository(
          error: error,
          originField: "getUrlInDb()",
          fieldDetails: "{Referência do arquivo: ${ref.fullPath}}",
          type: TypeErroStorageRepository.getUrlInDb);
    }
  }

  ///Busca os metadados do arquivo em [ref].
  ///Se ocorrer um erro ele será repassado e precisa ser tratado na sequência da pilha.
  Future<FullMetadata> getMetadados(Reference ref) async {
    ///Verificar se há algum usuário logado.
    if (!_authRepository.connected)
      throw MyExceptionAuthRepository(
          originClass: _className,
          originField: "getMetadados()",
          type: TypeErroAuthentication.unauthenticatedUser);
    try {
      ///Buscar os metadados.
      return ref.getMetadata();
    } on FirebaseException catch (error) {
      throw MyExceptionStorageRepository(
          error: error,
          originField: "getMetadados()",
          fieldDetails: "{Referência do arquivo: ${ref.fullPath}}",
          type: TypeErroStorageRepository.getMetadata);
    }
  }

  ///Faz o upload de [file] em [ref] no Firebase Storage.
  ///Se ocorrer um erro ele será repassado e precisa ser tratado na sequência da pilha.
  Future<bool> uploadFile(Reference ref, File file,
      [SettableMetadata? metadata]) async {
    ///Verificar se há algum usuário logado.
    if (!_authRepository.connected)
      throw MyExceptionAuthRepository(
          originClass: _className,
          originField: "uploadFile()",
          type: TypeErroAuthentication.unauthenticatedUser);
    return ref
        .putFile(file, metadata)

        ///Retornar `true` após o upload bem sucedido.
        .then<bool>((_) => true)

        ///Repassar o erro, caso ocorra.
        .catchError((error) => throw MyExceptionStorageRepository(
            error: error,
            originField: "uploadFile()",
            fieldDetails: "{Origem: ${file.path}, \nDestino: ${ref.fullPath}"
                "${metadata == null ? "" : ', \nMetadados: ' + metadata.toString()}}",
            type: TypeErroStorageRepository.uploadFile));
  }
}

///Uma enumeração para todos os tipos de erro [MyExceptionStorageRepository].
///[downloadFile]: [_MSG_ERRO_DOWNLOAD_FILE].
///[getUrlInDb]: [_MSG_ERRO_DOWNLOAD_URL].
///[getMetadata]: [_MSG_ERRO_DOWNLOAD_METADATA].
///[uploadFile]: [_MSG_ERRO_UPLOAD_FILE].
enum TypeErroStorageRepository {
  downloadFile,
  getUrlInDb,
  getMetadata,
  uploadFile
}

///Mensagem para o erro [TypeErroStorageRepository.downloadFile].
const _MSG_ERRO_DOWNLOAD_FILE =
    "Ocorreu um erro ao fazer o download do arquivo.";

///Mensagem para o erro [TypeErroStorageRepository.getUrlInDb].
const _MSG_ERRO_DOWNLOAD_URL =
    "Ocorreu um erro ao solicitar a URL de download.";

///Mensagem para o erro [TypeErroStorageRepository.getMetadata].
const _MSG_ERRO_DOWNLOAD_METADATA =
    "Ocorreu um erro ao fazer o download dos metadados do arquivo.";

///Mensagem para o erro [TypeErroStorageRepository.uploadFile].
const _MSG_ERRO_UPLOAD_FILE = "Ocorreu um erro ao fazer o download do arquivo.";

class MyExceptionStorageRepository extends MyException {
  MyExceptionStorageRepository({
    String? message,
    Object? error,
    String? originField,
    String? fieldDetails,
    String? causeError,
    TypeErroStorageRepository? type,
  }) : super(
          (type == null) ? null : _getMessage(type),
          error: error,
          originClass: StorageRepository._className,
          originField: originField,
          fieldDetails: fieldDetails,
          causeError: causeError,
        );

  ///Retorna a mensagem correspondente ao tipo do erro em [type].
  static String? _getMessage(TypeErroStorageRepository type) {
    switch (type) {
      case TypeErroStorageRepository.downloadFile:
        return _MSG_ERRO_DOWNLOAD_FILE;
      case TypeErroStorageRepository.getUrlInDb:
        return _MSG_ERRO_DOWNLOAD_URL;
      case TypeErroStorageRepository.getMetadata:
        return _MSG_ERRO_DOWNLOAD_METADATA;
      case TypeErroStorageRepository.uploadFile:
        return _MSG_ERRO_UPLOAD_FILE;
      default:
        return null;
    }
  }
}

/* 
  reconstruirDb() async {
    final firestoreRepository = Modular.get<FirestoreRepository>();
    final firestore = firestoreRepository.firestore;
    final itens = await firestoreRepository
        .getCollection(firestore.collection(DB_COLECAO_QUESTOES));
    final newItensRef = firestore.collection(NEW_DB_COLECAO_ITENS);
    final itensStorageRef = storage.ref().child(DB_COLECAO_QUESTOES);
    final newItensStorageRef = storage.ref().child(DB_STORAGE_ITENS_IMAGENS);
    
    for (var snapshot in itens.docs) {
      ///Criar um [Map] do item.
      final map = snapshot.data();
//////////////
      print("Configurando ${map[DB_DOC_QUESTAO_ID]}");
      if (map.containsKey(DB_DOC_QUESTAO_REFERENCIA)) {
        final novo = Map<String, dynamic>();
        novo[DB_DOC_QUESTAO_ID] = map[DB_DOC_QUESTAO_ID];
        novo[DB_DOC_QUESTAO_NIVEL] = map[DB_DOC_QUESTAO_NIVEL];
        novo[DB_DOC_QUESTAO_INDICE] = map[DB_DOC_QUESTAO_INDICE];
        final newRef = 
            newItensRef.doc((map[DB_DOC_QUESTAO_REFERENCIA] as DocumentReference).id);
        novo[DB_DOC_QUESTAO_REFERENCIA] = newRef;

//////////////
      print("Inserindo ${map[DB_DOC_QUESTAO_ID]}");
        await firestoreRepository.setDocumentIfNotExist(
          newItensRef.doc(snapshot.id), 
          novo,
          onExist: () => print("11111111111111111111 ${snapshot.id} JÁ EXISTE."),
          onError: () => print("22222222222222222222 ${snapshot.id} ERRO AO INSERIR."),
          onSuccess: () => print("33333333333333333333 ${snapshot.id} INSERIDO."),
        );
      }
      else {
        final novo = Map<String, dynamic>();
        novo[DB_DOC_QUESTAO_ID] = map[DB_DOC_QUESTAO_ID];
        novo[DB_DOC_QUESTAO_ANO] = map[DB_DOC_QUESTAO_ANO];
        novo[DB_DOC_QUESTAO_NIVEL] = map[DB_DOC_QUESTAO_NIVEL];
        novo[DB_DOC_QUESTAO_INDICE] = map[DB_DOC_QUESTAO_INDICE];
        novo[DB_DOC_QUESTAO_DIFICULDADE] = map[DB_DOC_QUESTAO_DIFICULDADE];
        novo[NEW_DB_DOC_ITEM_ENUNCIADO] = map[DB_DOC_QUESTAO_COMANDO];
        novo[DB_DOC_QUESTAO_GABARITO] = map[DB_DOC_QUESTAO_GABARITO];
        novo[NEW_DB_DOC_ITEM_ASSUNTOS] = map[DB_DOC_QUESTAO_ASSUNTO];

        if (map.containsKey(DB_DOC_QUESTAO_IMAGENS)) {
//////////////
      print("Configurando ${NEW_DB_DOC_ITEM_IMAGENS_ENUNCIADO}");
          final listImagens = List<Map>();
          for (var imagemInfo in map[DB_DOC_QUESTAO_IMAGENS]) {
//////////////
      print("Configurando ${imagemInfo}");
            listImagens.add(
              await reconstruirImagem(imagemInfo, itensStorageRef, newItensStorageRef)
            );
          }
          novo[NEW_DB_DOC_ITEM_IMAGENS_ENUNCIADO] = listImagens;
        }

        final listalternativas = List<Map>();
//////////////
      print("Configurando ${NEW_DB_DOC_ITEM_ALTERNATIVAS}");
        for (var alternativa in map[DB_DOC_QUESTAO_ITENS]) {
          if (alternativa[DB_DOC_QUESTAO_ITENS_TIPO] == DB_DOC_QUESTAO_ITENS_TIPO_IMAGEM) {
            final novaAlternativa = Map<String, dynamic>();
            novaAlternativa[NEW_DB_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA] = 
                alternativa[DB_DOC_QUESTAO_ITENS_ITEM];
            novaAlternativa[DB_DOC_QUESTAO_ITENS_TIPO] = 
                alternativa[DB_DOC_QUESTAO_ITENS_TIPO];
//////////////
      print("Configurando alternativa de tipo imagem");
            novaAlternativa[DB_DOC_QUESTAO_ITENS_VALOR] = 
                await reconstruirImagem(
                  alternativa[DB_DOC_QUESTAO_ITENS_VALOR], 
                  itensStorageRef, 
                  newItensStorageRef
                );
            listalternativas.add(novaAlternativa);
          }
          else {
            listalternativas.add(alternativa);
          }
          novo[NEW_DB_DOC_ITEM_ALTERNATIVAS] = listalternativas;
        }
//////////////
      print("$novo");

//////////////
      print("Inserindo ${map[DB_DOC_QUESTAO_ID]} em ${newItensRef.doc(snapshot.id).toString()}");
        await firestoreRepository.setDocumentIfNotExist(
          newItensRef.doc(snapshot.id), 
          novo,
          onExist: () => print("44444444444444444444 ${snapshot.id} JÁ EXISTE."),
          onError: () => print("55555555555555555555 ${snapshot.id} ERRO AO INSERIR."),
          onSuccess: () => print("66666666666666666666 ${snapshot.id} INSERIDO."),
        );
      }
    }
    
  }

  Future<Map<String, dynamic>> reconstruirImagem(
    imagemInfo, StorageReference itensStorageRef, 
    StorageReference newItensStorageRef
  ) async {
      final imagem = Map<String, dynamic>();
//////////////
      print("Baixando ${imagemInfo} para /data/user/0/com.sslourenco.clubedematematica/app_flutter/$imagemInfo");
      final file = await downloadFile(
        itensStorageRef.child(imagemInfo),
        File('/data/user/0/com.sslourenco.clubedematematica/app_flutter/$imagemInfo')
      );
      final size = ImageSizeGetter.getSize(FileInput(file));
      
//////////////
      print("Criando metadados");
      final metadata = StorageMetadata(
        customMetadata: <String, String>{
          DB_STORAGE_IMAGEM_METADATA_WIDTH: size.width.toDouble().toString(),
          DB_STORAGE_IMAGEM_METADATA_HEIGHT: size.height.toDouble().toString()
        },
      );
//////////////
      print("Subindo ${imagemInfo} para ${newItensStorageRef.child(imagemInfo).toString()}");
      await uploadFile(newItensStorageRef.child(imagemInfo), file, metadata);

//////////////
      print("Configurando map imágem");
      imagem[NEW_DB_DOC_ITEM_IMAGENS_NOME] = imagemInfo;
      imagem[NEW_DB_DOC_ITEM_IMAGENS_LARGURA] = size.width.toDouble();
      imagem[NEW_DB_DOC_ITEM_IMAGENS_ALTURA] = size.height.toDouble();
      return imagem;
  }
}
*/

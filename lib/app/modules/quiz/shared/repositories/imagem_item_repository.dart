import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/repositories/firebase/storage_repository.dart';
import '../../../../shared/repositories/local_storage_repository.dart';
import '../models/imagem_item_model.dart';
import '../utils/strings_db_remoto.dart';

part 'imagem_item_repository.g.dart';

///Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
///refere as imágens usadas nos itens.
class ImagemItemRepository = _ImagemItemRepositoryBase
    with _$ImagemItemRepository;

abstract class _ImagemItemRepositoryBase with Store {
  final StorageRepository storageRepository;
  final Reference dirImagensInDb;

  _ImagemItemRepositoryBase(this.storageRepository)
      : dirImagensInDb =
            storageRepository.storage.ref().child(DB_STORAGE_ITENS_IMAGENS);

  ///Lista com as imágens já carregados.
  @observable
  ObservableList<ImagemItem> imagens = <ImagemItem>[].asObservable();

  ///Adiciona um novo [ImagemItem] a [imagens].
  @action
  void _addInImagens(ImagemItem imagem) {
    if (!_existeImagem(imagem.nome)) this.imagens.add(imagem);
  }

  ///Retorna `true` se um [ImagemItem] com o mesmo [nome] já tiver sido instanciado.
  ///O método [imagens]`.any()` executa um `for` nos elementos de [imagens].
  ///O loop é interrompido assim que a condição for verdadeira.
  bool _existeImagem(String nome) {
    if (imagens.isEmpty)
      return false;
    else
      return imagens.any((element) => element.nome == nome);
  }

  /* ///Mesmo executando outra [action], será emitida apenas uma notificação.
  ///Retorna um elemento de [imagens] com base em [nome].
  ///Se não for encontrado um elemento se satisfaça `element.nome == `[nome] ele será criado.
  @action
  ImagemItem _getImagemByNome(String nome) {
    return imagens.firstWhere((element) => element.nome == nome, orElse: () {
      final imagem = ImagemItem(nome: nome);
      _addInImagens(imagem);
      return imagem;
    });
  } */

  ///Somente para Android e IOS.
  ///Retorna um arquivo de imágem.
  ///Se o arquivo da imágem não estiver salvo no dispositivo, será feito o download.
  ///[nome] não pode ser nulo.
  ///Retorna `null` se ocorrer algo errado.
  Future<File?> getImagemFile(String nome) async {
    if (!kIsWeb) {
      //Criar uma referência a um arquivo no armazenamento local.
      final file = await LocalStorageRepository.getFile(nome);

      //Se o arquivo não existe, ele será baixado.
      if (!(await file.exists())) {
        ///Fazer o download e salvar em [file].
        await _downloadImagemFile(file, nome);
      }
      return file;
    }
    return null;
  }

  ///Faz o download de uma imágem no Firebase Storage, caso não esteja no armazenamento local.
  ///Retornará `null` se o usuário não estiver logado ou ocrrer algum erro ao buscar o arquivo.
  Future<File?> _downloadImagemFile(File fileTemp, String imgNome) async {
    try {
      ///Se o arquivo não existe, ele será baixado.
      if (await fileTemp.exists()) return fileTemp;

      ///Fazer o download e salvar em `fileTemp`.
      return await storageRepository.downloadFile(
          dirImagensInDb.child(imgNome), fileTemp);
    } on MyExceptionStorageRepository catch (error) {
      print(error.toString());
      return null;
    }
  }

  ///Retorna assincronamente uma URL para download da imágem no Firebase Storage.
  ///Retornará `null` se o usuário não estiver logado ou ocrrer algum erro ao buscar os dados.
  Future<String?> getUrlImagemInDb(String nome) async {
    try {
      ///Buscar a URL. O retorno será `null` se o usuário não estiver logado.
      return storageRepository.getUrlInDb(dirImagensInDb.child(nome));
    } on MyExceptionStorageRepository catch (error) {
      print(error.toString());
      return null;
    }
  }

  ///Busca os metadados dos arquivos de imagem.
  ///Retornará `null` se o usuário não estiver logado ou ocrrer algum erro.
  Future<FullMetadata?> getMetadados({String? nome, ImagemItem? imagem}) async {
    ///Garantir que um dos atributos não seja nulo.
    assert(nome != null || imagem != null);
    if (!(nome != null || imagem != null)) return null;

    ///O operador `??=` atribui apenas se a variável for nula.
    nome ??= imagem!.nome;
    try {
      ///Buscar os metadados. O retorno será `null` se o usuário não estiver logado.
      return storageRepository.getMetadados(dirImagensInDb.child(nome));
    } on MyExceptionStorageRepository catch (error) {
      print(error.toString());
      return null;
    }
  }
}

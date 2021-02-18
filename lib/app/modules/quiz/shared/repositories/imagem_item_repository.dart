import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import '../models/imagem_item_model.dart';
import '../utils/strings_db_remoto.dart';
import '../../../../shared/repositories/firebase/storage_repository.dart';
import '../../../../shared/repositories/local_storage_repository.dart';

part 'imagem_item_repository.g.dart';

///Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se 
///refere as imágens usadas nos itens.
class ImagemItemRepository = _ImagemItemRepositoryBase with _$ImagemItemRepository;

abstract class _ImagemItemRepositoryBase with Store {
  final StorageRepository storageRepository;
  final StorageReference dirImagensInDb;

  _ImagemItemRepositoryBase(
    this.storageRepository):
    dirImagensInDb = storageRepository.storage.ref().child(DB_STORAGE_ITENS_IMAGENS);

  @observable
  ///Lista com as imágens já carregados.
  ObservableList<ImagemItem> imagens = List<ImagemItem>().asObservable();

  @action
  ///Adiciona um novo [ImagemItem] a [imagens].
  void _addInImagens(ImagemItem imagem) {
    if (!_existeImagem(imagem.nome)) this.imagens.add(imagem);
  }

  ///Retorna `true` se um [ImagemItem] com o mesmo [nome] já tiver sido instanciado.
  ///O método [imagens]`.any()` executa um `for` nos elementos de [imagens].
  ///O loop é interrompido assim que a condição for verdadeira.
  bool _existeImagem(String nome) {
    if (imagens.isEmpty) return false;
    else return imagens.any((element) => element.nome == nome);
  }

  @action ///Mesmo executando outra [action], será emitida apenas uma notificação.
  ///Retorna um elemento de [imagens] com base em [nome].
  ///Se não for encontrado um elemento se satisfaça `element.nome == `[nome] ele será criado.
  ImagemItem _getImagemByNome(String nome) {
    return imagens.firstWhere(
      (element) => element.nome == nome,
      orElse: () {
        final imagem = ImagemItem(nome: nome);
        _addInImagens(imagem);
        return imagem;
      }
    );
  }

  ///A tribui um [ImageProvider] para [imagem.provider].
  ///Se o arquivo da imágem já estiver salvo no dispositivo, ele será usado, caso contrário, 
  ///primeiro será feito o download.
  ///Ao menos um dos parâmetro não pode ser nulo.
  void setImagemProvider({String nome, ImagemItem imagem}) async {
    ///Garantir que um dos atributos não seja nulo.
    assert (nome != null || imagem != null);
    ///O operador `??=` atribui apenas se a variável for nula.
    nome ??= imagem.nome;
    imagem ??= _getImagemByNome(nome);

    ///Criar uma referência a um arquivo no armazenamento local.
    final file = await LocalStorageRepository.getFile(nome);
    ///Se o arquivo não existe, ele será baixado.
    if (!(await file.exists())) {
      ///Fazer o download e salvar em [file].
      await _downloadImagemFile(file, nome: nome, imagem: imagem);
    }
    ///Por algum motivo `scale: 0.99` melhora a resolução.
    imagem.provider = FileImage(file, scale: 0.99);
  }
  
  ///Faz o download de uma imágem no Firebase Storage, caso não esteja no armazenamento local.
  ///Retornará `null` se o usuário não estiver logado ou ocrrer algum erro ao buscar o arquivo.
  Future<File> _downloadImagemFile(
    File fileTemp, 
    {String nome, 
    ImagemItem imagem}
  ) async {
    ///Garantir condições para os atributos.
    assert (fileTemp != null);
    assert (nome != null || imagem != null);
    ///O operador `??=` atribui apenas se a variável for nula.
    nome ??= imagem.nome;
    
    try {
      ///Se o arquivo não existe, ele será baixado.
      if (await fileTemp.exists()) return fileTemp;
      ///Fazer o download e salvar em `fileTemp`.
      return await storageRepository.downloadFile(dirImagensInDb.child(nome), fileTemp);
    } on MyExceptionStorageRepository catch (error) {
      print(error.toString());
      return null;
    }
  }

  ///Retorna assincronamente uma URL para download da imágem no Firebase Storage.
  ///Retornará `null` se o usuário não estiver logado ou ocrrer algum erro ao buscar os dados.
  Future getUrlImagemInDb({String nome, ImagemItem imagem}) async {
    ///Garantir que um dos atributos não seja nulo.
    assert (nome != null || imagem != null);
    ///O operador `??=` atribui apenas se a variável for nula.
    nome ??= imagem.nome;
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
  Future<StorageMetadata> getMetadados({String nome, ImagemItem imagem}) async {
    ///Garantir que um dos atributos não seja nulo.
    assert (nome != null || imagem != null);
    ///O operador `??=` atribui apenas se a variável for nula.
    nome ??= imagem.nome;
    try {
      ///Buscar os metadados. O retorno será `null` se o usuário não estiver logado.
      return storageRepository.getMetadados(dirImagensInDb.child(nome));
    } on MyExceptionStorageRepository catch (error) {
      print(error.toString());
      return null;
    }
  }
}
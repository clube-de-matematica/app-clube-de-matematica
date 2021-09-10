import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/repositories/firebase/storage_repository.dart';
import '../../../../shared/repositories/local_storage_repository.dart';
import '../models/imagem_questao_model.dart';

part 'imagem_questao_repository.g.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere as imágens usadas nas questões.
class ImagemQuestaoRepository = _ImagemQuestaoRepositoryBase
    with _$ImagemQuestaoRepository;

abstract class _ImagemQuestaoRepositoryBase with Store {

  /// Lista com as imágens já carregados.
  @observable
  ObservableList<ImagemQuestao> imagens = <ImagemQuestao>[].asObservable();

  /// Adiciona um novo [ImagemQuestao] a [imagens].
  @action
  void _addInImagens(ImagemQuestao imagem) {
    if (!_existeImagem(imagem.name)) this.imagens.add(imagem);
  }

  /// Retorna `true` se um [ImagemQuestao] com o mesmo [nome] já tiver sido instanciado.
  /// O método [imagens]`.any()` executa um `for` nos elementos de [imagens].
  /// O loop é interrompido assim que a condição for verdadeira.
  bool _existeImagem(String nome) {
    if (imagens.isEmpty)
      return false;
    else
      return imagens.any((element) => element.name == nome);
  }

  /// Somente para Android e IOS.
  /// Retorna um arquivo de imágem.
  /// Se o arquivo da imágem não estiver salvo no dispositivo, isso será feito.
  /// Retorna `null` se ocorrer algo errado.
  Future<File?> getImagemFile(ImagemQuestao image) async {
    if (!kIsWeb) {
      // Criar uma referência a um arquivo no armazenamento local.
      final file = await LocalStorageRepository.getFile(image.name);

      // Se o arquivo não existe, ele será criado.
      if (!(await file.exists())) {
        // Salvar os bytes da imagem no arquivo.
        await file.writeAsBytes(image.uint8List);
      }
      return file;
    }
    return null;
  }
}

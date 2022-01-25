import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/repositories/local_storage_repository.dart';
import '../../../../shared/utils/app_assets.dart';
import '../../../../shared/utils/strings_db.dart';

part 'imagem_questao_model.g.dart';

///Modelo para as imágens usadas no enunciado e nas alternativas das questões.
class ImagemQuestao extends _ImagemQuestaoBase with _$ImagemQuestao {
  ImagemQuestao({
    required String name,
    required String base64,
    required double width,
    required double height,
  }) : super(
          name: name,
          base64: base64,
          width: width,
          height: height,
        );
  ImagemQuestao.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  /// Chave para [name] em objetos json.
  static const kKeyName = 'name';
}

abstract class _ImagemQuestaoBase with Store {
  _ImagemQuestaoBase({
    required this.name,
    required this.base64,
    required this.width,
    required this.height,
  });

  // ignore: unused_element
  _ImagemQuestaoBase.fromMap(Map<String, dynamic> map)
      : assert(map[ImagemQuestao.kKeyName] != null),
        name = (map[ImagemQuestao.kKeyName] as String?) ?? 'imagem.temp',
        base64 = map[DbConst.kDbDataImagemKeyBase64] as String,
        // A multiplicação faz a converção para double.
        width = map[DbConst.kDbDataImagemKeyLargura] * 1.0,
        height = map[DbConst.kDbDataImagemKeyAltura] * 1.0;

  Map<String, dynamic> toMap({bool includeName = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (includeName) data[ImagemQuestao.kKeyName] = this.name;
    data[DbConst.kDbDataImagemKeyBase64] = this.base64;
    data[DbConst.kDbDataImagemKeyLargura] = this.width;
    data[DbConst.kDbDataImagemKeyAltura] = this.height;
    return data;
  }

  /// O nome do arquivo da imagem (com a extensão).
  final String name;

  ///A codificação da imagem em string base64.
  final String base64;

  ///Largura da imágem.
  final double width;

  ///Altura da imágem.
  final double height;

  bool _loadingProvider = false;

  ///O provedor da imágem que será usado no [Widget].
  ///Será obitido prioritáriamente do arquivo.
  ///Caso o arquivo ainda não exista, será obtido do Firebase Storage.
  @observable
  ImageProvider? _provider;

  @computed
  ImageProvider? get provider {
    if (_provider == null) {
      if (!_loadingProvider) {
        _loadingProvider = true;
        _definirProvedorImagem().whenComplete(() => _loadingProvider = false);
      }
    }
    return _provider;
  }

  set provider(ImageProvider? valor) => _setProvider(valor);

  @action
  void _setProvider(ImageProvider? valor) {
    _provider = valor;
  }

  /// Decodifica [base64] para um objeto [Uint8List].
  Uint8List get uint8List => base64Decode(base64);

  /// Atribui o valor da propriedade [provider].
  Future<void> _definirProvedorImagem() async {
    if (kIsWeb)
      provider = MemoryImage(uint8List, scale: 0.99);
    else {
      final file = await _getImagemFile();
      provider = file != null
          ? FileImage(file, scale: 0.99)
          : Image.asset(AppAssets.BASELINE_IMAGE_NOT_SUPPORTED_BLACK_24DP)
              .image;
    }
  }

  /// Somente para Android e IOS.
  /// Retorna um arquivo de imágem.
  /// Se o arquivo da imágem não estiver salvo no dispositivo, isso será feito.
  /// Retorna `null` se ocorrer algo errado.
  Future<File?> _getImagemFile() async {
    if (!kIsWeb) {
      // Criar uma referência a um arquivo no armazenamento local.
      final file = await LocalStorageRepository.getFile(name);

      // Se o arquivo não existe, ele será criado.
      if (!(await file.exists())) {
        // Salvar os bytes da imagem no arquivo.
        await file.writeAsBytes(uint8List);
      }
      return file;
    }
    return null;
  }
}

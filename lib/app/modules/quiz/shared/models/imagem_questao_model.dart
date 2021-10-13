import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:mobx/mobx.dart';

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
  ImagemQuestao.fromJson(Map<String, dynamic> json) : super.fromJson(json);

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
  _ImagemQuestaoBase.fromJson(Map<String, dynamic> json)
      : name = json[ImagemQuestao.kKeyName] as String,
        base64 = json[DbConst.kDbDataImagemKeyBase64] as String,
        // A multiplicação faz a converção para double.
        width = json[DbConst.kDbDataImagemKeyLargura] * 1.0,
        height = json[DbConst.kDbDataImagemKeyAltura] * 1.0;

  Map<String, dynamic> toJson({bool includeName = false}) {
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

  ///O provedor da imágem que será usado no [Widget].
  ///Será obitido prioritáriamente do arquivo.
  ///Caso o arquivo ainda não exista, será obtido do Firebase Storage.
  @observable
  ImageProvider? _provider;

  @computed
  ImageProvider? get provider => _provider;

  set provider(ImageProvider? valor) => _setProvider(valor);

  @action
  void _setProvider(ImageProvider? valor) {
    _provider = valor;
  }

  /// Decodifica [base64] para um objeto [Uint8List].
  Uint8List get uint8List => base64Decode(base64);
}

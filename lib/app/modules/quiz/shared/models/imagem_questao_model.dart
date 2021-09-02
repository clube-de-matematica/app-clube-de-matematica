import 'package:flutter/painting.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/utils/strings_db.dart';

part 'imagem_questao_model.g.dart';

///Modelo para as imágens usadas no enunciado e nas alternativas das questões.
class ImagemQuestao = _ImagemQuestaoBase with _$ImagemQuestao;

abstract class _ImagemQuestaoBase with Store {
  _ImagemQuestaoBase({
    required this.nome,
    required this.width,
    required this.height,
  });

  // ignore: unused_element
  _ImagemQuestaoBase.fromJson(Map<String, dynamic> json)
      : nome = json[DbConst.kDbDataImagemKeyNome],
        width = json[DbConst.kDbDataImagemKeyLargura] as double,
        height = json[DbConst.kDbDataImagemKeyAltura] as double;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[DbConst.kDbDataImagemKeyNome] = this.nome;
    data[DbConst.kDbDataImagemKeyLargura] = this.width;
    data[DbConst.kDbDataImagemKeyAltura] = this.height;
    return data;
  }

  ///Nome do aquivo (com a extensão) no banco de dados.
  final String nome;

  ///Largura da imágem.
  final double width;

  ///Altura da imágem.
  final double height;

  @observable

  ///O provedor da imágem que será usado no [Widget].
  ///Será obitido prioritáriamente do arquivo.
  ///Caso o arquivo ainda não exista, será obtido do Firebase Storage.
  ImageProvider? _provider;

  @computed
  ImageProvider? get provider => _provider;

  set provider(ImageProvider? valor) => _setProvider(valor);

  @action
  void _setProvider(ImageProvider? valor) {
    _provider = valor;
  }
}

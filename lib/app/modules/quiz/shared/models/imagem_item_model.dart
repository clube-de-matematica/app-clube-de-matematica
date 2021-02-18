import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:mobx/mobx.dart';

import '../utils/strings_db_remoto.dart';

part 'imagem_item_model.g.dart';

///Modelo para as imágens usadas no enunciado e nas alternativas dos itens.
class ImagemItem = _ImagemItemBase with _$ImagemItem;

abstract class _ImagemItemBase with Store {
  _ImagemItemBase({
    @required this.nome, 
    @required this.width, 
    @required this.height,
  }): assert ((nome != null) && (width != null) && (height != null));

  _ImagemItemBase.fromJson(Map<String, dynamic> json): 
      nome = json[DB_FIRESTORE_DOC_ITEM_IMAGENS_NOME],
      width = json[DB_FIRESTORE_DOC_ITEM_IMAGENS_LARGURA] as double, 
      height = json[DB_FIRESTORE_DOC_ITEM_IMAGENS_ALTURA] as double;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[DB_FIRESTORE_DOC_ITEM_IMAGENS_NOME] = this.nome;
    data[DB_FIRESTORE_DOC_ITEM_IMAGENS_LARGURA] = this.width;
    data[DB_FIRESTORE_DOC_ITEM_IMAGENS_ALTURA] = this.height;
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
  ImageProvider _provider;

  @computed
  ImageProvider get provider => _provider;

  set provider(ImageProvider valor) => _setProvider(valor);

  @action
  void _setProvider(ImageProvider valor) {
    _provider = valor;
  }
}
import 'imagem_item_model.dart';
import '../utils/strings_db_remoto.dart';

///Contém as propriedades de uma alternativa do item.
class Alternativa {
  final String alternativa;
  final String tipo;
  final String valorSeTexto;
  final ImagemItem valorSeImagem;

  Alternativa({this.alternativa, this.tipo, this.valorSeTexto, this.valorSeImagem});

  ///Retorna uma Instância de [Alternativa] a partir de um `Map<String, dynamic>`.
  factory Alternativa.fromJson(Map<String, dynamic> json) => Alternativa(
    alternativa: json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA],
    tipo: json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO],
    valorSeTexto: json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO] == 
        DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_TEXTO 
        ? json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_VALOR] 
        : null,
    valorSeImagem: json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO] == 
        DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_IMAGEM 
        ? ImagemItem.fromJson(json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_VALOR]) 
        : null,
  );

  ///Retorna `true` se a alternativa for do tipo "texto".
  bool get isTipoTexto => tipo == DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_TEXTO;

  ///Retorna `true` se a alternativa for do tipo "imagem".
  bool get isTipoImagem => tipo == DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_IMAGEM;

  ///Retorna uma [String] com o texto da alternativa se for do tipo "texto".
  ///Se for do tipo "imagem", retorna um [ImagemItem].
  get valor => isTipoTexto ? valorSeTexto : valorSeImagem;

  ///Retorna um json com os dados da alternativa.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA] = this.alternativa;
    data[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO] = this.tipo;
    data[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_VALOR] = 
        isTipoTexto ? this.valorSeTexto : valorSeImagem.toJson();
    return data;
  }
}

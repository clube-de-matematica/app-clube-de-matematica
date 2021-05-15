import '../../../../shared/models/exceptions/my_exception.dart';
import '../utils/strings_db_remoto.dart';
import 'imagem_item_model.dart';

///Tipos de alternativas.
enum TypeAlternativa {
  texto,
  imagem,
}

///Contém as propriedades de uma alternativa do item.
class Alternativa {
  final String alternativa;
  final TypeAlternativa tipo;
  final String? valorSeTexto;
  final ImagemItem? valorSeImagem;

  Alternativa({
    required this.alternativa,
    required this.tipo,
    this.valorSeTexto,
    this.valorSeImagem,
  }) : assert((valorSeTexto != null) != /* XOR */ (valorSeImagem != null));

  ///Retorna uma Instância de [Alternativa] a partir de um `Map<String, dynamic>`.
  factory Alternativa.fromJson(Map<String, dynamic> json) => Alternativa(
        alternativa: json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA],
        tipo:
            parseTypeAlternativa(json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO]),
        valorSeTexto: json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO] ==
                DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_TEXTO
            ? json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_VALOR]
            : null,
        valorSeImagem: json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO] ==
                DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_IMAGEM
            ? ImagemItem.fromJson(
                json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_VALOR])
            : null,
      );

  ///Retorna um [TypeAlternativa] com base em [tipo].
  static TypeAlternativa parseTypeAlternativa(String tipo) {
    if (tipo == DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_TEXTO)
      return TypeAlternativa.texto;
    if (tipo == DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_IMAGEM)
      return TypeAlternativa.imagem;
    throw MyException(
      "String inválida!",
      originClass: "Alternativa",
      originField: "parseTypeAlternativa()",
      fieldDetails: "tipo == $tipo",
    );
  }

  ///Retorna uma string com base em [tipo].
  String tipoToString(TypeAlternativa tipo) {
    switch (tipo) {
      case TypeAlternativa.texto:
        return DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_TEXTO;
      case TypeAlternativa.imagem:
        return DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO_IMAGEM;
    }
  }

  ///Retorna `true` se a alternativa for do tipo "texto".
  bool get isTipoTexto => tipo == TypeAlternativa.texto;

  ///Retorna `true` se a alternativa for do tipo "imagem".
  bool get isTipoImagem => tipo == TypeAlternativa.imagem;

  ///Retorna uma [String] com o texto da alternativa se for do tipo "texto".
  ///Se for do tipo "imagem", retorna um [ImagemItem].
  get valor => isTipoTexto ? valorSeTexto : valorSeImagem;

  ///Retorna um json com os dados da alternativa.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_ALTERNATIVA] = this.alternativa;
    data[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_TIPO] = tipoToString(this.tipo);
    data[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS_VALOR] =
        isTipoTexto ? this.valorSeTexto : valorSeImagem!.toJson();
    return data;
  }
}

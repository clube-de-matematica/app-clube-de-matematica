import '../../../../shared/models/exceptions/my_exception.dart';
import '../../../../shared/utils/strings_db.dart';
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
        alternativa: json[DbConst.kDbDataAlternativaKeyAlternativa],
        tipo: parseTypeAlternativa(json[DbConst.kDbDataAlternativaKeyTipo]),
        valorSeTexto: json[DbConst.kDbDataAlternativaKeyTipo] ==
                DbConst.kDbDataAlternativaKeyTipoValTexto
            ? json[DbConst.kDbDataAlternativaKeyValor]
            : null,
        valorSeImagem: json[DbConst.kDbDataAlternativaKeyTipo] ==
                DbConst.kDbDataAlternativaKeyTipoValImagem
            ? ImagemItem.fromJson(
                json[DbConst.kDbDataAlternativaKeyValor])
            : null,
      );

  ///Retorna um [TypeAlternativa] com base em [tipo].
  static TypeAlternativa parseTypeAlternativa(String tipo) {
    if (tipo == DbConst.kDbDataAlternativaKeyTipoValTexto)
      return TypeAlternativa.texto;
    if (tipo == DbConst.kDbDataAlternativaKeyTipoValImagem)
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
        return DbConst.kDbDataAlternativaKeyTipoValTexto;
      case TypeAlternativa.imagem:
        return DbConst.kDbDataAlternativaKeyTipoValImagem;
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
    data[DbConst.kDbDataAlternativaKeyAlternativa] = this.alternativa;
    data[DbConst.kDbDataAlternativaKeyTipo] = tipoToString(this.tipo);
    data[DbConst.kDbDataAlternativaKeyValor] =
        isTipoTexto ? this.valorSeTexto : valorSeImagem!.toJson();
    return data;
  }
}

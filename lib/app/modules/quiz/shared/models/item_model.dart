import '../../../../shared/models/exceptions/my_exception.dart';
import '../../../../shared/utils/strings_db.dart';
import 'alternativa_item_model.dart';
import 'ano_item_model.dart';
import 'assunto_model.dart';
import 'dificuldade_item_model.dart';
import 'imagem_item_model.dart';
import 'nivel_item_model.dart';

///Contém as propriedades de um item.
class Item {
  ///Key para o `id` do item referenciado.
  static const kKeyIdReferencia = "id_referencia";

  ///Key para o `nivel` do item referenciado.
  static const kKeyNivelReferencia = "nivel_referencia";

  ///Key para o `indice` do item referenciado.
  static const kKeyIndiceReferencia = "indice_referencia";

  ///Se [isReferenciado] é verdadeiro, [id] será o id do item que fáz referência.
  final String id;
  final Ano ano;

  ///Se [isReferenciado] é verdadeiro, [nivel] será o nível do item que fáz referência.
  final Nivel nivel;

  ///Se [isReferenciado] é verdadeiro, [indice] será o índice do item que fáz referência.
  final int indice;
  final List<Assunto> assuntos;
  final Dificuldade dificuldade;
  final List<String> enunciado;
  final List<Alternativa> alternativas;
  final String gabarito;

  ///A lista de imágens é opcional, pois alguns enunciados não contém imágem.
  final List<ImagemItem> imagensEnunciado;

  ///[id] do item referenciado.
  final String? idReferencia;

  ///[nivel] do item referenciado.
  final Nivel? nivelReferencia;

  ///[indice] do item referenciado.
  final int? indiceReferencia;

  Item({
    required this.id,
    required this.ano,
    required this.nivel,
    required this.indice,
    required this.assuntos,
    required this.dificuldade,
    required this.enunciado,
    required this.alternativas,
    required this.gabarito,
    required this.imagensEnunciado,
    this.idReferencia,
    this.nivelReferencia,
    this.indiceReferencia,
  });

  factory Item.fromJson(
    Map<String, dynamic> json,
    List<Assunto> assuntosCarreados,
  ) {
    assert(assuntosCarreados.isNotEmpty);
    if (assuntosCarreados.isEmpty)
      throw MyException(
        "Os assuntos não foram carregados.",
        originClass: "Item",
        originField: "Item.fromJson()",
        fieldDetails:
            "assuntosCarreados == ${assuntosCarreados.toString()};\njson == ${json.toString()}",
        causeError: "assuntosCarreados está vazio.",
      );
    final _assuntos = <Assunto>[];
    final _alternativas = <Alternativa>[];

    json[DbConst.kDbDataItemKeyAssuntos].forEach((v) {
      //Se o assunto não for encontrado ocorrerá um erro.
      _assuntos.add(assuntosCarreados.firstWhere(
        (element) => element.titulo == v,
        orElse: () => throw MyException(
          "Assunto \"$v\" não encontrado.",
          originClass: "Item",
          originField: "Item.fromJson()",
          fieldDetails:
              "assuntosCarreados == ${assuntosCarreados.toString()};\njson == ${json.toString()}",
          causeError: "O assunto \"$v\" não foi encontrado.",
        ),
      ));
    });

    json[DbConst.kDbDataItemKeyAlternativas].forEach((v) {
      _alternativas.add(Alternativa.fromJson(v));
    });

    return Item(
      id: json[DbConst.kDbDataItemKeyId],
      ano: Ano(json[DbConst.kDbDataItemKeyAno]),
      nivel: Nivel(json[DbConst.kDbDataItemKeyNivel]),
      indice: json[DbConst.kDbDataItemKeyIndice],
      assuntos: _assuntos,
      dificuldade:
          Dificuldade.fromString(json[DbConst.kDbDataItemKeyDificuldade]),
      enunciado: json[DbConst.kDbDataItemKeyEnunciado].cast<String>(),
      alternativas: _alternativas,
      gabarito: json[DbConst.kDbDataItemKeyGabarito],
      imagensEnunciado: _getImagensEnunciado(json),
      idReferencia:
          json.containsKey(kKeyIdReferencia) ? json[kKeyIdReferencia] : null,
      nivelReferencia: json.containsKey(kKeyNivelReferencia)
          ? Nivel(json[kKeyNivelReferencia])
          : null,
      indiceReferencia: json.containsKey(kKeyIndiceReferencia)
          ? json[kKeyIndiceReferencia]
          : null,
    );
  }

  ///Retorna a lista de imágens do enunciado.
  ///Retorna uma lista vazia se o enunciado não tiver imágem.
  ///[jsonItem] é o json retornado do banco de dados.
  static List<ImagemItem> _getImagensEnunciado(Map<String, dynamic> jsonItem) {
    final _imagensEnunciado = <ImagemItem>[];
    if (jsonItem.containsKey(DbConst.kDbDataItemKeyImagensEnunciado)) {
      jsonItem[DbConst.kDbDataItemKeyImagensEnunciado]
          .forEach((imagemInfo) {
        _imagensEnunciado.add(ImagemItem.fromJson(imagemInfo));
      });
    }
    return _imagensEnunciado;
  }

  ///Será `true` se, no banco de dados, o item fizer referência a outro.
  bool get isReferenciado =>
      idReferencia != null &&
      nivelReferencia != null &&
      indiceReferencia != null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (isReferenciado) {
      ///Retornará um `Map` do item que faz referência.
      ///Para inserír no banco de dados é necessário adicionar
      ///`data[DB_DOC_QUESTAO_REFERENCIA] = (await FirebaseFirestore.instance).collection(DB_COLECAO_QUESTOES).doc(data[ITEM_ID_REFERENCIA_KEY])`
      ///e remover `data[ITEM_ID_REFERENCIA_KEY]` antes de enviar o `Map`.
      data[kKeyIdReferencia] = this.idReferencia;
      data[DbConst.kDbDataItemKeyId] = this.id;
      data[DbConst.kDbDataItemKeyNivel] = this.nivel.valor;
      data[DbConst.kDbDataItemKeyIndice] = this.indice;
      return data;
    } else {
      data[DbConst.kDbDataItemKeyId] = this.id;
      data[DbConst.kDbDataItemKeyNivel] = this.nivel.valor;
      data[DbConst.kDbDataItemKeyIndice] = this.indice;
      data[DbConst.kDbDataItemKeyAno] = this.ano.valor;
      if (this.assuntos.isNotEmpty) {
        data[DbConst.kDbDataItemKeyAssuntos] =
            this.assuntos.map((v) => v.titulo).toList();
      }
      data[DbConst.kDbDataItemKeyDificuldade] = this.dificuldade.toString();
      data[DbConst.kDbDataItemKeyEnunciado] = this.enunciado;
      if (this.alternativas.isNotEmpty) {
        data[DbConst.kDbDataItemKeyAlternativas] =
            this.alternativas.map((v) => v.toJson()).toList();
      }
      data[DbConst.kDbDataItemKeyGabarito] = this.gabarito;
      if (this.imagensEnunciado.isNotEmpty) {
        data[DbConst.kDbDataItemKeyImagensEnunciado] =
            this.imagensEnunciado.map((v) => v.toJson()).toList();
      }
      return data;
    }
  }
}

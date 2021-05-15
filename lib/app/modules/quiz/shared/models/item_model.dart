import '../../../../shared/models/exceptions/my_exception.dart';
import '../utils/strings_db_remoto.dart';
import 'alternativa_item_model.dart';
import 'ano_item_model.dart';
import 'assunto_model.dart';
import 'dificuldade_item_model.dart';
import 'imagem_item_model.dart';
import 'nivel_item_model.dart';

///Key para o `id` do item referenciado.
const ITEM_ID_REFERENCIA_KEY = "id_referencia";

///Key para o `nivel` do item referenciado.
const ITEM_NIVEL_REFERENCIA_KEY = "nivel_referencia";

///Key para o `indice` do item referenciado.
const ITEM_INDICE_REFERENCIA_KEY = "indice_referencia";

///Contém as propriedades de um item.
class Item {
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

    json[DB_FIRESTORE_DOC_ITEM_ASSUNTOS].forEach((v) {
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

    json[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS].forEach((v) {
      _alternativas.add(Alternativa.fromJson(v));
    });

    return Item(
      id: json[DB_FIRESTORE_DOC_ITEM_ID],
      ano: Ano(json[DB_FIRESTORE_DOC_ITEM_ANO]),
      nivel: Nivel(json[DB_FIRESTORE_DOC_ITEM_NIVEL]),
      indice: json[DB_FIRESTORE_DOC_ITEM_INDICE],
      assuntos: _assuntos,
      dificuldade:
          Dificuldade.fromString(json[DB_FIRESTORE_DOC_ITEM_DIFICULDADE]),
      enunciado: json[DB_FIRESTORE_DOC_ITEM_ENUNCIADO].cast<String>(),
      alternativas: _alternativas,
      gabarito: json[DB_FIRESTORE_DOC_ITEM_GABARITO],
      imagensEnunciado: _getImagensEnunciado(json),
      idReferencia: json.containsKey(ITEM_ID_REFERENCIA_KEY)
          ? json[ITEM_ID_REFERENCIA_KEY]
          : null,
      nivelReferencia: json.containsKey(ITEM_NIVEL_REFERENCIA_KEY)
          ? Nivel(json[ITEM_NIVEL_REFERENCIA_KEY])
          : null,
      indiceReferencia: json.containsKey(ITEM_INDICE_REFERENCIA_KEY)
          ? json[ITEM_INDICE_REFERENCIA_KEY]
          : null,
    );
  }

  ///Retorna a lista de imágens do enunciado.
  ///Retorna uma lista vazia se o enunciado não tiver imágem.
  ///[jsonItem] é o json retornado do banco de dados.
  static List<ImagemItem> _getImagensEnunciado(Map<String, dynamic> jsonItem) {
    final _imagensEnunciado = <ImagemItem>[];
    if (jsonItem.containsKey(DB_FIRESTORE_DOC_ITEM_IMAGENS_ENUNCIADO)) {
      jsonItem[DB_FIRESTORE_DOC_ITEM_IMAGENS_ENUNCIADO].forEach((imagemInfo) {
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
      data[ITEM_ID_REFERENCIA_KEY] = this.idReferencia;
      data[DB_FIRESTORE_DOC_ITEM_ID] = this.id;
      data[DB_FIRESTORE_DOC_ITEM_NIVEL] = this.nivel.valor;
      data[DB_FIRESTORE_DOC_ITEM_INDICE] = this.indice;
      return data;
    } else {
      data[DB_FIRESTORE_DOC_ITEM_ID] = this.id;
      data[DB_FIRESTORE_DOC_ITEM_NIVEL] = this.nivel.valor;
      data[DB_FIRESTORE_DOC_ITEM_INDICE] = this.indice;
      data[DB_FIRESTORE_DOC_ITEM_ANO] = this.ano.valor;
      if (this.assuntos.isNotEmpty) {
        data[DB_FIRESTORE_DOC_ITEM_ASSUNTOS] =
            this.assuntos.map((v) => v.titulo).toList();
      }
      data[DB_FIRESTORE_DOC_ITEM_DIFICULDADE] = this.dificuldade.toString();
      data[DB_FIRESTORE_DOC_ITEM_ENUNCIADO] = this.enunciado;
      if (this.alternativas.isNotEmpty) {
        data[DB_FIRESTORE_DOC_ITEM_ALTERNATIVAS] =
            this.alternativas.map((v) => v.toJson()).toList();
      }
      data[DB_FIRESTORE_DOC_ITEM_GABARITO] = this.gabarito;
      if (this.imagensEnunciado.isNotEmpty) {
        data[DB_FIRESTORE_DOC_ITEM_IMAGENS_ENUNCIADO] =
            this.imagensEnunciado.map((v) => v.toJson()).toList();
      }
      return data;
    }
  }
}

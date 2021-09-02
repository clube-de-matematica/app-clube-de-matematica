import '../../../../shared/models/exceptions/my_exception.dart';
import '../../../../shared/utils/strings_db.dart';
import 'alternativa_questao_model.dart';
import 'ano_questao_model.dart';
import 'assunto_model.dart';
import 'dificuldade_item_model.dart';
import 'imagem_questao_model.dart';
import 'nivel_questao_model.dart';

///Contém as propriedades de uma questão.
class Questao {
  ///Key para o `id` da questão referenciada.
  static const kKeyIdReferencia = "id_referencia";

  ///Key para o `nivel` da questão referenciada.
  static const kKeyNivelReferencia = "nivel_referencia";

  ///Key para o `indice` da questão referenciada.
  static const kKeyIndiceReferencia = "indice_referencia";

  ///Se [isReferenciado] é verdadeiro, [id] será o id da questão que fáz referência.
  final String id;
  final Ano ano;

  ///Se [isReferenciado] é verdadeiro, [nivel] será o nível da questão que fáz referência.
  final Nivel nivel;

  ///Se [isReferenciado] é verdadeiro, [indice] será o índice da questão que fáz referência.
  final int indice;
  final List<Assunto> assuntos;
  final Dificuldade dificuldade;
  final List<String> enunciado;
  final List<Alternativa> alternativas;
  final String gabarito;

  ///A lista de imágens é opcional, pois alguns enunciados não contém imágem.
  final List<ImagemQuestao> imagensEnunciado;

  ///[id] da questão referenciada.
  final String? idReferencia;

  ///[nivel] da questão referenciada.
  final Nivel? nivelReferencia;

  ///[indice] da questão referenciada.
  final int? indiceReferencia;

  Questao({
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

  factory Questao.fromJson(
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

    json[DbConst.kDbDataQuestaoKeyAssuntos].forEach((v) {
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

    json[DbConst.kDbDataQuestaoKeyAlternativas].forEach((v) {
      _alternativas.add(Alternativa.fromJson(v));
    });

    return Questao(
      id: json[DbConst.kDbDataQuestaoKeyId],
      ano: Ano(json[DbConst.kDbDataQuestaoKeyAno]),
      nivel: Nivel(json[DbConst.kDbDataQuestaoKeyNivel]),
      indice: json[DbConst.kDbDataQuestaoKeyIndice],
      assuntos: _assuntos,
      dificuldade:
          Dificuldade.fromString(json[DbConst.kDbDataQuestaoKeyDificuldade]),
      enunciado: json[DbConst.kDbDataQuestaoKeyEnunciado].cast<String>(),
      alternativas: _alternativas,
      gabarito: json[DbConst.kDbDataQuestaoKeyGabarito],
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
  static List<ImagemQuestao> _getImagensEnunciado(Map<String, dynamic> jsonItem) {
    final _imagensEnunciado = <ImagemQuestao>[];
    if (jsonItem.containsKey(DbConst.kDbDataQuestaoKeyImagensEnunciado)) {
      jsonItem[DbConst.kDbDataQuestaoKeyImagensEnunciado]
          .forEach((imagemInfo) {
        _imagensEnunciado.add(ImagemQuestao.fromJson(imagemInfo));
      });
    }
    return _imagensEnunciado;
  }

  ///Será `true` se, no banco de dados, a questão fizer referência a outra.
  bool get isReferenciado =>
      idReferencia != null &&
      nivelReferencia != null &&
      indiceReferencia != null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (isReferenciado) {
      ///Retornará um `Map` da questão que faz referência.
      ///Para inserír no banco de dados é necessário adicionar
      ///`data[DB_DOC_QUESTAO_REFERENCIA] = (await FirebaseFirestore.instance).collection(DB_COLECAO_QUESTOES).doc(data[ITEM_ID_REFERENCIA_KEY])`
      ///e remover `data[ITEM_ID_REFERENCIA_KEY]` antes de enviar o `Map`.
      data[kKeyIdReferencia] = this.idReferencia;
      data[DbConst.kDbDataQuestaoKeyId] = this.id;
      data[DbConst.kDbDataQuestaoKeyNivel] = this.nivel.valor;
      data[DbConst.kDbDataQuestaoKeyIndice] = this.indice;
      return data;
    } else {
      data[DbConst.kDbDataQuestaoKeyId] = this.id;
      data[DbConst.kDbDataQuestaoKeyNivel] = this.nivel.valor;
      data[DbConst.kDbDataQuestaoKeyIndice] = this.indice;
      data[DbConst.kDbDataQuestaoKeyAno] = this.ano.valor;
      if (this.assuntos.isNotEmpty) {
        data[DbConst.kDbDataQuestaoKeyAssuntos] =
            this.assuntos.map((v) => v.titulo).toList();
      }
      data[DbConst.kDbDataQuestaoKeyDificuldade] = this.dificuldade.toString();
      data[DbConst.kDbDataQuestaoKeyEnunciado] = this.enunciado;
      if (this.alternativas.isNotEmpty) {
        data[DbConst.kDbDataQuestaoKeyAlternativas] =
            this.alternativas.map((v) => v.toJson()).toList();
      }
      data[DbConst.kDbDataQuestaoKeyGabarito] = this.gabarito;
      if (this.imagensEnunciado.isNotEmpty) {
        data[DbConst.kDbDataQuestaoKeyImagensEnunciado] =
            this.imagensEnunciado.map((v) => v.toJson()).toList();
      }
      return data;
    }
  }
}

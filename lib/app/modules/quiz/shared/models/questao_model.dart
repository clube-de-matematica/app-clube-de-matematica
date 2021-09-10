import '../../../../shared/models/exceptions/my_exception.dart';
import '../../../../shared/utils/strings_db.dart';
import 'alternativa_questao_model.dart';
import 'ano_questao_model.dart';
import 'assunto_model.dart';
import 'imagem_questao_model.dart';
import 'nivel_questao_model.dart';

/// Contém as propriedades de uma questão.
class Questao {
  final String id;
  final Ano ano;
  final Nivel nivel;
  final int indice;
  final List<Assunto> assuntos;
  final List<String> enunciado;
  final List<Alternativa> alternativas;
  final int gabarito;

  /// A lista de imagens é opcional, pois alguns enunciados não contém imagem.
  final List<ImagemQuestao> imagensEnunciado;

  Questao({
    required this.id,
    required this.ano,
    required this.nivel,
    required this.indice,
    required this.assuntos,
    required this.enunciado,
    required this.alternativas,
    required this.gabarito,
    required this.imagensEnunciado,
  });

  factory Questao.fromJson(
    Map<String, dynamic> json, {
    List<Assunto>? assuntosCarreados,
  }) {
    assuntosCarreados ??= Assunto.instancias;
    assert(assuntosCarreados.isNotEmpty);
    if (assuntosCarreados.isEmpty)
      throw MyException(
        "Os assuntos não foram carregados.",
        originClass: "Questao",
        originField: "Questao.fromJson()",
        fieldDetails:
            "assuntosCarreados == ${assuntosCarreados.toString()};\njson == ${json.toString()}",
        causeError: "assuntosCarreados está vazio.",
      );
    final id = json[DbConst.kDbDataQuestaoKeyId] as String;
    final _assuntos = <Assunto>[];
    final _alternativas = <Alternativa>[];

    json[DbConst.kDbDataQuestaoKeyAssuntos].forEach((idAssunto) {
      // Se o assunto não for encontrado ocorrerá um erro.
      _assuntos.add(assuntosCarreados!.firstWhere(
        (element) => element.id == idAssunto,
        orElse: () => throw MyException(
          'Assunto com o ID $idAssunto não encontrado.',
          originClass: "Questao",
          originField: "Questao.fromJson()",
          fieldDetails:
              "assuntosCarreados == ${assuntosCarreados.toString()};\njson == ${json.toString()}",
          causeError: "O assunto \"$idAssunto\" não foi encontrado.",
        ),
      ));
    });

    json[DbConst.kDbDataQuestaoKeyAlternativas].forEach((dataAlternativa) {
      _alternativas.add(Alternativa.fromJson(dataAlternativa));
    });

    return Questao(
      id: id,
      ano: Ano(json[DbConst.kDbDataQuestaoKeyAno]),
      nivel: Nivel(json[DbConst.kDbDataQuestaoKeyNivel]),
      indice: json[DbConst.kDbDataQuestaoKeyIndice] as int,
      assuntos: _assuntos,
      enunciado:
          (json[DbConst.kDbDataQuestaoKeyEnunciado] as List).cast<String>(),
      alternativas: _alternativas,
      gabarito: json[DbConst.kDbDataQuestaoKeyGabarito] as int,
      imagensEnunciado: _getImagensEnunciado(json),
    );
  }

  /// Retorna a lista de imágens do enunciado.
  /// Retorna uma lista vazia se o enunciado não tiver imágem.
  /// [jsonQuestao] é o json retornado do banco de dados.
  static List<ImagemQuestao> _getImagensEnunciado(DataQuestao jsonQuestao) {
    final _imagensEnunciado = <ImagemQuestao>[];
    final dataImagensEnunciado =
        ((jsonQuestao[DbConst.kDbDataQuestaoKeyImagensEnunciado] ?? []) as List)
            .cast<DataImagem>();
    for (var i = 0; i < dataImagensEnunciado.length; i++) {
      final imagemInfo = dataImagensEnunciado[i];
      imagemInfo[ImagemQuestao.kKeyName] =
          '${jsonQuestao[DbConst.kDbDataQuestaoKeyId] as String}_enunciado_$i.png';
      _imagensEnunciado.add(ImagemQuestao.fromJson(imagemInfo));
    }
    return _imagensEnunciado;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[DbConst.kDbDataQuestaoKeyId] = this.id;
    data[DbConst.kDbDataQuestaoKeyNivel] = this.nivel.valor;
    data[DbConst.kDbDataQuestaoKeyIndice] = this.indice;
    data[DbConst.kDbDataQuestaoKeyAno] = this.ano.valor;
    if (this.assuntos.isNotEmpty) {
      data[DbConst.kDbDataQuestaoKeyAssuntos] =
          this.assuntos.map((v) => v.id).toList();
    }
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

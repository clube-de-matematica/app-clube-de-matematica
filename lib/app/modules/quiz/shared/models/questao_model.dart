import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/repositories/questoes/assuntos_repository.dart';
import '../../../../shared/utils/strings_db.dart';
import 'alternativa_questao_model.dart';
import 'assunto_model.dart';
import 'imagem_questao_model.dart';

/// Contém as propriedades de uma questão.
class Questao {
  /// Questões aplicadas em mais de um caderno têm [idAlfanumerico] diferentes, mas o mesmo [id].
  final int id;

  /// Questões aplicadas em mais de um caderno têm [idAlfanumerico] diferentes, mas o mesmo [id].
  final String idAlfanumerico;
  final int ano;
  final int nivel;
  final int indice;
  final List<Assunto> assuntos;
  final List<String> enunciado;
  final List<Alternativa> alternativas;
  final int gabarito;

  /// A lista de imagens é opcional, pois alguns enunciados não contém imagem.
  final List<ImagemQuestao> imagensEnunciado;

  /// {@template app.Questao.instancias}
  /// Conjunto de todas as instâncias criadas.
  /// {@endtemplate}
  static final ObservableSet<Questao> _instancias = ObservableSet<Questao>();

  /// {@macro app.Questao.instancias}
  static ObservableSet<Questao> get instancias => _instancias;

  Questao._interno({
    required this.id,
    required this.idAlfanumerico,
    required this.ano,
    required this.nivel,
    required this.indice,
    required this.assuntos,
    required this.enunciado,
    required this.alternativas,
    required this.gabarito,
    required this.imagensEnunciado,
  }) {
    _instancias.add(this);
  }

  /// Cria uma instância sem incluí-la em [instancias].
  Questao.noSingleton({
    required this.id,
    required this.idAlfanumerico,
    required this.ano,
    required this.nivel,
    required this.indice,
    required this.assuntos,
    required this.enunciado,
    required this.alternativas,
    required this.gabarito,
    required this.imagensEnunciado,
  });

  /// Retorna o primeiro elemento que satisfaz `element.id == id`.
  /// Se nenhum elemento satisfizer `element.id == id`, o resultado da chamada da
  /// função `orElse` será retornado.
  /// A função `orElse` retorna uma nova instância de [Questao].
  /// Essa instância é adiciona em [_instancias].
  factory Questao({
    required int id,
    required String idAlfanumerico,
    required int ano,
    required int nivel,
    required int indice,
    required List<Assunto> assuntos,
    required List<String> enunciado,
    required List<Alternativa> alternativas,
    required int gabarito,
    required List<ImagemQuestao> imagensEnunciado,
  }) {
    return _instancias.firstWhere(
      (element) => element.idAlfanumerico == idAlfanumerico,
      orElse: () => Questao._interno(
        id: id,
        idAlfanumerico: idAlfanumerico,
        ano: ano,
        nivel: nivel,
        indice: indice,
        assuntos: assuntos,
        enunciado: enunciado,
        alternativas: alternativas,
        gabarito: gabarito,
        imagensEnunciado: imagensEnunciado,
      ),
    );
  }

  static Future<Questao> fromDataQuestao(Map<String, dynamic> dados) async {
    final idAlfa = dados[DbConst.kDbDataQuestaoKeyIdAlfanumerico] as String;
    final List<Assunto> assuntos;
    final alternativas = <Alternativa>[];

    final idsAssuntos =
        (dados[DbConst.kDbDataQuestaoKeyAssuntos] as List).cast<int>();
    final futuros = idsAssuntos
        .map((idAssunto) => Modular.get<AssuntosRepository>().get(idAssunto));
    assuntos =
        (await Future.wait(futuros)).where((e) => e != null).toList().cast();

    final dadosAlternativas =
        dados[DbConst.kDbDataQuestaoKeyAlternativas] as List;
    for (var dataAlternativa in dadosAlternativas) {
      alternativas.add(Alternativa.fromJson(dataAlternativa));
    }

    return Questao(
      id: dados[DbConst.kDbDataQuestaoKeyId] as int,
      idAlfanumerico: idAlfa,
      ano: dados[DbConst.kDbDataQuestaoKeyAno] as int,
      nivel: dados[DbConst.kDbDataQuestaoKeyNivel] as int,
      indice: dados[DbConst.kDbDataQuestaoKeyIndice] as int,
      assuntos: assuntos,
      enunciado:
          (dados[DbConst.kDbDataQuestaoKeyEnunciado] as List).cast<String>(),
      alternativas: alternativas,
      gabarito: dados[DbConst.kDbDataQuestaoKeyGabarito] as int,
      imagensEnunciado: _getImagensEnunciado(dados),
    );
  }

  /// Retorna a lista de imágens do enunciado.
  /// Retorna uma lista vazia se o enunciado não tiver imágem.
  /// [jsonQuestao] é o json retornado do banco de dados.
  static List<ImagemQuestao> _getImagensEnunciado(DataQuestao jsonQuestao) {
    final imagensEnunciado = <ImagemQuestao>[];
    final dataImagensEnunciado =
        ((jsonQuestao[DbConst.kDbDataQuestaoKeyImagensEnunciado] ?? []) as List)
            .cast<DataImagem>();
    for (var i = 0; i < dataImagensEnunciado.length; i++) {
      final imagemInfo = dataImagensEnunciado[i];
      imagemInfo[ImagemQuestao.kKeyName] =
          '${jsonQuestao[DbConst.kDbDataQuestaoKeyIdAlfanumerico] as String}_enunciado_$i.png';
      imagensEnunciado.add(ImagemQuestao.fromMap(imagemInfo));
    }
    return imagensEnunciado;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[DbConst.kDbDataQuestaoKeyIdAlfanumerico] = idAlfanumerico;
    data[DbConst.kDbDataQuestaoKeyNivel] = nivel;
    data[DbConst.kDbDataQuestaoKeyIndice] = indice;
    data[DbConst.kDbDataQuestaoKeyAno] = ano;
    if (assuntos.isNotEmpty) {
      data[DbConst.kDbDataQuestaoKeyAssuntos] =
          assuntos.map((v) => v.id).toList();
    }
    data[DbConst.kDbDataQuestaoKeyEnunciado] = enunciado;
    if (alternativas.isNotEmpty) {
      data[DbConst.kDbDataQuestaoKeyAlternativas] =
          alternativas.map((v) => v.toJson()).toList();
    }
    data[DbConst.kDbDataQuestaoKeyGabarito] = gabarito;
    if (imagensEnunciado.isNotEmpty) {
      data[DbConst.kDbDataQuestaoKeyImagensEnunciado] =
          imagensEnunciado.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

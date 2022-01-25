import 'package:mobx/mobx.dart';

import '../../../../../shared/utils/strings_db.dart';
import '../../../../quiz/shared/models/alternativa_questao_model.dart';
import '../../../../quiz/shared/models/assunto_model.dart';
import '../../../../quiz/shared/models/imagem_questao_model.dart';
import '../../../../quiz/shared/models/questao_model.dart';
import 'atividade.dart';
import 'resposta_questao_atividade.dart';

part 'questao_atividade.g.dart';

enum EstadoResposta { correta, incorreta, emBranco }

/// Modelo para as questões usadas em uma atividade.
class QuestaoAtividade = _QuestaoAtividadeBase with _$QuestaoAtividade;

abstract class _QuestaoAtividadeBase extends RawQuestaoAtividade
    with Store
    implements Questao {
  final int idQuestaoAtividade;
  final Questao questao;
  final Atividade atividade;

  _QuestaoAtividadeBase({
    required this.idQuestaoAtividade,
    required this.questao,
    required this.atividade,
  });

  /// Conjunto com as respostas atibuídas a essa questõ.
  @computed
  Set<RespostaQuestaoAtividade> get respostas => atividade.respostas
      .where((resp) => resp.idQuestaoAtividade == idQuestaoAtividade)
      .toSet();

  /// Resposta atribuída a essa questão pelo usuário correspondente a [idUsuario].
  RespostaQuestaoAtividade? resposta(int idUsuario) {
    return respostas.cast<RespostaQuestaoAtividade?>().firstWhere(
          (resposta) => resposta?.idUsuario == idUsuario,
          orElse: () => null,
        );
  }

  /// Retorna o [EstadoResposta] para a resposta atribuída a essa questão pelo usuário
  /// correspondente a [idUsuario].
  EstadoResposta resultado(int idUsuario) {
    final resposta = this.resposta(idUsuario);
    if (resposta == null) return EstadoResposta.emBranco;
    if (resposta.sequencial == gabarito) return EstadoResposta.correta;
    return EstadoResposta.incorreta;
  }

  @override
  List<Alternativa> get alternativas => questao.alternativas;

  @override
  int get ano => questao.ano;

  @override
  List<Assunto> get assuntos => questao.assuntos;

  @override
  List<String> get enunciado => questao.enunciado;

  @override
  int get gabarito => questao.gabarito;

  @override
  String get id => questao.id;

  @override
  List<ImagemQuestao> get imagensEnunciado => questao.imagensEnunciado;

  @override
  int get indice => questao.indice;

  @override
  int get nivel => questao.nivel;

  @override
  Map<String, dynamic> toJson() => questao.toJson();

  @override
  String toString() {
    return 'QuestaoAtividade(id: $idQuestaoAtividade, idQuestao: ${questao.id}, atividade: ${atividade.toString()})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestaoAtividade &&
        other.idQuestaoAtividade == idQuestaoAtividade &&
        other.questao == questao &&
        other.atividade == atividade;
  }

  @override
  int get hashCode {
    return idQuestaoAtividade.hashCode ^ questao.hashCode ^ atividade.hashCode;
  }
}

/// Usada para preencher parcialmente os dados de uma questão de atividade.
class RawQuestaoAtividade {
  final int? idQuestaoAtividade;
  final Questao? questao;
  final Atividade? atividade;

  RawQuestaoAtividade({
    this.idQuestaoAtividade,
    this.questao,
    this.atividade,
  });

  DataQuestaoAtividade toDataQuestaoAtividade() {
    return {
      DbConst.kDbDataQuestaoAtividadeKeyId: idQuestaoAtividade,
      DbConst.kDbDataQuestaoAtividadeKeyIdQuestaoCaderno: questao?.id,
    };
  }
}

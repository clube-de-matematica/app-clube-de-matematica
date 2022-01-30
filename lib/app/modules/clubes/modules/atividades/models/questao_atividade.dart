import 'package:mobx/mobx.dart';

import '../../../../../shared/utils/strings_db.dart';
import '../../../../quiz/shared/models/questao_model.dart';
import 'resposta_questao_atividade.dart';

part 'questao_atividade.g.dart';

enum EstadoResposta { correta, incorreta, emBranco }

/// Modelo para as questões usadas em uma atividade.
class QuestaoAtividade = _QuestaoAtividadeBase with _$QuestaoAtividade;

abstract class _QuestaoAtividadeBase extends Questao with Store {
  final int idQuestaoAtividade;
  final int idAtividade;

  /// Conjunto com as respostas atibuídas a essa questão.
  final ObservableSet<RespostaQuestaoAtividade> respostas;

  _QuestaoAtividadeBase({
    required Questao questao,
    required this.idQuestaoAtividade,
    required this.idAtividade,
    Iterable<RespostaQuestaoAtividade> respostas = const [],
  })  : this.respostas = ObservableSet.of(respostas),
        super.noSingleton(
          id: questao.id,
          ano: questao.ano,
          nivel: questao.nivel,
          indice: questao.indice,
          assuntos: questao.assuntos,
          enunciado: questao.enunciado,
          alternativas: questao.alternativas,
          gabarito: questao.gabarito,
          imagensEnunciado: questao.imagensEnunciado,
        );

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

  DataQuestaoAtividade toDataQuestaoAtividade() {
    return {
      DbConst.kDbDataQuestaoAtividadeKeyId: idQuestaoAtividade,
      DbConst.kDbDataQuestaoAtividadeKeyIdAtividade: idAtividade,
      DbConst.kDbDataQuestaoAtividadeKeyIdQuestaoCaderno: id,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _QuestaoAtividadeBase &&
        other.idQuestaoAtividade == idQuestaoAtividade &&
        other.idAtividade == idAtividade;
  }

  @override
  int get hashCode => idQuestaoAtividade.hashCode ^ idAtividade.hashCode;
}

/// Usada para preencher parcialmente os dados de uma questão de atividade.
class RawQuestaoAtividade {
  final int? idQuestaoAtividade;
  final int? idAtividade;
  final String? idQuestao;

  RawQuestaoAtividade({
    this.idQuestaoAtividade,
    this.idAtividade,
    this.idQuestao,
  });

  DataQuestaoAtividade toDataQuestaoAtividade() {
    return {
      DbConst.kDbDataQuestaoAtividadeKeyId: idQuestaoAtividade,
      DbConst.kDbDataQuestaoAtividadeKeyIdAtividade: idAtividade,
      DbConst.kDbDataQuestaoAtividadeKeyIdQuestaoCaderno: idQuestao,
    };
  }
}

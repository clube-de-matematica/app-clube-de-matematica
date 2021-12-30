import 'package:mobx/mobx.dart';

import '../../../../../shared/utils/strings_db.dart';
import '../../../../quiz/shared/models/alternativa_questao_model.dart';
import '../../../../quiz/shared/models/ano_questao_model.dart';
import '../../../../quiz/shared/models/assunto_model.dart';
import '../../../../quiz/shared/models/imagem_questao_model.dart';
import '../../../../quiz/shared/models/nivel_questao_model.dart';
import '../../../../quiz/shared/models/questao_model.dart';
import 'atividade.dart';
import 'resposta_questao_atividade.dart';

part 'questao_atividade.g.dart';

/// Modelo para as questões usadas em uma atividade.
class QuestaoAtividade = _QuestaoAtividadeBase with _$QuestaoAtividade;

abstract class _QuestaoAtividadeBase with Store implements Questao {
  final int idQuestaoAtividade;
  final Questao questao;
  final Atividade atividade;

  _QuestaoAtividadeBase({
    required this.idQuestaoAtividade,
    required this.questao,
    required this.atividade,
  });

  @computed
  Set<RespostaQuestaoAtividade> get respostas => atividade.respostas
      .where((resp) => resp.idQuestaoAtividade == idQuestaoAtividade)
      .toSet();

  RespostaQuestaoAtividade? resposta(int idUsuario) {
    return respostas.cast<RespostaQuestaoAtividade?>().firstWhere(
          (resposta) => resposta?.idUsuario == idUsuario,
          orElse: () => null,
        );
  }

  @override
  List<Alternativa> get alternativas => questao.alternativas;

  @override
  Ano get ano => questao.ano;

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
  Nivel get nivel => questao.nivel;

  @override
  Map<String, dynamic> toJson() => questao.toJson();

  DataQuestaoAtividade toDataQuestaoAtividade() {
    return {
      DbConst.kDbDataQuestaoAtividadeKeyId: idQuestaoAtividade,
      DbConst.kDbDataQuestaoAtividadeKeyIdQuestaoCaderno: questao.id,
    };
  }

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

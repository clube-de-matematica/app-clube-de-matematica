import 'dart:convert';

import 'package:mobx/mobx.dart';

import '../../../../../shared/utils/strings_db.dart';
import '../../../../quiz/shared/models/alternativa_questao_model.dart';
import '../../../../quiz/shared/models/ano_questao_model.dart';
import '../../../../quiz/shared/models/assunto_model.dart';
import '../../../../quiz/shared/models/imagem_questao_model.dart';
import '../../../../quiz/shared/models/nivel_questao_model.dart';
import '../../../../quiz/shared/models/questao_model.dart';

part 'questao_atividade.g.dart';

/// Modelo para as questões usadas em uma atividade.
class QuestaoAtividade = _QuestaoAtividadeBase with _$QuestaoAtividade;

abstract class _QuestaoAtividadeBase with Store implements Questao {
  final int idQuestaoAtividade;
  final Questao questao;
  final int idAtividade;

  _QuestaoAtividadeBase({
    required this.idQuestaoAtividade,
    required this.questao,
    required this.idAtividade,
  });

  int? sequencialRespostaTemporaria;

  @observable
  RespostaQuestaoAtividade? resposta;
  
  @computed
  int? get sequencialRespostaSalva => resposta?.sequencial;

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
    return 'QuestaoAtividade(id: $idQuestaoAtividade, idQuestao: ${questao.id}, idAtividade: $idAtividade)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestaoAtividade &&
        other.idQuestaoAtividade == idQuestaoAtividade &&
        other.questao == questao &&
        other.idAtividade == idAtividade;
  }

  @override
  int get hashCode {
    return idQuestaoAtividade.hashCode ^
        questao.hashCode ^
        idAtividade.hashCode;
  }
}

/// Modelo para as respostas dos usuários às questões de uma atividade.
class RespostaQuestaoAtividade {
  final int idQuestaoAtividade;
  final int idUsuario;
  int? sequencial;
  RespostaQuestaoAtividade({
    required this.idQuestaoAtividade,
    required this.idUsuario,
    required this.sequencial,
  });

  RespostaQuestaoAtividade copyWith({
    int? idQuestaoAtividade,
    int? idUsuario,
    int? sequencial,
  }) {
    return RespostaQuestaoAtividade(
      idQuestaoAtividade: idQuestaoAtividade ?? this.idQuestaoAtividade,
      idUsuario: idUsuario ?? this.idUsuario,
      sequencial: sequencial ?? this.sequencial,
    );
  }

  DataRespostaQuestaoAtividade toDataRespostaQuestaoAtividade() {
    return {
      DbConst.kDbDataRespostaQuestaoAtividadeKeyIdQuestaoAtividade:
          idQuestaoAtividade,
      DbConst.kDbDataRespostaQuestaoAtividadeKeyIdUsuario: idUsuario,
      DbConst.kDbDataRespostaQuestaoAtividadeKeyIdResposta: sequencial,
    };
  }

  factory RespostaQuestaoAtividade.fromDataRespostaQuestaoAtividade(
      DataRespostaQuestaoAtividade map) {
    return RespostaQuestaoAtividade(
      idQuestaoAtividade:
          map[DbConst.kDbDataRespostaQuestaoAtividadeKeyIdQuestaoAtividade]!,
      idUsuario: map[DbConst.kDbDataRespostaQuestaoAtividadeKeyIdUsuario]!,
      sequencial: map[DbConst.kDbDataRespostaQuestaoAtividadeKeyIdResposta],
    );
  }

  String toJson() => json.encode(toDataRespostaQuestaoAtividade());

  factory RespostaQuestaoAtividade.fromJson(String source) =>
      RespostaQuestaoAtividade.fromDataRespostaQuestaoAtividade(
          json.decode(source));

  @override
  String toString() =>
      'Resposta(idQuestaoAtividade: $idQuestaoAtividade, idUsuario: $idUsuario, sequencial: $sequencial)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RespostaQuestaoAtividade &&
        other.idQuestaoAtividade == idQuestaoAtividade &&
        other.idUsuario == idUsuario &&
        other.sequencial == sequencial;
  }

  @override
  int get hashCode =>
      idQuestaoAtividade.hashCode ^ idUsuario.hashCode ^ sequencial.hashCode;
}

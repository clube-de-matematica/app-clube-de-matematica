import 'dart:convert';

import 'package:mobx/mobx.dart';

import '../../../../../shared/utils/strings_db.dart';

part 'resposta_questao_atividade.g.dart';

/// Modelo para as respostas dos usuários às questões de uma atividade.
class RespostaQuestaoAtividade extends _RespostaQuestaoAtividadeBase
    with _$RespostaQuestaoAtividade {
  RespostaQuestaoAtividade({
    required super.idQuestaoAtividade,
    required super.idUsuario,
    required super.sequencial,
  });

  factory RespostaQuestaoAtividade.fromDataRespostaQuestaoAtividade(
      DataRespostaQuestaoAtividade map) {
    return RespostaQuestaoAtividade(
      idQuestaoAtividade:
          map[DbConst.kDbDataRespostaQuestaoAtividadeKeyIdQuestaoAtividade]!,
      idUsuario: map[DbConst.kDbDataRespostaQuestaoAtividadeKeyIdUsuario]!,
      sequencial: map[DbConst.kDbDataRespostaQuestaoAtividadeKeyResposta],
    );
  }

  factory RespostaQuestaoAtividade.fromJson(String source) =>
      RespostaQuestaoAtividade.fromDataRespostaQuestaoAtividade(
          json.decode(source));
}

abstract class _RespostaQuestaoAtividadeBase with Store {
  final int idQuestaoAtividade;
  final int idUsuario;
  @observable
  int? sequencial;
  @observable
  int? sequencialTemporario;
  _RespostaQuestaoAtividadeBase({
    required this.idQuestaoAtividade,
    required this.idUsuario,
    required this.sequencial,
  }) : sequencialTemporario = sequencial;

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
      DbConst.kDbDataRespostaQuestaoAtividadeKeyResposta: sequencial,
    };
  }

  String toJson() => json.encode(toDataRespostaQuestaoAtividade());

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

class RawRespostaQuestaoAtividade {
  RawRespostaQuestaoAtividade({
    this.idQuestaoAtividade,
    this.idUsuario,
    this.sequencial,
    this.sequencialTemporario,
  });

  final int? idQuestaoAtividade;
  final int? idUsuario;
  final int? sequencial;
  final int? sequencialTemporario;

  RawRespostaQuestaoAtividade copyWith({
    int? idQuestaoAtividade,
    int? idUsuario,
    int? sequencial,
    int? sequencialTemporario,
  }) {
    return RawRespostaQuestaoAtividade(
      idQuestaoAtividade: idQuestaoAtividade ?? this.idQuestaoAtividade,
      idUsuario: idUsuario ?? this.idUsuario,
      sequencial: sequencial ?? this.sequencial,
      sequencialTemporario: sequencialTemporario ?? this.sequencialTemporario,
    );
  }

  DataRespostaQuestaoAtividade toDataRespostaQuestaoAtividade() {
    return {
      DbConst.kDbDataRespostaQuestaoAtividadeKeyIdQuestaoAtividade:
          idQuestaoAtividade,
      DbConst.kDbDataRespostaQuestaoAtividadeKeyIdUsuario: idUsuario,
      DbConst.kDbDataRespostaQuestaoAtividadeKeyResposta: sequencial,
    };
  }
}

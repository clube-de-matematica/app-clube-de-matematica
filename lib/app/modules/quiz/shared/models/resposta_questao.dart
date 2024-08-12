import 'package:mobx/mobx.dart';

import '../../../../shared/utils/strings_db.dart';

part 'resposta_questao.g.dart';

/// Modelo para as respostas dos usuários às questões.
class RespostaQuestao extends _RespostaQuestaoBase with _$RespostaQuestao {
  RespostaQuestao({
    required super.idQuestao,
    required super.idUsuario,
    required super.sequencial,
  });

  factory RespostaQuestao.fromDataRespostaQuestao(DataRespostaQuestao map) {
    return RespostaQuestao(
      idQuestao: map[DbConst.kDbDataRespostaQuestaoKeyIdQuestao]!,
      idUsuario: map[DbConst.kDbDataRespostaQuestaoKeyIdUsuario],
      sequencial: map[DbConst.kDbDataRespostaQuestaoKeyResposta],
    );
  }
}

abstract class _RespostaQuestaoBase with Store {
  final int idQuestao;
  final int? idUsuario;
  @observable
  int? sequencial;
  @observable
  int? sequencialTemporario;
  _RespostaQuestaoBase({
    required this.idQuestao,
    required this.idUsuario,
    required this.sequencial,
  })  : sequencialTemporario = sequencial;

  RespostaQuestao copyWith({
    int? idQuestao,
    int? idUsuario,
    int? sequencial,
  }) {
    return RespostaQuestao(
      idQuestao: idQuestao ?? this.idQuestao,
      idUsuario: idUsuario ?? this.idUsuario,
      sequencial: sequencial ?? this.sequencial,
    );
  }

  DataRespostaQuestao toDataRespostaQuestao() {
    return {
      DbConst.kDbDataRespostaQuestaoKeyIdQuestao: idQuestao,
      DbConst.kDbDataRespostaQuestaoKeyIdUsuario: idUsuario,
      DbConst.kDbDataRespostaQuestaoKeyResposta: sequencial,
    };
  }

  @override
  String toString() =>
      'Resposta(idQuestao: $idQuestao, idUsuario: $idUsuario, sequencial: $sequencial)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RespostaQuestao &&
        other.idQuestao == idQuestao &&
        other.idUsuario == idUsuario &&
        other.sequencial == sequencial;
  }

  @override
  int get hashCode =>
      idQuestao.hashCode ^ idUsuario.hashCode ^ sequencial.hashCode;
}

class RawRespostaQuestao {
  RawRespostaQuestao({
    this.idQuestao,
    this.idUsuario,
    this.sequencial,
  });

  final int? idQuestao;
  final int? idUsuario;
  final int? sequencial;

  RawRespostaQuestao copyWith({
    int? idQuestao,
    int? idUsuario,
    int? sequencial,
  }) {
    return RawRespostaQuestao(
      idQuestao: idQuestao ?? this.idQuestao,
      idUsuario: idUsuario ?? this.idUsuario,
      sequencial: sequencial ?? this.sequencial,
    );
  }

  DataRespostaQuestao toDataRespostaQuestao() {
    return {
      DbConst.kDbDataRespostaQuestaoKeyIdQuestao: idQuestao,
      DbConst.kDbDataRespostaQuestaoKeyIdUsuario: idUsuario,
      DbConst.kDbDataRespostaQuestaoKeyResposta: sequencial,
    };
  }
}

import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbRespostaQuestaoAtividadeDbRemoto extends ILinTbRespostaQuestaoAtividade with LinTbMixin {
  LinTbRespostaQuestaoAtividadeDbRemoto({
    required super.idQuestaoAtividade,
    required super.idUsuario,
    required super.resposta,
    required super.excluir,
    required String super.dataModificacao,
  });

  factory LinTbRespostaQuestaoAtividadeDbRemoto.fromMap(Map map) {
    const tb = Sql.tbRespostaQuestaoAtividade;
    return LinTbRespostaQuestaoAtividadeDbRemoto(
      idQuestaoAtividade: map[tb.idQuestaoAtividade],
      idUsuario: map[tb.idUsuario],
      resposta: map[tb.resposta],
      excluir: map[tb.excluir],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

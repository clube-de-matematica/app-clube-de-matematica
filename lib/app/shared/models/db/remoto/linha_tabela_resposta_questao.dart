import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbRespostaQuestaoDbRemoto extends ILinTbRespostaQuestao with LinTbMixin {
  LinTbRespostaQuestaoDbRemoto({
    required super.idQuestao,
    required super.idUsuario,
    required super.resposta,
    required super.excluir,
    required String super.dataModificacao,
  });

  factory LinTbRespostaQuestaoDbRemoto.fromMap(Map map) {
    const tb = Sql.tbRespostaQuestao;
    return LinTbRespostaQuestaoDbRemoto(
      idQuestao: map[tb.idQuestao],
      idUsuario: map[tb.idUsuario],
      resposta: map[tb.resposta],
      excluir: map[tb.excluir],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

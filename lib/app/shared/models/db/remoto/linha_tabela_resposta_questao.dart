import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbRespostaQuestaoDbRemoto extends ILinTbRespostaQuestao with LinTbMixin {
  LinTbRespostaQuestaoDbRemoto({
    required int idQuestao,
    required int idUsuario,
    required int? resposta,
    required bool excluir,
    required String dataModificacao,
  }) : super(
          idQuestao: idQuestao,
          idUsuario: idUsuario,
          resposta: resposta,
          excluir: excluir,
          dataModificacao: dataModificacao,
        );

  factory LinTbRespostaQuestaoDbRemoto.fromMap(Map map) {
    final tb = Sql.tbRespostaQuestao;
    return LinTbRespostaQuestaoDbRemoto(
      idQuestao: map[tb.idQuestao],
      idUsuario: map[tb.idUsuario],
      resposta: map[tb.resposta],
      excluir: map[tb.excluir],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

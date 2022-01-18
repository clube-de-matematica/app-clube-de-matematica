import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbRespostaQuestaoAtividadeDbRemoto extends ILinTbRespostaQuestaoAtividade with LinTbMixin {
  LinTbRespostaQuestaoAtividadeDbRemoto({
    required int idQuestaoAtividade,
    required int idUsuario,
    required int? resposta,
    required bool excluir,
    required String dataModificacao,
  }) : super(
          idQuestaoAtividade: idQuestaoAtividade,
          idUsuario: idUsuario,
          resposta: resposta,
          excluir: excluir,
          dataModificacao: dataModificacao,
        );

  factory LinTbRespostaQuestaoAtividadeDbRemoto.fromMap(Map map) {
    final tb = Sql.tbRespostaQuestaoAtividade;
    return LinTbRespostaQuestaoAtividadeDbRemoto(
      idQuestaoAtividade: map[tb.idQuestaoAtividade],
      idUsuario: map[tb.idUsuario],
      resposta: map[tb.resposta],
      excluir: map[tb.excluir],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

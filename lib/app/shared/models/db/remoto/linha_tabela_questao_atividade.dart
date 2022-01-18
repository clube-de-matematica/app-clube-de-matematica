import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbQuestaoAtividadeDbRemoto extends ILinTbQuestaoAtividade with LinTbMixin {
  LinTbQuestaoAtividadeDbRemoto({
    required int id,
    required String idQuestaoCaderno,
    required int idAtividade,
    required bool excluir,
    required String dataModificacao,
  }) : super(
          id: id,
          idQuestaoCaderno: idQuestaoCaderno,
          idAtividade: idAtividade,
          excluir: excluir,
          dataModificacao: dataModificacao,
        );

  factory LinTbQuestaoAtividadeDbRemoto.fromMap(Map map) {
    final tb = Sql.tbQuestaoAtividade;
    return LinTbQuestaoAtividadeDbRemoto(
      id: map[tb.id],
      idQuestaoCaderno: map[tb.idQuestaoCaderno],
      idAtividade: map[tb.idAtividade],
      excluir: map[tb.excluir],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

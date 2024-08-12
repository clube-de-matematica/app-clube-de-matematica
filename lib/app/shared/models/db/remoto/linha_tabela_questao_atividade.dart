import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbQuestaoAtividadeDbRemoto extends ILinTbQuestaoAtividade with LinTbMixin {
  LinTbQuestaoAtividadeDbRemoto({
    required super.id,
    required super.idQuestaoCaderno,
    required super.idAtividade,
    required super.excluir,
    required String super.dataModificacao,
  });

  factory LinTbQuestaoAtividadeDbRemoto.fromMap(Map map) {
    const tb = Sql.tbQuestaoAtividade;
    return LinTbQuestaoAtividadeDbRemoto(
      id: map[tb.id],
      idQuestaoCaderno: map[tb.idQuestaoCaderno],
      idAtividade: map[tb.idAtividade],
      excluir: map[tb.excluir],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

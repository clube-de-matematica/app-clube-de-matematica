import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbQuestaoAssuntoDbRemoto extends ILinTbQuestaoAssunto with LinTbMixin {
  LinTbQuestaoAssuntoDbRemoto({
    required super.idQuestao,
    required super.idAssunto,
    required String super.dataModificacao,
  });

  factory LinTbQuestaoAssuntoDbRemoto.fromMap(Map map) {
    const tb = Sql.tbQuestaoAssunto;
    return LinTbQuestaoAssuntoDbRemoto(
      idQuestao: map[tb.idQuestao],
      idAssunto: map[tb.idAssunto],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

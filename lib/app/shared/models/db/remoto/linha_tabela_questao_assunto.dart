import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbQuestaoAssuntoDbRemoto extends ILinTbQuestaoAssunto with LinTbMixin {
  LinTbQuestaoAssuntoDbRemoto({
    required int idQuestao,
    required int idAssunto,
    required String dataModificacao,
  }) : super(
          idQuestao: idQuestao,
          idAssunto: idAssunto,
          dataModificacao: dataModificacao,
        );

  factory LinTbQuestaoAssuntoDbRemoto.fromMap(Map map) {
    final tb = Sql.tbQuestaoAssunto;
    return LinTbQuestaoAssuntoDbRemoto(
      idQuestao: map[tb.idQuestao],
      idAssunto: map[tb.idAssunto],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

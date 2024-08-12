import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbQuestoesCadernoDbRemoto extends ILinTbQuestoesCaderno
    with LinTbMixin {
  LinTbQuestoesCadernoDbRemoto({
    required super.id,
    required super.ano,
    required super.nivel,
    required super.indice,
    required super.idQuestao,
    required String super.dataModificacao,
  });

  factory LinTbQuestoesCadernoDbRemoto.fromMap(Map map) {
    const tb = Sql.tbQuestoesCaderno;
    return LinTbQuestoesCadernoDbRemoto(
      id: map[tb.id],
      ano: map[tb.ano],
      nivel: map[tb.nivel],
      indice: map[tb.indice],
      idQuestao: map[tb.idQuestao],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

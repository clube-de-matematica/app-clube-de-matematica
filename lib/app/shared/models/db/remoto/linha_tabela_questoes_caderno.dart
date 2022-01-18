import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbQuestoesCadernoDbRemoto extends ILinTbQuestoesCaderno
    with LinTbMixin {
  LinTbQuestoesCadernoDbRemoto({
    required String id,
    required int ano,
    required int nivel,
    required int indice,
    required int idQuestao,
    required String dataModificacao,
  }) : super(
          id: id,
          ano: ano,
          nivel: nivel,
          indice: indice,
          idQuestao: idQuestao,
          dataModificacao: dataModificacao,
        );

  factory LinTbQuestoesCadernoDbRemoto.fromMap(Map map) {
    final tb = Sql.tbQuestoesCaderno;
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

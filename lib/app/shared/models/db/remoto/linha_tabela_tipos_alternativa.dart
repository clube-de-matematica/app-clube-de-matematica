import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbTiposAlternativaDbRemoto extends ILinTbTiposAlternativa
    with LinTbMixin {
  LinTbTiposAlternativaDbRemoto({
    required int id,
    required String tipo,
    required String dataModificacao,
  }) : super(
          id: id,
          tipo: tipo,
          dataModificacao: dataModificacao,
        );

  factory LinTbTiposAlternativaDbRemoto.fromMap(Map map) {
    final tb = Sql.tbTiposAlternativa;
    return LinTbTiposAlternativaDbRemoto(
      id: map[tb.id],
      tipo: map[tb.tipo],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

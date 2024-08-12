import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbTiposAlternativaDbRemoto extends ILinTbTiposAlternativa
    with LinTbMixin {
  LinTbTiposAlternativaDbRemoto({
    required super.id,
    required super.tipo,
    required String super.dataModificacao,
  });

  factory LinTbTiposAlternativaDbRemoto.fromMap(Map map) {
    const tb = Sql.tbTiposAlternativa;
    return LinTbTiposAlternativaDbRemoto(
      id: map[tb.id],
      tipo: map[tb.tipo],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbTiposPermissaoDbRemoto extends ILinTbTiposPermissao with LinTbMixin {
  LinTbTiposPermissaoDbRemoto({
    required super.id,
    required super.permissao,
    required String super.dataModificacao,
  });

  factory LinTbTiposPermissaoDbRemoto.fromMap(Map map) {
    const tb = Sql.tbTiposPermissao;
    return LinTbTiposPermissaoDbRemoto(
      id: map[tb.id],
      permissao: map[tb.permissao],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

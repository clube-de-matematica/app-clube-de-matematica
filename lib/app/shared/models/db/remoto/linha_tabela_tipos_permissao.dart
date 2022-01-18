import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbTiposPermissaoDbRemoto extends ILinTbTiposPermissao with LinTbMixin {
  LinTbTiposPermissaoDbRemoto({
    required int id,
    required String permissao,
    required String dataModificacao,
  }) : super(
          id: id,
          permissao: permissao,
          dataModificacao: dataModificacao,
        );

  factory LinTbTiposPermissaoDbRemoto.fromMap(Map map) {
    final tb = Sql.tbTiposPermissao;
    return LinTbTiposPermissaoDbRemoto(
      id: map[tb.id],
      permissao: map[tb.permissao],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

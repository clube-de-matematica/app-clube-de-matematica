import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbUsuariosDbRemoto extends ILinTbUsuarios
    with LinTbMixin {
  LinTbUsuariosDbRemoto({
    required super.id,
    required super.email,
    required super.nome,
    required super.foto,
    required super.softDelete,
    required String super.dataModificacao,
  });

  factory LinTbUsuariosDbRemoto.fromMap(Map map) {
    const tb = Sql.tbUsuarios;
    return LinTbUsuariosDbRemoto(
      id: map[tb.id],
      email: map[tb.email],
      nome: map[tb.nome],
      foto: map[tb.foto],
      softDelete: map[tb.softDelete],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

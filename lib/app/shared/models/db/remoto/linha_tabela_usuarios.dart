import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbUsuariosDbRemoto extends ILinTbUsuarios
    with LinTbMixin {
  LinTbUsuariosDbRemoto({
    required int id,
    required String? email,
    required String? nome,
    required String? foto,
    required bool softDelete,
    required String dataModificacao,
  }) : super(
          id: id,
          email: email,
          nome: nome,
          foto: foto,
          softDelete: softDelete,
          dataModificacao: dataModificacao,
        );

  factory LinTbUsuariosDbRemoto.fromMap(Map map) {
    final tb = Sql.tbUsuarios;
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

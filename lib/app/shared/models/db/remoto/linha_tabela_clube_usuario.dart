import '../../../utils/db/codificacao.dart';
import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbClubeUsuarioDbRemoto extends ILinTbClubeUsuario with LinTbMixin {
  LinTbClubeUsuarioDbRemoto({
    required super.idClube,
    required super.idUsuario,
    required super.idPermissao,
    required String super.dataAdmissao,
    required super.excluir,
    required String super.dataModificacao,
  });

  factory LinTbClubeUsuarioDbRemoto.fromMap(Map map) {
    const tb = Sql.tbClubeUsuario;
    return LinTbClubeUsuarioDbRemoto(
      idClube: map[tb.idClube],
      idUsuario: map[tb.idUsuario],
      idPermissao: map[tb.idPermissao],
      dataAdmissao: map[tb.dataAdmissao],
      excluir: map[tb.excluir],
      dataModificacao: map[tb.dataModificacao],
    );
  }

  @override
  String get dataAdmissao => super.dataAdmissao as String;

  @override
  DateTime decodificarDataAdmissao() {
    return DbRemoto.decodificarData(dataAdmissao)!;
  }
}

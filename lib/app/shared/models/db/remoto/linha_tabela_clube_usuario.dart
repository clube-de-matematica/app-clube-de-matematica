import '../../../utils/db/codificacao.dart';
import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbClubeUsuarioDbRemoto extends ILinTbClubeUsuario with LinTbMixin {
  LinTbClubeUsuarioDbRemoto({
    required int idClube,
    required int idUsuario,
    required int idPermissao,
    required String dataAdmissao,
    required bool excluir,
    required String dataModificacao,
  }) : super(
          idClube: idClube,
          idUsuario: idUsuario,
          idPermissao: idPermissao,
          dataAdmissao: dataAdmissao,
          excluir: excluir,
          dataModificacao: dataModificacao,
        );

  factory LinTbClubeUsuarioDbRemoto.fromMap(Map map) {
    final tb = Sql.tbClubeUsuario;
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
    return DbRemoto.decodificarData(dataAdmissao);
  }
}

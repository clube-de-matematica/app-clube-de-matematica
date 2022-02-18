import 'dart:ui';

import '../../../utils/db/codificacao.dart';
import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbClubesDbRemoto extends ILinTbClubes with LinTbMixin {
  LinTbClubesDbRemoto({
    required int id,
    required String nome,
    required String? descricao,
    required String dataCriacao,
    required bool privado,
    required String codigo,
    required String? capa,
    required bool excluir,
    required String dataModificacao,
  }) : super(
          id: id,
          nome: nome,
          descricao: descricao,
          dataCriacao: dataCriacao,
          privado: privado,
          codigo: codigo,
          capa: capa,
          excluir: excluir,
          dataModificacao: dataModificacao,
        );

  factory LinTbClubesDbRemoto.fromMap(Map map) {
    final tb = Sql.tbClubes;
    return LinTbClubesDbRemoto(
      id: map[tb.id],
      nome: map[tb.nome],
      descricao: map[tb.descricao],
      dataCriacao: map[tb.dataCriacao],
      privado: map[tb.privado],
      codigo: map[tb.codigo],
      capa: map[tb.capa],
      excluir: map[tb.excluir],
      dataModificacao: map[tb.dataModificacao],
    );
  }

  @override
  String get dataCriacao => super.dataCriacao as String;

  @override
  DateTime decodificarDataCriacao() {
    return DbRemoto.decodificarData(dataCriacao)!;
  }

  @override
  Color? decodificarCapa() {
    if (capa != null) return DbRemoto.decodificarCapaClube(capa!);
    return null;
  }
}

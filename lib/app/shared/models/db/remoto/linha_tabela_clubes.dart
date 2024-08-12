import 'dart:ui';

import '../../../utils/db/codificacao.dart';
import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbClubesDbRemoto extends ILinTbClubes with LinTbMixin {
  LinTbClubesDbRemoto({
    required super.id,
    required super.nome,
    required super.descricao,
    required String super.dataCriacao,
    required super.privado,
    required super.codigo,
    required super.capa,
    required super.excluir,
    required String super.dataModificacao,
  });

  factory LinTbClubesDbRemoto.fromMap(Map map) {
    const tb = Sql.tbClubes;
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

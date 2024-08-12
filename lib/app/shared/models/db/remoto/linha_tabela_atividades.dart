import '../../../utils/db/codificacao.dart';
import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbAtividadesDbRemoto extends ILinTbAtividades with LinTbMixin {
  LinTbAtividadesDbRemoto({
    required super.id,
    required super.idClube,
    required super.titulo,
    required super.descricao,
    required super.idAutor,
    required String super.dataCriacao,
    required String? super.dataLiberacao,
    required String? super.dataEncerramento,
    required super.excluir,
    required String super.dataModificacao,
  });

  factory LinTbAtividadesDbRemoto.fromMap(Map map) {
    const tb = Sql.tbAtividades;
    return LinTbAtividadesDbRemoto(
      id: map[tb.id],
      idClube: map[tb.idClube],
      titulo: map[tb.titulo],
      descricao: map[tb.descricao],
      idAutor: map[tb.idAutor],
      dataCriacao: map[tb.dataCriacao],
      dataLiberacao: map[tb.dataLiberacao],
      dataEncerramento: map[tb.dataEncerramento],
      excluir: map[tb.excluir],
      dataModificacao: map[tb.dataModificacao],
    );
  }

  @override
  String get dataCriacao => super.dataCriacao as String;

  @override
  String? get dataLiberacao => super.dataLiberacao as String?;

  @override
  String? get dataEncerramento => super.dataEncerramento as String?;

  @override
  DateTime decodificarDataCriacao() {
    return DbRemoto.decodificarData(dataCriacao)!;
  }

  @override
  DateTime? decodificarDataLiberacao() {
    return dataLiberacao == null
        ? null
        : DbRemoto.decodificarData(dataLiberacao);
  }

  @override
  DateTime? decodificarDataEncerramento() {
    return dataEncerramento == null
        ? null
        : DbRemoto.decodificarData(dataEncerramento);
  }
}

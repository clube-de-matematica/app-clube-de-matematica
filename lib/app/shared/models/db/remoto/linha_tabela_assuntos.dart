import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbAssuntosDbRemoto extends ILinTbAssuntos with LinTbMixin {
  LinTbAssuntosDbRemoto({
    required int id,
    required String assunto,
    List<int>? hierarquia,
    required String dataModificacao,
  }) : super(
          id: id,
          assunto: assunto,
          hierarquia: hierarquia,
          dataModificacao: dataModificacao,
        );

  factory LinTbAssuntosDbRemoto.fromMap(Map map) {
    final tb = Sql.tbAssuntos;
    return LinTbAssuntosDbRemoto(
      id: map[tb.id],
      assunto: map[tb.titulo],
      hierarquia: (map[tb.hierarquia] as List?)?.cast(),
      dataModificacao: map[tb.dataModificacao],
    );
  }

  @override
  List<int>? get hierarquia => (super.hierarquia as List?)?.cast();

  @override
  List<int>? decodificarHierarquia() => hierarquia;
}

import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbAlternativasDbRemoto extends ILinTbAlternativas with LinTbMixin {
  LinTbAlternativasDbRemoto({
    required super.idQuestao,
    required super.sequencial,
    required super.idTipo,
    required super.conteudo,
    required String super.dataModificacao,
  });

  factory LinTbAlternativasDbRemoto.fromMap(Map map) {
    const tb = Sql.tbAlternativas;
    return LinTbAlternativasDbRemoto(
      idQuestao: map[tb.idQuestao],
      sequencial: map[tb.sequencial],
      idTipo: map[tb.idTipo],
      conteudo: map[tb.conteudo],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

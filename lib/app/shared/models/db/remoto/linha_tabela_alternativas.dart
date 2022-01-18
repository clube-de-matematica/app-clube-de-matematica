import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbAlternativasDbRemoto extends ILinTbAlternativas with LinTbMixin {
  LinTbAlternativasDbRemoto({
    required int idQuestao,
    required int sequencial,
    required int idTipo,
    required String conteudo,
    required String dataModificacao,
  }) : super(
          idQuestao: idQuestao,
          sequencial: sequencial,
          idTipo: idTipo,
          conteudo: conteudo,
          dataModificacao: dataModificacao,
        );

  factory LinTbAlternativasDbRemoto.fromMap(Map map) {
    final tb = Sql.tbAlternativas;
    return LinTbAlternativasDbRemoto(
      idQuestao: map[tb.idQuestao],
      sequencial: map[tb.sequencial],
      idTipo: map[tb.idTipo],
      conteudo: map[tb.conteudo],
      dataModificacao: map[tb.dataModificacao],
    );
  }
}

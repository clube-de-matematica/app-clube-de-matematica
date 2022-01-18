import '../../../utils/strings_db.dart';
import '../../../utils/strings_db_sql.dart';
import '../interfafes_db.dart';
import 'mixin.dart';

class LinTbQuestoesDbRemoto extends ILinTbQuestoes with LinTbMixin {
  LinTbQuestoesDbRemoto({
    required int id,
    required List<String> enunciado,
    required int gabarito,
    List<Map<String, dynamic>>? imagensEnunciado,
    required String dataModificacao,
  }) : super(
          id: id,
          enunciado: enunciado,
          gabarito: gabarito,
          imagensEnunciado: imagensEnunciado,
          dataModificacao: dataModificacao,
        );

  factory LinTbQuestoesDbRemoto.fromMap(Map map) {
    final tb = Sql.tbQuestoes;
    return LinTbQuestoesDbRemoto(
      id: map[tb.id],
      enunciado: (map[tb.enunciado] as List).cast(),
      gabarito: map[tb.gabarito],
      imagensEnunciado: (map[tb.imagensEnunciado] as List?)?.cast(),
      dataModificacao: map[tb.dataModificacao],
    );
  }

  @override
  List<String> get enunciado => (super.enunciado as List).cast();

  @override
  List<Map<String, dynamic>>? get imagensEnunciado {
    return (super.imagensEnunciado as List?)?.cast();
  }

  @override
  List<String> decodificarEnunciado() => enunciado;

  @override
  List<DataImagem>? decodificarImagensEnunciado() => imagensEnunciado;
}

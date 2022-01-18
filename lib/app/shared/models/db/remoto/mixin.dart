import '../../../utils/db/codificacao.dart';
import '../interfafes_db.dart';

mixin LinTbMixin on LinTb {
  @override
  String get dataModificacao => super.dataModificacao as String;

  @override
  DateTime decodificarDataModificacao() {
    return DbRemoto.decodificarData(dataModificacao);
  }
}

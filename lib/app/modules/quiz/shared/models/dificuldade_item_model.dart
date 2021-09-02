import '../../../../shared/models/exceptions/my_exception.dart';
import '../../../../shared/utils/strings_db.dart';

///Os níveis de dificuldade disponíneis são: [baixa], [media], [alta].
enum NiveisDificuldade { baixa, media, alta }

///Contém as propriedade do nível de dificuldade do item.
class Dificuldade {
  ///Todas as instâncias criadas.
  static final List<Dificuldade> instancias = <Dificuldade>[];

  final NiveisDificuldade dificuldade;

  ///Construtor interdo.
  Dificuldade._interno(this.dificuldade);

  ///Método encarregado de criar as instâncias.
  static Dificuldade _novaInstancia(NiveisDificuldade dificuldade) {
    final instancia = Dificuldade._interno(dificuldade);
    instancias.add(instancia);
    return instancia;
  }

  ///Caso haja em [instancias] uma instância correspondente a [dificuldade],
  ///ela será retornada, caso contrário será criada uma nova.
  factory Dificuldade(NiveisDificuldade dificuldade) {
    return instancias.firstWhere(
        (element) => element.dificuldade == dificuldade,
        orElse: () => _novaInstancia(dificuldade));
  }

  ///Caso haja em [instancias] uma instância correspondente a [string],
  ///ela será retornada, caso contrário será criada uma nova.
  factory Dificuldade.fromString(String string) {
    final dificuldade = _fromString(string);
    return instancias.firstWhere(
        (element) => element.dificuldade == dificuldade,
        orElse: () => _novaInstancia(dificuldade));
  }

  ///Retorna um [NiveisDificuldade] a partir da string que o representa.
  // ignore: missing_return
  static NiveisDificuldade _fromString(String string) {
    if (string == DbConst.kDbDataQuestaoKeyDificuldadeValBaixa)
      return NiveisDificuldade.baixa;
    if (string == DbConst.kDbDataQuestaoKeyDificuldadeValMedia)
      return NiveisDificuldade.media;
    if (string == DbConst.kDbDataQuestaoKeyDificuldadeValAlta)
      return NiveisDificuldade.alta;
    else
      throw MyException(
        "String inválida!",
        originClass: "Dificuldade",
        originField: "_fromString()",
        fieldDetails: "string == $string",
      );
  }

  @override
  String toString() {
    switch (this.dificuldade) {
      case NiveisDificuldade.baixa:
        return DbConst.kDbDataQuestaoKeyDificuldadeValBaixa;
      case NiveisDificuldade.media:
        return DbConst.kDbDataQuestaoKeyDificuldadeValMedia;
      case NiveisDificuldade.alta:
        return DbConst.kDbDataQuestaoKeyDificuldadeValAlta;
    }
  }

  ///Sobrescrever o operador de igualdade.
  @override
  bool operator ==(Object other) {
    return other is Dificuldade && this.dificuldade == other.dificuldade;
  }

  @override
  int get hashCode => dificuldade.hashCode;
}

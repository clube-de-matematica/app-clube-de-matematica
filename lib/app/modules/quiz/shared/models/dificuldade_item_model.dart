import '../utils/strings_db_remoto.dart';

///Os níveis de dificuldade disponíneis são: [baixa], [media], [alta].
enum NiveisDificuldade{baixa, media, alta}

///Contém as propriedade do nível de dificuldade do item.
class Dificuldade {
  ///Todas as instâncias criadas.
  static final List<Dificuldade> instancias = List<Dificuldade>();

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
    assert(dificuldade != null);
    return instancias.firstWhere(
      (element) => element.dificuldade == dificuldade, 
      orElse: () => _novaInstancia(dificuldade)
    );
  }

  ///Caso haja em [instancias] uma instância correspondente a [string], 
  ///ela será retornada, caso contrário será criada uma nova.
  factory Dificuldade.fromString(String string) {
    assert(string != null);
    final dificuldade = _fromString(string);
    return instancias.firstWhere(
      (element) => element.dificuldade == dificuldade, 
      orElse: () => _novaInstancia(dificuldade)
    );
  }

  ///Retorna um [NiveisDificuldade] a partir da string que o representa.
  static NiveisDificuldade _fromString(String string){
    if (string == DB_FIRESTORE_DOC_ITEM_DIFICULDADE_BAIXA) 
        return NiveisDificuldade.baixa;
    if (string == DB_FIRESTORE_DOC_ITEM_DIFICULDADE_MEDIA) 
        return NiveisDificuldade.media;
    if (string == DB_FIRESTORE_DOC_ITEM_DIFICULDADE_ALTA) 
        return NiveisDificuldade.alta;
  }

  @override
  String toString() {
    switch (this.dificuldade) {
      case NiveisDificuldade.baixa:
        return DB_FIRESTORE_DOC_ITEM_DIFICULDADE_BAIXA;
      case NiveisDificuldade.media:
        return DB_FIRESTORE_DOC_ITEM_DIFICULDADE_MEDIA;
      case NiveisDificuldade.alta:
        return DB_FIRESTORE_DOC_ITEM_DIFICULDADE_ALTA;
      default:
        return null;
    }
  }

  ///Sobrescrever o operador de igualdade.
  @override
  bool operator ==(Object other) {
    return other is Dificuldade && this.dificuldade == other.dificuldade;
  }
}


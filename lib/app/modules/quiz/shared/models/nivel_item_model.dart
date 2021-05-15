///Contém o nível da prova do item e uma lista com todas as instâncias de [Nivel].

class Nivel {
  ///Todas as instâncias criadas.
  static final List<Nivel> instancias = <Nivel>[];

  ///Um inteiro que representa o nível da prova.
  final int valor;

  ///Construtor interdo.
  Nivel._interno(this.valor);

  ///Método encarregado de criar as instâncias.
  static Nivel _novaInstancia(int valor) {
    final instancia = Nivel._interno(valor);
    instancias.add(instancia);
    return instancia;
  }

  ///Caso haja em [instancias] uma instância correspondente a [valor],
  ///ela será retornada, caso contrário será criada uma nova.
  factory Nivel(int valor) {
    return instancias.firstWhere((element) => element.valor == valor,
        orElse: () => _novaInstancia(valor));
  }

  @override
  String toString() {
    return this.valor.toString();
  }

  ///Sobrescrever o operador de igualdade.
  @override
  bool operator ==(Object other) {
    return other is Nivel && this.valor == other.valor;
  }

  @override
  int get hashCode => super.hashCode;
}

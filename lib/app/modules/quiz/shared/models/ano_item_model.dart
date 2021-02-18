///Contém o ano de aplicação do item e uma lista com todas as instâncias de [Ano].
class Ano {
  ///Todas as instâncias criadas.
  static final List<Ano> instancias = List<Ano>();
  ///Um inteiro que representa o ano de aplicação da prova.
  final int valor;

  ///Construtor interdo.
  Ano._interno(this.valor);

  ///Método encarregado de criar as instâncias.
  static Ano _novaInstancia(int valor) {
    final instancia = Ano._interno(valor);
    instancias.add(instancia);
    return instancia;
  }

  ///Caso haja em [instancias] uma instância correspondente a [valor], 
  ///ela será retornada, caso contrário será criada uma nova.
  factory Ano(int valor) {
    assert(valor != null);
    return instancias.firstWhere(
      (element) => element.valor == valor, 
      orElse: () => _novaInstancia(valor)
    );
  }

  @override
  String toString() {
    return this.valor.toString();
  }

  ///Sobrescrever o operador de igualdade.
  @override
  bool operator ==(Object other) {
    return other is Ano && this.valor == other.valor;
  }
}


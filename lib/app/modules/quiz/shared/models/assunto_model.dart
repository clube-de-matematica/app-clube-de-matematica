import '../utils/strings_db_remoto.dart';

///Esta classe está configurada para, usando o padrão singleton, não criar duas instâncias
///com o mesmo título.
class Assunto {
  ///Lista de todas as instâncias criadas.
  static List<Assunto> _instancias = <Assunto>[];

  ///Hierarquia de assuntos acima do assunto em [titulo].
  final List<String> arvore;

  ///O título do assunto.
  final String titulo;

  ///Posição (iniciando em zero) do assunto em uma hierarquia completa ([arvore] mais
  ///[titulo]). O índice zero indica que o assunto é uma unidade.
  int get indiceHierarquia => arvore.length;

  ///Assunto no índice zero da hierarquia [arvore].
  ///Se [arvore] for vazio temos [unidade] = [titulo].
  String get unidade => arvore.isEmpty ? titulo : arvore[0];

  Assunto._interno({required this.arvore, required this.titulo}) {
    _instancias.add(this);
  }

  ///Retorna o primeiro elemento que satisfaz `element.titulo == titulo`.
  ///Se nenhum elemento satisfizer `element.titulo == titulo`, o resultado da chamada da
  ///função `orElse` será retornado.
  ///A função `orElse` retorna uma nova instância de [Assunto]. Essa instância é adiciona em [_instancias].
  factory Assunto({required List<String> arvore, required String titulo}) {
    return _instancias.firstWhere(
      (element) => element.titulo == titulo,
      orElse: () => Assunto._interno(arvore: arvore, titulo: titulo),
    );
  }

  factory Assunto.fromJson(Map<String, dynamic> json) {
    final bool isNotUnidade = json.containsKey(DB_FIRESTORE_DOC_ASSUNTO_ARVORE);

    ///`json[DB_FIRESTORE_DOC_ASSUNTO_ARVORE]` é um `List<dynamic>`.
    ///`cast<String>()` informa que é um `List<String>`. Ocorrerá um erro se algum dos valores
    ///não for `String`.
    List<String> arvore = isNotUnidade
        ? json[DB_FIRESTORE_DOC_ASSUNTO_ARVORE].cast<String>()
        : <String>[];
    return Assunto(
      arvore: arvore,
      titulo: json[DB_FIRESTORE_DOC_ASSUNTO_TITULO],
    );
  }

  ///Será true se o assunto não possuir hierarquia.
  bool get isUnidade => indiceHierarquia == 0;

  ///Retorna uma lista com as instâncias de [Assunto].
  static List<Assunto> get instancias => _instancias;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (!isUnidade) data[DB_FIRESTORE_DOC_ASSUNTO_ARVORE] = this.arvore;
    data[DB_FIRESTORE_DOC_ASSUNTO_TITULO] = this.titulo;
    return data;
  }

  @override
  String toString() {
    return this.titulo;
  }

  ///Sobrescrever o operador de igualdade.
  @override
  bool operator ==(Object other) {
    return other is Assunto && this.titulo == other.titulo;
  }

  @override
  int get hashCode => super.hashCode;
}

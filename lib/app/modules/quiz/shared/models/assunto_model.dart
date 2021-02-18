import 'package:flutter/foundation.dart';

import '../utils/strings_db_remoto.dart';

///Esta classe está configurada para, usando o padrão singleton, não criar duas instâncias 
///com o mesmo título.
class Assunto {
  ///Lista de todas as instâncias criadas.
  static List<Assunto> _instancias = List<Assunto>();
  ///Hierarquia de assuntos acima do assunto em [titulo].
  final List<String> arvore;
  ///O título do assunto.
  final String titulo;
  ///Posição (iniciando em zero) do assunto em uma hierarquia completa ([arvore] mais 
  ///[titulo]). O índice zero indica que o assunto é uma unidade.
  final int indiceHierarquia;
  ///Assunto no índice zero da hierarquia [arvore]. 
  ///Se [arvore] for `null` ou vazio temos [unidade] = [titulo].
  final String unidade;

  Assunto._interno({@required List<String> arvore, @required this.titulo})
    : this.arvore = arvore, 
    this.indiceHierarquia = (arvore == null ? 0 : arvore.length),
    this.unidade = (arvore == null ? titulo : arvore[0]),
    assert(titulo != null);

  factory Assunto({@required List<String> arvore, @required String titulo}) {
    assert(titulo != null);
    ///Retorna o primeiro elemento que satisfaz `element.titulo == titulo`.
    ///Se nenhum elemento satisfizer `element.titulo == titulo`, o resultado da chamada da 
    ///função `orElse` será retornado.
    ///A função `orElse` cria uma nova instância de [Assunto], adiciona em [_instancias] e 
    ///retorna essa instância.
    return _instancias.firstWhere(
      (element) => element.titulo == titulo, 
      orElse: () {
        if (arvore != null && arvore.length == 0) arvore = null;
        final assunto = Assunto._interno(arvore: arvore, titulo: titulo);
        _instancias.add(assunto);
        return assunto;
      }
    );
  }

  factory Assunto.fromJson(Map<String, dynamic> json) {
    List<String> arvore;
    if (json.containsKey(DB_FIRESTORE_DOC_ASSUNTO_ARVORE)) {
      ///`json[DB_DOC_ASSUNTO_ARVORE]` é um `List<dynamic>`.
      ///`cast<String>()` informa que é um `List<String>`. Ocorrerá um erro se algum dos valores 
      ///não for `String`.
      arvore = json[DB_FIRESTORE_DOC_ASSUNTO_ARVORE].cast<String>();
    }
    return Assunto(
      arvore: arvore, 
      titulo: json[DB_FIRESTORE_DOC_ASSUNTO_TITULO]
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
}

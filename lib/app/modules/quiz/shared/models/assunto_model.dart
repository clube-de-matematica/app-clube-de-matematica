import 'dart:ui';

import 'package:clubedematematica/app/shared/models/exceptions/my_exception.dart';

import '../../../../shared/utils/strings_db.dart';

/// Esta classe está configurada para, usando o padrão singleton, não criar duas instâncias
/// com o mesmo título.
class Assunto {
  /// Lista de todas as instâncias criadas.
  static List<Assunto> _instancias = <Assunto>[];

  /// ID do assunto no banco de dados.
  final int id;

  /// Hierarquia de assuntos acima do assunto [titulo]. Isto é uma lista de ID's de assuntos.
  final DataHierarquia hierarquia;

  /// O título do assunto.
  final String titulo;

  /// Posição (iniciando em zero) do assunto em uma hierarquia completa ([hierarquia] mais
  /// [titulo]). O índice zero indica que o assunto é uma unidade.
  int get indiceHierarquia => hierarquia.length;

  /// Assunto no índice zero da hierarquia [hierarquia].
  /// Se [hierarquia] for vazio temos [unidade] = [this].
  Assunto get unidade {
    if (hierarquia.isEmpty)
      return this;
    else
      return _instancias.firstWhere(
        (element) => element.id == hierarquia[0],
        orElse: () => throw MyException(
            'A unidade do assunto $titulo (id = $id) não foi instanciada.'),
      );
  }

  Assunto._interno({
    required this.id,
    required this.hierarquia,
    required this.titulo,
  }) {
    _instancias.add(this);
  }

  /// Retorna o primeiro elemento que satisfaz `element.id == id`.
  /// Se nenhum elemento satisfizer `element.id == id`, o resultado da chamada da
  /// função `orElse` será retornado.
  /// A função `orElse` retorna uma nova instância de [Assunto].
  /// Essa instância é adiciona em [_instancias].
  factory Assunto(
      {required int id,
      required List<int> hierarquia,
      required String titulo}) {
    return _instancias.firstWhere(
      (element) => element.id == id,
      orElse: () => Assunto._interno(
        id: id,
        hierarquia: hierarquia,
        titulo: titulo,
      ),
    );
  }

  factory Assunto.fromJson(Map<String, dynamic> json) {
    // `json[DbConst.kDbDataAssuntoKeyHierarquia]` é um `List<dynamic>`.
    // `cast<int>()` informa que é um `List<int>`. Ocorrerá um erro se algum dos valores
    // não for `int`.
    List<int> hierarquia =
        (json[DbConst.kDbDataAssuntoKeyHierarquia] as List).cast<int>();

    return Assunto(
      id: json[DbConst.kDbDataAssuntoKeyId],
      hierarquia: hierarquia,
      titulo: json[DbConst.kDbDataAssuntoKeyTitulo],
    );
  }

  /// Será true se o assunto não possuir hierarquia.
  bool get isUnidade => hierarquia.isEmpty;

  /// Retorna uma lista com as instâncias de [Assunto].
  static List<Assunto> get instancias => _instancias;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (!isUnidade) data[DbConst.kDbDataAssuntoKeyHierarquia] = this.hierarquia;
    data[DbConst.kDbDataAssuntoKeyTitulo] = this.titulo;
    return data;
  }

  @override
  String toString() {
    return this.titulo;
  }

  /// Sobrescrever o operador de igualdade.
  @override
  bool operator ==(Object other) {
    return other is Assunto && this.id == other.id;
  }

  @override
  int get hashCode => hashValues(id, hierarquia, titulo);
}

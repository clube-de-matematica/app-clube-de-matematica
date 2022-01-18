import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../shared/models/exceptions/my_exception.dart';
import '../../../../shared/utils/strings_db.dart';

/// Esta classe está configurada para, usando o padrão singleton, não criar duas instâncias
/// com o mesmo [id].
class Assunto extends RawAssunto {
  /// Conjunto de todas as instâncias criadas.
  static Set<Assunto> _instancias = Set<Assunto>();

  /// ID do assunto no banco de dados.
  final int id;

  /// Hierarquia de assuntos acima do assunto [titulo]. Isto é uma lista de ID's de assuntos.
  final DataHierarquia hierarquia;

  /// O título do assunto.
  final String titulo;

  /// Data de modificação deste assunto no banco de dados.
  final DateTime dataModificacao;

  /// Posição (iniciando em zero) do assunto em uma hierarquia completa ([hierarquia] mais
  /// [titulo]). O índice zero indica que o assunto é uma unidade.
  int get indiceHierarquia => hierarquia.length;

  /// Assunto no índice zero da hierarquia [hierarquia].
  /// Se [hierarquia] for vazio temos [unidade] = [this].
  /// Lança [MyException] se [hierarquia] não for vazia e o assunto correspondente a unidade
  /// não for encontrado.
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
    required this.dataModificacao,
  }) {
    _instancias.add(this);
  }

  /// Retorna o primeiro elemento que satisfaz `element.id == id`.
  /// Se nenhum elemento satisfizer `element.id == id`, o resultado da chamada da
  /// função `orElse` será retornado.
  /// A função `orElse` retorna uma nova instância de [Assunto].
  /// Essa instância é adiciona em [_instancias].
  factory Assunto({
    required int id,
    required List<int> hierarquia,
    required String titulo,
    required DateTime dataModificacao,
  }) {
    return get(id) ??
        Assunto._interno(
          id: id,
          hierarquia: hierarquia,
          titulo: titulo,
          dataModificacao: dataModificacao,
        );
  }

  factory Assunto.fromDataAssunto(DataAssunto dados) {
    // `json[DbConst.kDbDataAssuntoKeyHierarquia]` é um `List<dynamic>`.
    // `cast<int>()` informa que é um `List<int>`. Ocorrerá um erro se algum dos valores
    // não for `int`.
    List<int> hierarquia =
        (dados[DbConst.kDbDataAssuntoKeyHierarquia] as List).cast<int>();

    return Assunto(
      id: dados[DbConst.kDbDataAssuntoKeyId] as int,
      hierarquia: hierarquia,
      titulo: dados[DbConst.kDbDataAssuntoKeyTitulo] as String,
      dataModificacao: DateTime.fromMillisecondsSinceEpoch(
        dados[DbConst.kDbDataDocumentKeyDataModificacao] as int,
        isUtc: true,
      ),
    );
  }

  /// Será true se o assunto não possuir hierarquia.
  bool get isUnidade => hierarquia.isEmpty;

  /// Retorna um conjunto com as instâncias de [Assunto].
  static Set<Assunto> get instancias => _instancias;

  /// Retorna o assunto correspondente a [id] em [instancias].
  /// Retorna null se o assunto não for encontrado.
  static Assunto? get(int id) {
    return _instancias.cast().firstWhere(
          (element) => element.id == id,
          orElse: () => null,
        );
  }

  String toJson() => json.encode(toDataAssunto());

  factory Assunto.fromJson(String source) =>
      Assunto.fromDataAssunto(json.decode(source));

  @override
  String toString() {
    return 'Assunto(id: $id, hierarquia: $hierarquia, titulo: $titulo, dataModificacao: $dataModificacao)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Assunto &&
        other.id == id &&
        listEquals(other.hierarquia, hierarquia) &&
        other.titulo == titulo &&
        other.dataModificacao == dataModificacao;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        hierarquia.hashCode ^
        titulo.hashCode ^
        dataModificacao.hashCode;
  }
}

class RawAssunto {
  RawAssunto({
    this.id,
    this.hierarquia,
    this.titulo,
    this.dataModificacao,
  });

  final int? id;
  final DataHierarquia? hierarquia;
  final String? titulo;
  final DateTime? dataModificacao;

  DataAssunto toDataAssunto() {
    final data = DataAssunto();
    if (hierarquia?.isNotEmpty ?? false) {
      data[DbConst.kDbDataAssuntoKeyHierarquia] = this.hierarquia;
    }
    data
      ..[DbConst.kDbDataAssuntoKeyTitulo] = this.titulo
      ..[DbConst.kDbDataAssuntoKeyId] = this.id
      ..[DbConst.kDbDataDocumentKeyDataModificacao] =
          this.dataModificacao?.toUtc().millisecondsSinceEpoch;

    return data;
  }
}

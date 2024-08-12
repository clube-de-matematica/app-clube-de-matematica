import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/utils/strings_db.dart';

/// Esta classe está configurada para, usando o padrão singleton, não criar duas instâncias
/// com o mesmo [id].
class Assunto extends RawAssunto {
  /// Conjunto de todas as instâncias criadas.
  static final ObservableSet<Assunto> _instancias = ObservableSet<Assunto>();

  /// ID do assunto no banco de dados.
  @override
  int get id => super.id!; // A garantia de que não será nulo ocorre no construtor interno.

  /// Hierarquia de assuntos acima do assunto [titulo]. Isto é uma lista de ID's de assuntos.
  @override
  DataHierarquia get hierarquia => super.hierarquia!; // A garantia de que não será nulo ocorre no construtor interno.

  /// O título do assunto.
  @override
  String get titulo => super.titulo!; // A garantia de que não será nulo ocorre no construtor interno.

  /// Posição (iniciando em zero) do assunto em uma hierarquia completa ([hierarquia] mais
  /// [titulo]). O índice zero indica que o assunto é uma unidade.
  int get indiceHierarquia => hierarquia.length;

  /// ID do assunto no índice zero da hierarquia [hierarquia].
  /// Retorna `null` se o assunto é uma unidade.
  int? get idUnidade {
    if (isUnidade) return null;
    return hierarquia[0];
  }

  Assunto._interno({
    required int id, //Qualquer alteração deve levar em conta a garantia de não nulidade no geters de mesmo nome
    required DataHierarquia hierarquia, //Qualquer alteração deve levar em conta a garantia de não nulidade no geters de mesmo nome
    required String titulo, //Qualquer alteração deve levar em conta a garantia de não nulidade no geters de mesmo nome
  }) : super(
          id: id, //Qualquer alteração deve levar em conta a garantia de não nulidade no geters de mesmo nome
          hierarquia: hierarquia, //Qualquer alteração deve levar em conta a garantia de não nulidade no geters de mesmo nome
          titulo: titulo, //Qualquer alteração deve levar em conta a garantia de não nulidade no geters de mesmo nome
        ) {
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
  }) {
    return _get(id) ??
        Assunto._interno(
          id: id,
          hierarquia: hierarquia,
          titulo: titulo,
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
    );
  }

  /// Será true se o assunto não possuir hierarquia.
  bool get isUnidade => hierarquia.isEmpty;

  /// Retorna um conjunto com as instâncias de [Assunto].
  static ObservableSet<Assunto> get instancias => _instancias;

  /// Retorna o assunto correspondente a [id] em [instancias].
  /// Retorna null se o assunto não for encontrado.
  static Assunto? _get(int id) {
    return _instancias.cast<Assunto?>().firstWhere(
          (element) => element?.id == id,
          orElse: () => null,
        );
  }

  String toJson() => json.encode(toDataAssunto());

  factory Assunto.fromJson(String source) =>
      Assunto.fromDataAssunto(json.decode(source));

  @override
  String toString() {
    return 'Assunto(id: $id, hierarquia: $hierarquia, titulo: $titulo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Assunto &&
        other.id == id &&
        listEquals(other.hierarquia, hierarquia) &&
        other.titulo == titulo;
  }

  @override
  int get hashCode {
    return id.hashCode ^ hierarquia.hashCode ^ titulo.hashCode;
  }
}

class RawAssunto {
  RawAssunto({
    this.id,
    this.hierarquia,
    this.titulo,
  });

  final int? id;
  final DataHierarquia? hierarquia;
  final String? titulo;

  DataAssunto toDataAssunto() {
    final data = DataAssunto();
    if (hierarquia?.isNotEmpty ?? false) {
      data[DbConst.kDbDataAssuntoKeyHierarquia] = hierarquia;
    }
    data
      ..[DbConst.kDbDataAssuntoKeyTitulo] = titulo
      ..[DbConst.kDbDataAssuntoKeyId] = id;

    return data;
  }
}

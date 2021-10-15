import 'dart:convert';

import 'package:clubedematematica/app/modules/clubes/shared/utils/random_colors.dart';
import 'package:flutter/painting.dart';

class Clube {
  /// ID do clube.
  final int id;

  /// Nome do clube.
  final String nome;

  /// Uma pequena descrição do clube.
  final String? descricao;

  /// ID do proprietário do clube.
  final int proprietario;

  /// Lista com o ID de cada administrador do clube.
  final List<int> administradores;

  /// Lista com o ID de cada membro (excluindo-se proprietário e administradores) do clube.
  final List<int> membros;

  /// Cor de fundo do [Card] e do avatar do clube.
  final Color capa;

  Clube({
    required this.id,
    required this.nome,
    this.descricao,
    required this.proprietario,
    this.administradores = const [],
    this.membros = const [],
    Color? capa,
  }) : this.capa = capa ?? RandomColor();

  factory Clube.fromMap(Map<String, dynamic> map) {
    return Clube(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      proprietario: map['proprietario'],
      administradores: List<int>.from(map['administradores']),
      membros: List<int>.from(map['membros']),
      //TODO: Capa do clube.
      capa: map['capa'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'proprietario': proprietario,
      'administradores': administradores,
      'membros': membros,
    };
  }

  factory Clube.fromJson(String source) => Clube.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

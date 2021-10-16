import 'dart:convert';

import 'package:flutter/painting.dart';

import '../../../../shared/utils/strings_db.dart';
import '../utils/random_colors.dart';

/// Permissões de acesso do usuário aos clubes.
enum PermissoesClube {
  /// O usuário atual é o propriietário do clube.
  proprietario,

  /// O usuário atual é o administrador do clube.
  administrador,

  /// O usuário atual não é proprietário nem administrador, mas pertence ao clube.
  membro,

  /// O usuário atual não pertence ao clube. Não pode acessar as informações do clube.
  externo,
}

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

  /// O ID base62 para acesso ao clube.
  final String? codigo;

  Clube({
    required this.id,
    required this.nome,
    this.descricao,
    required this.proprietario,
    this.administradores = const [],
    this.membros = const [],
    Color? capa,
    this.codigo,
  }) : this.capa = capa ?? RandomColor();

  factory Clube.fromMap(Map<String, dynamic> map) {
    return Clube(
      id: map[DbConst.kDbDataClubeKeyId],
      nome: map[DbConst.kDbDataClubeKeyNome],
      descricao: map[DbConst.kDbDataClubeKeyDescricao],
      proprietario: map[DbConst.kDbDataClubeKeyProprietario],
      administradores:
          List<int>.from(map[DbConst.kDbDataClubeKeyAdministradores]),
      membros: List<int>.from(map[DbConst.kDbDataClubeKeyMembros]),
      capa: map[DbConst.kDbDataClubeKeyCapa],
      codigo: map[DbConst.kDbDataClubeKeyCodigo],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DbConst.kDbDataClubeKeyId: id,
      DbConst.kDbDataClubeKeyNome: nome,
      DbConst.kDbDataClubeKeyDescricao: descricao,
      DbConst.kDbDataClubeKeyProprietario: proprietario,
      DbConst.kDbDataClubeKeyAdministradores: administradores,
      DbConst.kDbDataClubeKeyMembros: membros,
      DbConst.kDbDataClubeKeyCapa: capa,
      DbConst.kDbDataClubeKeyCodigo: codigo,
    };
  }

  factory Clube.fromJson(String source) => Clube.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  /// Retorna a permissão de acesso do usuário correspondente ao [id] aos dados do clube.
  PermissoesClube permissao(int id) {
    if (id == proprietario) return PermissoesClube.proprietario;
    if (administradores.contains(id)) return PermissoesClube.administrador;
    if (membros.contains(id)) return PermissoesClube.membro;
    return PermissoesClube.externo;
  }
}

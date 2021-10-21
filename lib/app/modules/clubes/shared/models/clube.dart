import 'dart:convert';

import 'package:clubedematematica/app/shared/models/debug.dart';
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
  String nome;

  /// Uma pequena descrição do clube.
  String? descricao;

  /// ID do proprietário do clube.
  final int proprietario;

  /// Lista com o ID de cada administrador do clube.
  final List<int> administradores;

  /// Lista com o ID de cada membro (excluindo-se proprietário e administradores) do clube.
  final List<int> membros;

  /// Cor de fundo do [Card] e do avatar do clube.
  Color capa;

  /// O ID base62 para acesso ao clube.
  String codigo;

  /// Define o nível de privacidade do clube.
  /// * Se `false`, o clube é público. Qualquer usuário com o código de acesso pode ingressar.
  /// * Se `true`, o clube é privado. O ingresso depende da permissão de um administrador.
  bool privado;

  Clube({
    required this.id,
    required this.nome,
    this.descricao,
    required this.proprietario,
    this.administradores = const [],
    this.membros = const [],
    Color? capa,
   required this.codigo,
    required this.privado,
  }) : this.capa = capa ?? RandomColor();

  factory Clube.fromMap(Map<String, dynamic> map) {
    Color? _capa;
    try {
      _capa = Color(int.parse(map[DbConst.kDbDataClubeKeyCapa]));
    } catch (_) {
      assert(Debug.print('Não foi possível gerar a cor da capa a partir de '
          '${map[DbConst.kDbDataClubeKeyCapa]}.'));
    }
    return Clube(
      id: map[DbConst.kDbDataClubeKeyId],
      nome: map[DbConst.kDbDataClubeKeyNome],
      descricao: map[DbConst.kDbDataClubeKeyDescricao],
      proprietario: map[DbConst.kDbDataClubeKeyProprietario],
      administradores:
          List<int>.from(map[DbConst.kDbDataClubeKeyAdministradores]),
      membros: List<int>.from(map[DbConst.kDbDataClubeKeyMembros]),
      capa: _capa,
      codigo: map[DbConst.kDbDataClubeKeyCodigo],
      privado: map[DbConst.kDbDataClubeKeyPrivado],
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
      DbConst.kDbDataClubeKeyCapa: '${capa.value}',
      DbConst.kDbDataClubeKeyCodigo: codigo,
      DbConst.kDbDataClubeKeyPrivado: privado,
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

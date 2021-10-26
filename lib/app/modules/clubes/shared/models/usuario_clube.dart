import 'dart:convert';

import '../../../perfil/models/userapp.dart';
import 'clube.dart';

/// Modelo para os dados de um usuário de clube.
class UsuarioClube {
  final int id;
  String? email;
  String? nome;
  String? foto;
  final int idClube;
  PermissoesClube permissao;

  UsuarioClube({
    required this.id,
    this.email,
    this.nome,
    this.foto,
    required this.idClube,
    required this.permissao,
  });

  /// Verdadeiro se for o corresponder ao usuário atual do aplicativo.
  bool get isUserApp =>
      (UserApp.instance.id != null) && (UserApp.instance.id == id);

  /// Verdadeiro se este usuário for proprietátio do clube.
  bool get proprietario => permissao == PermissoesClube.proprietario;

  /// Verdadeiro se este usuário for administrador do clube.
  bool get administrador => permissao == PermissoesClube.administrador;

  /// Verdadeiro se este usuário do clube não for proprietátio nem administrador.
  bool get membro => permissao == PermissoesClube.membro;

  UsuarioClube copyWith({
    int? id,
    String? email,
    String? nome,
    String? foto,
    int? idClube,
    PermissoesClube? permissao,
  }) {
    return UsuarioClube(
      id: id ?? this.id,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      foto: foto ?? this.foto,
      idClube: idClube ?? this.idClube,
      permissao: permissao ?? this.permissao,
    );
  }

//TODO: Ajustar os nomes das keys
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nome': nome,
      'foto': foto,
      'idClube': idClube,
      'permissao': permissao.id,
    };
  }

  factory UsuarioClube.fromMap(Map<String, dynamic> map) {
    return UsuarioClube(
      id: map['id'],
      email: map['email'] != null ? map['email'] : null,
      nome: map['nome'] != null ? map['nome'] : null,
      foto: map['foto'] != null ? map['foto'] : null,
      idClube: map['idClube'],
      permissao: PermissoesClube.values.firstWhere(
        (valor) => valor.id == map['permissao'],
        orElse: () => PermissoesClube.externo,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioClube.fromJson(String source) =>
      UsuarioClube.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UsuarioClube(id: $id, email: $email, nome: $nome, foto: $foto, idClube: $idClube, permissao: $permissao)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UsuarioClube &&
        other.id == id &&
        other.email == email &&
        other.nome == nome &&
        other.foto == foto &&
        other.idClube == idClube &&
        other.permissao == permissao;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        nome.hashCode ^
        foto.hashCode ^
        idClube.hashCode ^
        permissao.hashCode;
  }
}

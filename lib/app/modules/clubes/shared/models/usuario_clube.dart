import 'package:mobx/mobx.dart';

import '../../../perfil/models/userapp.dart';
import 'clube.dart';

part 'usuario_clube.g.dart';

/// Modelo para os dados de um usuário de clube.
class UsuarioClube = _UsuarioClubeBase with _$UsuarioClube;

abstract class _UsuarioClubeBase extends RawUsuarioClube with Store {
  final int id;
  @observable
  String? email;
  @observable
  String? nome;
  @observable
  String? foto;
  final int idClube;
  @observable
  PermissoesClube permissao;

  _UsuarioClubeBase({
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
  @computed
  bool get proprietario => permissao == PermissoesClube.proprietario;

  /// Verdadeiro se este usuário for administrador do clube.
  @computed
  bool get administrador => permissao == PermissoesClube.administrador;

  /// Verdadeiro se este usuário do clube não for proprietátio nem administrador.
  @computed
  bool get membro => permissao == PermissoesClube.membro;

  /// Sobrescreve os campos deste usuário com os respectivos valores em [outro], desde que
  /// seus respectivos [id] e [idClube] sejam iguais.
  @action
  void sobrescrever(UsuarioClube outro) {
    if (this.id == outro.id) {
      email = outro.email;
      nome = outro.nome;
      foto = outro.foto;
      permissao = outro.permissao;
    }
  }

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

/// Usada para preencher parcialmente os dados de um usuário de clube.
class RawUsuarioClube {
  RawUsuarioClube({
    this.id,
    this.email,
    this.nome,
    this.foto,
    this.idClube,
    this.permissao,
  });

  final int? id;
  final String? email;
  final String? nome;
  final String? foto;
  final int? idClube;
  final PermissoesClube? permissao;

  RawUsuarioClube copyWith({
    int? id,
    String? email,
    String? nome,
    String? foto,
    int? idClube,
    PermissoesClube? permissao,
  }) {
    return RawUsuarioClube(
      id: id ?? this.id,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      foto: foto ?? this.foto,
      idClube: idClube ?? this.idClube,
      permissao: permissao ?? this.permissao,
    );
  }
}

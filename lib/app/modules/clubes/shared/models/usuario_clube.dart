import 'package:mobx/mobx.dart';

import '../../../../shared/utils/strings_db.dart';
import '../../../perfil/models/userapp.dart';
import 'clube.dart';

part 'usuario_clube.g.dart';

/// Modelo para um usuário de clube.
class UsuarioClube = UsuarioClubeBase with _$UsuarioClube;

abstract class UsuarioClubeBase with Store {
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

  UsuarioClubeBase({
    required this.id,
    // ignore: unused_element
    this.email,
    // ignore: unused_element
    this.nome,
    // ignore: unused_element
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

  /// Sobrescreve os campos modificáveis deste usuário com os respectivos valores em [outro].
  @action
  void mesclar(UsuarioClube outro) {
    email = outro.email;
    nome = outro.nome;
    foto = outro.foto;
    permissao = outro.permissao;
  }

  // ignore: unused_element
  UsuarioClubeBase.fromDataUsuarioClube(DataUsuarioClube dados)
      : id = dados[DbConst.kDbDataUserClubeKeyIdUsuario],
        email = dados[DbConst.kDbDataUserClubeKeyEmail],
        nome = dados[DbConst.kDbDataUserClubeKeyNome],
        foto = dados[DbConst.kDbDataUserClubeKeyFoto],
        idClube = dados[DbConst.kDbDataUserClubeKeyIdClube],
        permissao = PermissoesClube.obter(
            dados[DbConst.kDbDataUserClubeKeyIdPermissao])!;

  DataUsuarioClube toDataUsuarioClube() {
    return {
      DbConst.kDbDataUserClubeKeyIdUsuario: id,
      DbConst.kDbDataUserClubeKeyEmail: email,
      DbConst.kDbDataUserClubeKeyNome: nome,
      DbConst.kDbDataUserClubeKeyFoto: foto,
      DbConst.kDbDataUserClubeKeyIdClube: idClube,
      DbConst.kDbDataUserClubeKeyIdPermissao: permissao.id,
    };
  }

  @override
  String toString() {
    return (StringBuffer('UsuarioClube(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('nome: $nome, ')
          ..write('foto: $foto, ')
          ..write('idClube: $idClube, ')
          ..write('permissao: $permissao)'))
        .toString();
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

  DataUsuarioClube toDataUsuarioClube() {
    return {
      if (id != null) DbConst.kDbDataUserClubeKeyIdUsuario: id,
      if (email != null) DbConst.kDbDataUserClubeKeyEmail: email,
      if (nome != null) DbConst.kDbDataUserClubeKeyNome: nome,
      if (foto != null) DbConst.kDbDataUserClubeKeyFoto: foto,
      if (idClube != null) DbConst.kDbDataUserClubeKeyIdClube: idClube,
      if (permissao != null) DbConst.kDbDataUserClubeKeyIdPermissao: permissao,
    };
  }
}

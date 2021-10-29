import 'package:clubedematematica/app/modules/clubes/shared/models/clube.dart';
import 'package:clubedematematica/app/modules/clubes/shared/models/usuario_clube.dart';
import 'package:clubedematematica/app/modules/clubes/shared/repositories/clubes_repository.dart';
import 'package:clubedematematica/app/modules/perfil/models/userapp.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../navigation.dart';

/// Uma enumeração para os itens do menu de opções dos clubes.
enum OpcoesUsuarioClube {
  promoverAdmin,
  removerAdmin,
  sairAdmin,
  remover,
  sair,
}

class ClubeController {
  ClubeController(this.clube);

  final Clube clube;

  ClubesRepository get repository => Modular.get<ClubesRepository>();

  /// O [UsuarioClube] correspondente ao usuário atual do aplicativo para [clube].
  UsuarioClube get usuarioApp => clube.getUsuario(UserApp.instance.id!)!;

  /// Abre a página para editar as informações [clube].
  void editar(BuildContext context) {
    Navigation.showPage(context, RoutePage.editarClube, arguments: clube);
  }

  /// Sair do [clube].
  Future<bool> sair() async {
    if (usuarioApp.proprietario) return false;
    return repository.sairClube(clube);
  }

  /// Define [usuario] como administrador de [clube].
  Future<bool> promoverAdmin(UsuarioClube usuario) async {
    if (!usuarioApp.proprietario) return false;
    if (usuario.administrador) return true;
    return repository.atualizarPermissaoClube(
      clube: clube,
      usuario: usuario,
      permissao: PermissoesClube.administrador,
    );
  }

  /// Remove [usuarioApp] da lista de administradores de [clube].
  Future<bool> sairAdmin() async {
    if (usuarioApp.membro) return true;
    if (!usuarioApp.administrador) return false;
    return repository.atualizarPermissaoClube(
      clube: clube,
      usuario: usuarioApp,
      permissao: PermissoesClube.membro,
    );
  }

  /// Remove [usuario] da lista de administradores de [clube].
  Future<bool> removerAdmin(UsuarioClube usuario) async {
    if (!usuarioApp.proprietario) return false;
    return repository.atualizarPermissaoClube(
      clube: clube,
      usuario: usuario,
      permissao: PermissoesClube.membro,
    );
  }

  /// Remove [usuario] de [clube].
  Future<bool> remover(UsuarioClube usuario) async {
    if (usuarioApp.proprietario || usuarioApp.administrador) {
      return repository.removerDoClube(clube, usuario);
    }
    return false;
  }
}

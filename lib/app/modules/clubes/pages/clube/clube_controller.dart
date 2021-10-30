import 'package:flutter/widgets.dart';

import '../../../perfil/models/userapp.dart';
import '../../shared/models/clube.dart';
import '../../shared/models/usuario_clube.dart';
import '../../shared/utils/mixin_controllers.dart';

/// Uma enumeração para os itens do menu de opções dos clubes.
enum OpcoesUsuarioClube {
  promoverAdmin,
  removerAdmin,
  sairAdmin,
  remover,
  sair,
}

class ClubeController extends IClubeController
    with IClubeControllerMixinShowPageEditar, IClubeControllerMixinSair {
  ClubeController(this.clube);

  final Clube clube;

  /// O [UsuarioClube] correspondente ao usuário atual do aplicativo para [clube].
  UsuarioClube get usuarioApp => clube.getUsuario(UserApp.instance.id!)!;

  @override
  void editar(BuildContext context, [Clube? clube]) {
    super.editar(context, clube ?? this.clube);
  }

  @override
  Future<bool> sair([Clube? clube]) async {
    return super.sair(clube ?? this.clube);
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

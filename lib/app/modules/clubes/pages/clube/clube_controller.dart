import 'package:clubedematematica/app/modules/clubes/shared/models/clube.dart';
import 'package:clubedematematica/app/modules/clubes/shared/models/usuario_clube.dart';
import 'package:clubedematematica/app/modules/perfil/models/userapp.dart';

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

  /// O [UsuarioClube] correspondente ao usuário atual do aplicativo para [clube].
  UsuarioClube get usuarioApp => clube.getUsuario(UserApp.instance.id!)!;
}

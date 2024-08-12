import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../perfil/models/userapp.dart';
import '../../../shared/models/clube.dart';
import '../../../shared/models/usuario_clube.dart';
import '../../../shared/utils/tema_clube.dart';
import '../clube_controller.dart';
import 'categoria.dart';
import 'usuario_clube_botao_opcoes.dart';

/// A subpágina exibida na aba "Pessoas" da página do [clube].
class PessoasPage extends StatelessWidget {
  const PessoasPage({super.key});

  TemaClube get temaClube => Modular.get<TemaClube>();

  ClubeController get controle => Modular.get<ClubeController>();

  Clube get clube => controle.clube;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: temaClube.primaria,
      color: temaClube.sobrePrimaria,
      onRefresh: controle.sincronizarAtividades,
      child: Observer(builder: (context) {
        final administradores = clube.administradores.toList();
        return ListView(
          children: [
            _CategoriaUsuariosClube(
              categoria: 'Mentor',
              clube: clube,
              usuarios: [
                if (clube.proprietario != null) clube.proprietario!,
              ],
            ),
            if (administradores.isNotEmpty)
              _CategoriaUsuariosClube(
                categoria: 'Administradores',
                clube: clube,
                usuarios: administradores,
              ),
            _CategoriaUsuariosClube(
              categoria: 'Alunos',
              clube: clube,
              usuarios: clube.membros.toList(),
            ),
          ],
        );
      }),
    );
  }
}

/// O widget para exibir uma categoria de usuários do clube.
class _CategoriaUsuariosClube extends Categoria {
  final List<UsuarioClube> usuarios;
  final Clube clube;

  _CategoriaUsuariosClube({
    required super.categoria,
    required this.clube,
    this.usuarios = const [],
  }) : super(
          itens: List.generate(
            usuarios.length,
            (index) {
              return Observer(builder: (context) {
                final usuario = usuarios[index];
                return ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                  title: _titulo(usuario, clube),
                  subtitle: _subtitulo(usuario, clube),
                  leading: CircleAvatar(
                    backgroundColor: _tema.primaria.withOpacity(0.3),
                    child: Icon(
                      Icons.person,
                      color: _tema.enfaseSobreSuperficie,
                    ),
                  ),
                  trailing: usuario.proprietario
                      ? null
                      : UsuarioClubeBotaoOpcoes(usuario: usuario),
                );
              });
            },
          ),
        );

  static TemaClube get _tema => Modular.get<TemaClube>();

  static Widget _titulo(UsuarioClube usuario, Clube clube) {
    String? titulo = usuario.nome;
    if (titulo == null && UserApp.instance.id != null) {
      final usuarioApp = clube.getUsuario(UserApp.instance.id!);
      if (usuarioApp != null && usuarioApp.proprietario) {
        titulo = usuario.email;
      }
    }
    return Text(titulo ?? 'Sem identificação');
  }

  static Widget? _subtitulo(UsuarioClube usuario, Clube clube) {
    String? subtitulo;
    if (UserApp.instance.id != null) {
      final usuarioApp = clube.getUsuario(UserApp.instance.id!);
      if (usuarioApp != null && usuarioApp.proprietario) {
        subtitulo = usuario.email;
      }
    }
    return subtitulo == null ? null : Text(subtitulo);
  }
}

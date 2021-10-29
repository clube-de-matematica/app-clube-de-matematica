import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../shared/models/usuario_clube.dart';
import '../clube_page.dart';
import 'usuario_clube_botao_opcoes.dart';

/// A subpágina exibida na aba "Pessoas" da página do [clube].
class PessoasPage extends StatelessWidget {
  PessoasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clube = ClubePage.of(context).controller.clube;
    return Observer(builder: (context) {
      final administradores = clube.administradores;
      return ListView(
        children: [
          _CategoriaUsuariosClube(
            categoria: 'Mentor',
            cor: clube.capa,
            usuarios: [clube.proprietario],
          ),
          if (administradores.isNotEmpty)
            _CategoriaUsuariosClube(
              categoria: 'Administradores',
              cor: clube.capa,
              usuarios: administradores,
            ),
          _CategoriaUsuariosClube(
            categoria: 'Alunos',
            cor: clube.capa,
            usuarios: clube.membros,
          ),
        ],
      );
    });
  }
}

/// O widget para exibir uma categoria de usuários do clube.
class _CategoriaUsuariosClube extends StatelessWidget {
  final String categoria;
  final Color cor;
  final List<UsuarioClube> usuarios;

  const _CategoriaUsuariosClube({
    Key? key,
    required this.categoria,
    required this.cor,
    this.usuarios = const [],
  }) : super(key: key);

  Color get corTexto {
    final brightness = ThemeData.estimateBrightnessForColor(this.cor);
    return brightness == Brightness.light ? Colors.black : this.cor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              categoria,
              style: TextStyle(
                color: corTexto,
                fontSize: 32.0,
              ),
            ),
            subtitle: Divider(
              color: corTexto,
              height: 24.0,
              thickness: 2.0,
            ),
          ),
          for (final usuario in _buildUsuarios()) usuario,
        ],
      ),
    );
  }

  List<Widget> _buildUsuarios() {
    return List.generate(
      usuarios.length,
      (index) {
        return Observer(builder: (_) {
          final usuario = usuarios[index];
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            title: Text(
                usuario.nome ?? usuario.email ?? usuario.id.toString()), //TODO
            leading: CircleAvatar(
              child: Icon(
                Icons.person,
                color: corTexto,
              ),
              backgroundColor: cor.withOpacity(0.3),
            ),
            trailing: usuario.proprietario
                ? null
                : UsuarioClubeBotaoOpcoes(
                    usuario: usuario,
                  ),
          );
        });
      },
    );
  }
}

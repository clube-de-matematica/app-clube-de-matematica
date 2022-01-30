import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/models/usuario_clube.dart';
import '../../../shared/utils/tema_clube.dart';
import '../clube_controller.dart';
import 'categoria.dart';
import 'usuario_clube_botao_opcoes.dart';

/// A subpágina exibida na aba "Pessoas" da página do [clube].
class PessoasPage extends StatelessWidget {
  PessoasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clube = Modular.get<ClubeController>().clube;
    return Observer(builder: (context) {
      final administradores = clube.administradores.toList();
      return ListView(
        children: [
          _CategoriaUsuariosClube(
            categoria: 'Mentor',
            cor: clube.capa,
            usuarios: [if (clube.proprietario != null) clube.proprietario!],
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
            usuarios: clube.membros.toList(),
          ),
        ],
      );
    });
  }
}

/// O widget para exibir uma categoria de usuários do clube.
class _CategoriaUsuariosClube extends Categoria {
  final String categoria;
  final Color cor;
  final List<UsuarioClube> usuarios;

  _CategoriaUsuariosClube({
    Key? key,
    required this.categoria,
    required this.cor,
    this.usuarios = const [],
  }) : super(
          key: key,
          categoria: categoria,
          itens: List.generate(
            usuarios.length,
            (index) {
              return Observer(builder: (context) {
                final usuario = usuarios[index];
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                  title: Text(usuario.nome ??
                      usuario.email ??
                      usuario.id.toString()), //TODO
                  leading: CircleAvatar(
                    child: Icon(
                      Icons.person,
                      color: Modular.get<TemaClube>().textoEnfase,
                    ),
                    backgroundColor: cor.withOpacity(0.3),
                  ),
                  trailing: usuario.proprietario
                      ? null
                      : UsuarioClubeBotaoOpcoes(usuario: usuario),
                );
              });
            },
          ),
        );
}

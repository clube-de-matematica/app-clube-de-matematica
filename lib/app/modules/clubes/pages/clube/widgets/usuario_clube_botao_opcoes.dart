import 'package:flutter/material.dart';

import '../../../shared/models/usuario_clube.dart';
import '../clube_controller.dart';

/// O botão para o menu de opções do usuário do clube.
class UsuarioClubeBotaoOpcoes extends StatelessWidget {
  const UsuarioClubeBotaoOpcoes({
    Key? key,
    required this.usuarioApp,
    required this.usuario,
  }) : super(key: key);
  final UsuarioClube usuarioApp;
  final UsuarioClube usuario;

  @override
  Widget build(BuildContext context) {
    assert(usuarioApp.idClube == usuario.idClube);
    if (usuarioApp.idClube != usuario.idClube) return const SizedBox();
    // Não apresintar as opções quando o usuário for proprietário do clube.
    if (usuario.proprietario) return const SizedBox();

    return PopupMenuButton<OpcoesUsuarioClube>(
      child: Icon(Icons.more_vert),
      itemBuilder: (context) {
        final nome = usuario.nome ?? usuario.email ?? '';
        final itens = <PopupMenuEntry<OpcoesUsuarioClube>>[];
        final itemSairClube =
            _buildItem(OpcoesUsuarioClube.sair, 'Sair do clube');

        if (usuarioApp.proprietario) {
          itens.addAll([
            if (usuario.administrador)
              _buildItem(
                OpcoesUsuarioClube.removerAdmin,
                'Remover $nome da lista de admins'.trim(),
              ),
            if (usuario.membro)
              _buildItem(
                OpcoesUsuarioClube.promoverAdmin,
                'Promover $nome a admin do clube'.trim(),
              ),
            if (!usuario.proprietario)
              _buildItem(
                OpcoesUsuarioClube.remover,
                'Remover $nome'.trim(),
              ),
          ]);
        } else if (usuarioApp.administrador) {
          itens.addAll([
            if (usuario.id == usuarioApp.id)
              _buildItem(
                OpcoesUsuarioClube.sairAdmin,
                'Sair da lista de admins',
              ),
            if (usuario.id == usuarioApp.id) itemSairClube,
            if (usuario.membro)
              _buildItem(
                OpcoesUsuarioClube.remover,
                'Remover $nome'.trim(),
              ),
          ]);
        } else if (usuarioApp.membro) {
          if (usuario.id == usuarioApp.id) itens.add(itemSairClube);
        }
        return itens;
      },
      onSelected: (opcao) async {
        switch (opcao) {
          //TODO
          case OpcoesUsuarioClube.promoverAdmin:
            break;
          case OpcoesUsuarioClube.removerAdmin:
            break;
          case OpcoesUsuarioClube.sairAdmin:
            break;
          case OpcoesUsuarioClube.remover:
            break;
          case OpcoesUsuarioClube.sair:
            /* final sair =
                await BottomSheetSairClube(clube).showModal<bool>(context);
            if (sair ?? false) await controller.sair(clube); */
            break;
        }
      },
    );
  }

  PopupMenuItem<OpcoesUsuarioClube> _buildItem(
    OpcoesUsuarioClube opcao,
    String titulo,
  ) {
    return PopupMenuItem<OpcoesUsuarioClube>(
      value: opcao,
      child: Text(titulo),
    );
  }
}

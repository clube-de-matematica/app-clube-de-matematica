import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../shared/widgets/appBottomSheet.dart';
import '../../../shared/models/usuario_clube.dart';
import '../clube_controller.dart';

/// O botão para o menu de opções do usuário do clube.
class UsuarioClubeBotaoOpcoes extends StatelessWidget {
  UsuarioClubeBotaoOpcoes({
    Key? key,
    required this.usuario,
  }) : super(key: key);
  final UsuarioClube usuario;
  late final BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final controller = Modular.get<ClubeController>();
    final usuarioApp = controller.usuarioApp;
    assert(usuarioApp.idClube == usuario.idClube);
    if (usuarioApp.idClube != usuario.idClube) return const SizedBox();
    // Não apresintar as opções quando o usuário for proprietário do clube.
    if (usuario.proprietario) return const SizedBox();

    final nome = usuario.nome ?? usuario.email ?? '';
    final textoSair = 'Sair do clube';
    final textoRemoverAdmin =
        'Remover $nome da lista de admins'.replaceAll('  ', ' ');
    final textoPromoverAdmin =
        'Promover $nome a admin do clube'.replaceAll('  ', ' ');
    final textoRemover = 'Remover $nome'.trim();
    final textoSairAdmin = 'Sair da lista de admins';

    final itens = () {
      final itens = <PopupMenuEntry<OpcoesUsuarioClube>>[];
      final itemSairClube = _buildItem(OpcoesUsuarioClube.sair, textoSair);

      if (usuarioApp.proprietario) {
        itens.addAll([
          if (usuario.administrador)
            _buildItem(OpcoesUsuarioClube.removerAdmin, textoRemoverAdmin),
          if (usuario.membro)
            _buildItem(OpcoesUsuarioClube.promoverAdmin, textoPromoverAdmin),
          if (!usuario.proprietario)
            _buildItem(OpcoesUsuarioClube.remover, textoRemover),
        ]);
      } else if (usuarioApp.administrador) {
        itens.addAll([
          if (usuario.id == usuarioApp.id)
            _buildItem(OpcoesUsuarioClube.sairAdmin, textoSairAdmin),
          if (usuario.id == usuarioApp.id) itemSairClube,
          if (usuario.membro)
            _buildItem(OpcoesUsuarioClube.remover, textoRemover),
        ]);
      } else if (usuarioApp.membro) {
        if (usuario.id == usuarioApp.id) itens.add(itemSairClube);
      }
      return itens;
    }();

    construirBotao() {
      return PopupMenuButton<OpcoesUsuarioClube>(
        child: Icon(Icons.more_vert),
        itemBuilder: (_) => itens,
        onSelected: (opcao) async {
          switch (opcao) {
            case OpcoesUsuarioClube.promoverAdmin:
              await onSelected(
                '$textoPromoverAdmin?',
                () => controller.promoverAdmin(usuario),
              );
              break;
            case OpcoesUsuarioClube.removerAdmin:
              await onSelected(
                '$textoRemoverAdmin?',
                () => controller.removerAdmin(usuario),
              );
              break;
            case OpcoesUsuarioClube.sairAdmin:
              await onSelected('$textoSairAdmin?', controller.sairAdmin);
              break;
            case OpcoesUsuarioClube.remover:
              await onSelected(
                '$textoRemover?',
                () => controller.remover(usuario),
              );
              break;
            case OpcoesUsuarioClube.sair:
              await onSelected(
                '$textoSair?',
                () async {
                  final sair = await controller.sair();
                  if (sair) Navigator.pop(context);
                  return sair;
                },
              );
              break;
          }
        },
      );
    }

    return itens.isEmpty ? const SizedBox() : construirBotao();
  }

  Future<void> onSelected(
    String mensagem,
    Future<bool> Function() acao,
  ) async {
    final confirmar = await BottomSheetCancelarConfirmar(
      message: mensagem,
    ).showModal<bool>(context);
    if (confirmar ?? false) {
      final futuro = acao();
      await BottomSheetCarregando(future: futuro).showModal(context);
      if (!(await futuro)) BottomSheetErro('').showModal(context);
    }
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

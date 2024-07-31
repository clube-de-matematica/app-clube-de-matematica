import 'package:flutter/material.dart';

import '../../../perfil/models/userapp.dart';
import '../../pages/home/home_clubes_controller.dart';
import '../../pages/home/widgets/bottom_sheets.dart';
import '../models/clube.dart';

/// O botão para o menu de opções do clube.
class ClubeOptionsButton extends StatelessWidget {
  const ClubeOptionsButton({
    Key? key,
    required this.clube,
    this.iconColor,
    required this.onSair,
    required this.onEditar,
    required this.onCompartilharCodigo,
    required this.onExcluir,
  }) : super(key: key);
  final Clube clube;
  final Color? iconColor;
  final VoidCallback onSair;
  final VoidCallback onEditar;
  final VoidCallback onCompartilharCodigo;
  final VoidCallback onExcluir;

  /// ID do usuário do aplicativo.
  // TODO: Erro ao tentar trocar a conta do usuário. Exception has occurred. _CastError (Null check operator used on a null value)
  int get idUsuarioApp => UserApp.instance.id!;

  @override
  Widget build(BuildContext context) {
    final permissao = clube.permissao(idUsuarioApp);
    final proprietario = permissao == PermissoesClube.proprietario;
    final administrador = permissao == PermissoesClube.administrador;

    return PopupMenuButton<OpcoesClube>(
      child: IconButton(
        padding: const EdgeInsets.all(0),
        onPressed: null,
        icon: Icon(
          Icons.more_vert,
          color: iconColor, //Necessário para que não pareça desabilitado, pois "onPressed" é "null"
        ),
      ),
      itemBuilder: (context) => [
        if (proprietario || administrador)
          PopupMenuItem<OpcoesClube>(
            value: OpcoesClube.compartilharCodigo,
            child: Text(OpcoesClube.compartilharCodigo.textButton),
          ),
        if (proprietario)
          PopupMenuItem<OpcoesClube>(
            value: OpcoesClube.editar,
            child: Text(OpcoesClube.editar.textButton),
          ),
        if (!proprietario)
          PopupMenuItem<OpcoesClube>(
            value: OpcoesClube.sair,
            child: Text(OpcoesClube.sair.textButton),
          ),
        if (proprietario)
          PopupMenuItem<OpcoesClube>(
            value: OpcoesClube.excluir,
            child: Text(OpcoesClube.excluir.textButton),
          ),
      ],
      onSelected: (opcao) async {
        switch (opcao) {
          case OpcoesClube.compartilharCodigo:
            await BottomSheetCodigoClube(clube).showModal(context);
            onCompartilharCodigo();
            break;
          case OpcoesClube.editar:
            onEditar();
            break;
          case OpcoesClube.sair:
            final sair =
                await BottomSheetSairClube(clube).showModal<bool>(context);
            if (sair ?? false) onSair();
            break;
          case OpcoesClube.excluir:
            final excluir =
                await BottomSheetExcluirClube(clube).showModal<bool>(context);
            if (excluir ?? false) onExcluir();
            break;
        }
      },
    );
  }
}

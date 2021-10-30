import 'package:flutter/material.dart';

import '../../../../shared/theme/appTheme.dart';
import '../../../perfil/models/userapp.dart';
import '../../pages/home/home_clubes_controller.dart';
import '../../pages/home/widgets/bottom_sheets.dart';
import '../models/clube.dart';

/// O botão para o menu de opções do clube.
class ClubeOptionsButton extends StatelessWidget {
  const ClubeOptionsButton({
    Key? key,
    required this.clube,
    this.textStyle,
    required this.onSair,
    required this.onEditar,
    required this.onCompartilharCodigo,
  }) : super(key: key);
  final Clube clube;
  final TextStyle? textStyle;
  final VoidCallback onSair;
  final VoidCallback onEditar;
  final VoidCallback onCompartilharCodigo;

  /// ID do usuário do aplicativo.
  int get idUsuarioApp => UserApp.instance.id!;

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ??
        TextStyle(
          color: AppTheme.instance.temaClaro.colorScheme.onPrimary,
          fontSize: AppTheme.escala * 26,
          fontWeight: FontWeight.w400,
        );
    final permissao = clube.permissao(idUsuarioApp);
    final proprietario = permissao == PermissoesClube.proprietario;
    final administrador = permissao == PermissoesClube.administrador;

    return PopupMenuButton<OpcoesClube>(
      child: Icon(
        Icons.more_vert,
        size: textStyle.fontSize,
        color: textStyle.color,
      ),
      itemBuilder: (context) => [
        if (proprietario || administrador)
          PopupMenuItem<OpcoesClube>(
            value: OpcoesClube.compartilharCodigo,
            child: Text(OpcoesClube.compartilharCodigo.textButton),
          ),
        if (proprietario || administrador)
          PopupMenuItem<OpcoesClube>(
            value: OpcoesClube.editar,
            child: Text(OpcoesClube.editar.textButton),
          ),
        if (!proprietario)
          PopupMenuItem<OpcoesClube>(
            value: OpcoesClube.sair,
            child: Text(OpcoesClube.sair.textButton),
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
        }
      },
    );
  }
}

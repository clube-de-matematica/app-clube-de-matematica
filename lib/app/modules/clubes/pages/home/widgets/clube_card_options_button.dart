import 'package:flutter/material.dart';

import '../../../../../shared/theme/appTheme.dart';
import '../../../shared/models/clube.dart';
import '../home_clubes_controller.dart';
import 'bottom_sheets.dart';

/// O botão para o menu de opções do clube.
class ClubeCardOptionsButton extends StatelessWidget {
  const ClubeCardOptionsButton({
    Key? key,
    required this.clube,
    required this.userId,
    this.textStyle,
    required this.controller,
  }) : super(key: key);
  final Clube clube;
  final int userId;
  final TextStyle? textStyle;
  final HomeClubesController controller;

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ??
        TextStyle(
          color: AppTheme.instance.temaClaro.colorScheme.onPrimary,
          fontSize: AppTheme.escala * 26,
          fontWeight: FontWeight.w400,
        );
    final permissao = clube.permissao(userId);
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
        PopupMenuItem<OpcoesClube>(
          value: OpcoesClube.sair,
          child: Text(OpcoesClube.sair.textButton),
        ),
      ],
      onSelected: (opcao) async {
        switch (opcao) {
          case OpcoesClube.compartilharCodigo:
            await BottomSheetCodigoClube(clube).showModal(context);
            controller.compartilharCodigo(clube);
            break;
          case OpcoesClube.editar:
            controller.editar(context, clube);
            break;
          case OpcoesClube.sair:
            final sair =
                await BottomSheetSairClube(clube).showModal<bool>(context);
            if (sair ?? false) await controller.sair(clube);
            break;
        }
      },
    );
  }
}

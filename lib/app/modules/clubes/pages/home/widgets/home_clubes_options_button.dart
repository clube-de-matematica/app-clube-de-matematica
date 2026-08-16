import 'package:flutter/material.dart';

import '../../../../../shared/theme/app_theme.dart';
import '../../../../../shared/widgets/app_bottom_sheet.dart';
import '../home_clubes_controller.dart';

/// O botão para o menu de opções do clube.
class HomeClubesOptionsButton extends StatelessWidget {
  const HomeClubesOptionsButton({
    super.key,
    this.textStyle,
    required this.controller,
  });
  final TextStyle? textStyle;
  final HomeClubesController controller;

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ??
        TextStyle(
          color: AppTheme.instance.light.colorScheme.onPrimary,
          fontSize: AppTheme.escala * 26,
          fontWeight: FontWeight.w400,
        );

    return PopupMenuButton<OpcoesHomeClubePage>(
      child: Icon(
        Icons.more_vert,
        size: textStyle.fontSize,
        color: textStyle.color,
      ),
      itemBuilder: (context) => [
        PopupMenuItem<OpcoesHomeClubePage>(
          value: OpcoesHomeClubePage.atualizar,
          child: Text(OpcoesHomeClubePage.atualizar.textButton),
        ),
      ],
      onSelected: (opcao) async {
        switch (opcao) {
          case OpcoesHomeClubePage.atualizar:
            await BottomSheetCarregando(
              future: controller.sincronizarClubes(),
            ).showModal(context);
            break;
        }
      },
    );
  }
}

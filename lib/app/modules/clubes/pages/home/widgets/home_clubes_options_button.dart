import 'package:flutter/material.dart';

import '../../../../../shared/theme/appTheme.dart';
import '../../../../../shared/widgets/appBottomSheet.dart';
import '../home_clubes_controller.dart';

/// O botão para o menu de opções do clube.
class HomeClubesOptionsButton extends StatelessWidget {
  const HomeClubesOptionsButton({
    Key? key,
    this.textStyle,
    required this.controller,
  }) : super(key: key);
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

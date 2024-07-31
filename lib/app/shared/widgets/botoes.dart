import 'package:flutter/material.dart';

import '../theme/appTheme.dart';

/// Botão com a cor primária do tema.
class BotaoPrimario extends FilledButton {
  BotaoPrimario({
    Key? key,
    required String label,
    VoidCallback? onPressed,
  }) : super(
          key: key,
          /* style: ElevatedButton.styleFrom(
            disabledForegroundColor: Color(0xff003d33),
          ), */
          child: Text(label),
          onPressed: onPressed,
        );
}

class AppTextButton extends TextButton {
  /// Um [TextButton] com base na cor primária do tema do aplicativo.
  /// Se [style] não for `null`, [primary] será ignorado.
  AppTextButton({
    Key? key,
    bool primary = true,
    ButtonStyle? style,
    required Widget child,
    required VoidCallback? onPressed,
  }) : super(
          key: key,
          style: style ??
              TextButton.styleFrom(
                foregroundColor: primary
                    ? AppTheme.instance.light.colorScheme.primary
                    : AppTheme.instance.light.textTheme.labelLarge?.color,
              ),
          onPressed: onPressed,
          child: child,
        );
}

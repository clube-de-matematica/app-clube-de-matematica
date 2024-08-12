import 'package:flutter/material.dart';

import '../theme/appTheme.dart';

/// Botão com a cor primária do tema.
class BotaoPrimario extends FilledButton {
  BotaoPrimario({
    super.key,
    required String label,
    super.onPressed,
  }) : super(
          child: Text(label),
        );
}

class AppTextButton extends TextButton {
  /// Um [TextButton] com base na cor primária do tema do aplicativo.
  /// Se [style] não for `null`, [primary] será ignorado.
  AppTextButton({
    super.key,
    bool primary = true,
    ButtonStyle? style,
    required super.child,
    required super.onPressed,
  }) : super(
          style: style ??
              TextButton.styleFrom(
                foregroundColor: primary
                    ? AppTheme.instance.light.colorScheme.primary
                    : AppTheme.instance.light.textTheme.labelLarge?.color,
              ),
        );
}

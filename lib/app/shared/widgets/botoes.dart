import 'package:flutter/material.dart';

import '../theme/appTheme.dart';

/// Botão com a cor primária do tema.
class BotaoPrimario extends ElevatedButton {
  BotaoPrimario({
    Key? key,
    required String label,
    VoidCallback? onPressed,
  }) : super(
          key: key,
          style: ElevatedButton.styleFrom(
            onSurface: Color(0xff003d33),
          ),
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
                primary: primary
                    ? AppTheme.instance.temaClaro.colorScheme.primary
                    : AppTheme.instance.temaClaro.textTheme.button?.color,
              ),
          onPressed: onPressed,
          child: child,
        );
}

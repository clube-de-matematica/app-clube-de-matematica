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

class TextButtonPriario extends TextButton {
  /// Um [TextButton] com base na cor primária do tema do aplicativo.
  TextButtonPriario({
    Key? key,
    ButtonStyle? style,
    required Widget child,
    required VoidCallback? onPressed,
  }) : super(
          key: key,
          style: style ??
              TextButton.styleFrom(
                primary: AppTheme.instance.temaClaro.colorScheme.primary,
              ),
          onPressed: onPressed,
          child: child,
        );
}

class TextButtonSecundario extends TextButton {
  /// Um [TextButton] com base na cor do estilo de texto do tema do aplicativo.
  TextButtonSecundario({
    Key? key,
    ButtonStyle? style,
    required Widget child,
    required VoidCallback? onPressed,
  }) : super(
          key: key,
          style: style ??
              TextButton.styleFrom(
                  primary: AppTheme.instance.temaClaro.textTheme.button?.color),
          onPressed: onPressed,
          child: child,
        );
}

import 'package:flutter/material.dart';

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

import 'dart:math';

import 'package:clubedematematica/app/shared/theme/appTheme.dart';
import 'package:flutter/material.dart';

/// Uma cor aleatória a partir de [Colors.primaries], excluindo-se a cor base do tema e aquelas 
/// que não são recomendadas para textos na cor branca.
class RandomColor extends Color {
  RandomColor() : super(getColor().value);

  /// Retorna uma cor aleatória a partir de [Colors.primaries].
  static Color getColor() {
    final colors = Colors.primaries
        .where(
          // Excluir a cor base do tema e as que não são recomendadas para textos na cor branca.
          (cor) => ![AppTheme.primarySwatch, Colors.yellow, Colors.amber, Colors.orange].contains(cor),
        )
        .toList();
    final random = Random();
    final index = random.nextInt(colors.length);
    return colors[index].shade700;
  }
}

import 'package:flutter/material.dart';

/// Cores usadas no layout do clube.
class TemaClube {
  TemaClube(this.primaria);

  final Color primaria;

  Brightness get _brightness => ThemeData.estimateBrightnessForColor(primaria);

  Color get textoPrimaria {
    return _brightness == Brightness.light ? Colors.black : Colors.white;
  }

  Color get texto {
    return _brightness == Brightness.light ? Colors.black : primaria;
  }
}
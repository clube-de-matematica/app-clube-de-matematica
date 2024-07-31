import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../models/clube.dart';

part 'tema_clube.g.dart';

/// Cores usadas no layout do clube.
class TemaClube = _TemaClubeBase with _$TemaClube;

abstract class _TemaClubeBase with Store {
  _TemaClubeBase(Clube clube) : _clube = clube;

  final Clube _clube;

  @computed
  ThemeData get tema {
    final base = _clube.capa;
    final _colors = ColorScheme.fromSeed(
      seedColor: base,
      brightness: Brightness.light, //ThemeData.estimateBrightnessForColor(base),
    );
    
    return ThemeData.from(
      colorScheme: _colors,
    ).copyWith(
      appBarTheme: AppBarTheme(
      elevation: 0,
      foregroundColor: _colors.onPrimary,
      backgroundColor: _colors.primary,
    ),
    );
  }

  @computed
  Brightness get brilho => tema.colorScheme.brightness;

  @computed
  Color get primaria => tema.colorScheme.primary;

  @computed
  Color get superficie => tema.colorScheme.surface;

  @computed
  Color get fundo => tema.colorScheme.background;

  @computed
  Color get sobrePrimaria => tema.colorScheme.onPrimary;

  @computed
  Color get sobreSuperficie => tema.colorScheme.onSurface;

  @computed
  Color get sobreFundo => tema.colorScheme.onBackground;

  @computed
  Color get enfaseSobreSuperficie {
    final brilho = ThemeData.estimateBrightnessForColor(_clube.capa);
    return brilho == Brightness.light ? sobreSuperficie : primaria;
  }
}

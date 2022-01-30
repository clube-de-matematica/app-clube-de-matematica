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
  Color get primaria => _clube.capa;

  Brightness get _brightness => ThemeData.estimateBrightnessForColor(primaria);

  @computed
  Color get textoPrimaria {
    return _brightness == Brightness.light ? Colors.black : Colors.white;
  }

  @computed
  Color get textoEnfase {
    return _brightness == Brightness.light ? Colors.black : primaria;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tema_clube.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TemaClube on _TemaClubeBase, Store {
  Computed<Color>? _$primariaComputed;

  @override
  Color get primaria =>
      (_$primariaComputed ??= Computed<Color>(() => super.primaria,
              name: '_TemaClubeBase.primaria'))
          .value;
  Computed<Color>? _$textoPrimariaComputed;

  @override
  Color get textoPrimaria =>
      (_$textoPrimariaComputed ??= Computed<Color>(() => super.textoPrimaria,
              name: '_TemaClubeBase.textoPrimaria'))
          .value;
  Computed<Color>? _$textoEnfaseComputed;

  @override
  Color get textoEnfase =>
      (_$textoEnfaseComputed ??= Computed<Color>(() => super.textoEnfase,
              name: '_TemaClubeBase.textoEnfase'))
          .value;

  @override
  String toString() {
    return '''
primaria: ${primaria},
textoPrimaria: ${textoPrimaria},
textoEnfase: ${textoEnfase}
    ''';
  }
}

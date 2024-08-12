// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tema_clube.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TemaClube on TemaClubeBase, Store {
  Computed<ThemeData>? _$temaComputed;

  @override
  ThemeData get tema => (_$temaComputed ??=
          Computed<ThemeData>(() => super.tema, name: 'TemaClubeBase.tema'))
      .value;
  Computed<Brightness>? _$brilhoComputed;

  @override
  Brightness get brilho =>
      (_$brilhoComputed ??= Computed<Brightness>(() => super.brilho,
              name: 'TemaClubeBase.brilho'))
          .value;
  Computed<Color>? _$primariaComputed;

  @override
  Color get primaria => (_$primariaComputed ??=
          Computed<Color>(() => super.primaria, name: 'TemaClubeBase.primaria'))
      .value;
  Computed<Color>? _$superficieComputed;

  @override
  Color get superficie =>
      (_$superficieComputed ??= Computed<Color>(() => super.superficie,
              name: 'TemaClubeBase.superficie'))
          .value;
  Computed<Color>? _$sobrePrimariaComputed;

  @override
  Color get sobrePrimaria =>
      (_$sobrePrimariaComputed ??= Computed<Color>(() => super.sobrePrimaria,
              name: 'TemaClubeBase.sobrePrimaria'))
          .value;
  Computed<Color>? _$sobreSuperficieComputed;

  @override
  Color get sobreSuperficie => (_$sobreSuperficieComputed ??= Computed<Color>(
          () => super.sobreSuperficie,
          name: 'TemaClubeBase.sobreSuperficie'))
      .value;
  Computed<Color>? _$enfaseSobreSuperficieComputed;

  @override
  Color get enfaseSobreSuperficie => (_$enfaseSobreSuperficieComputed ??=
          Computed<Color>(() => super.enfaseSobreSuperficie,
              name: 'TemaClubeBase.enfaseSobreSuperficie'))
      .value;

  @override
  String toString() {
    return '''
tema: ${tema},
brilho: ${brilho},
primaria: ${primaria},
superficie: ${superficie},
sobrePrimaria: ${sobrePrimaria},
sobreSuperficie: ${sobreSuperficie},
enfaseSobreSuperficie: ${enfaseSobreSuperficie}
    ''';
  }
}

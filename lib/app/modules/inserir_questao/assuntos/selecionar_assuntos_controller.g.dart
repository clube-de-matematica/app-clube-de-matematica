// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selecionar_assuntos_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SelecionarAssuntosController
    on _SelecionarAssuntosControllerBase, Store {
  Computed<List<Assunto>>? _$_assuntosComputed;

  @override
  List<Assunto> get _assuntos =>
      (_$_assuntosComputed ??= Computed<List<Assunto>>(() => super._assuntos,
              name: '_SelecionarAssuntosControllerBase._assuntos'))
          .value;
  Computed<List<ArvoreAssuntos>>? _$arvoresComputed;

  @override
  List<ArvoreAssuntos> get arvores =>
      (_$arvoresComputed ??= Computed<List<ArvoreAssuntos>>(() => super.arvores,
              name: '_SelecionarAssuntosControllerBase.arvores'))
          .value;

  @override
  String toString() {
    return '''
arvores: ${arvores}
    ''';
  }
}

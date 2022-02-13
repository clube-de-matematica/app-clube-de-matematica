// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conectividade.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Conectividade on _ConectividadeBase, Store {
  final _$_conectadoAtom = Atom(name: '_ConectividadeBase._conectado');

  bool get conectado {
    _$_conectadoAtom.reportRead();
    return super._conectado;
  }

  @override
  bool get _conectado => conectado;

  @override
  set _conectado(bool value) {
    _$_conectadoAtom.reportWrite(value, super._conectado, () {
      super._conectado = value;
    });
  }

  final _$verificarAsyncAction = AsyncAction('_ConectividadeBase.verificar');

  @override
  Future<bool> verificar() {
    return _$verificarAsyncAction.run(() => super.verificar());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resultado_quiz_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ResultadoQuizController on _ResultadoQuizControllerBase, Store {
  Computed<int>? _$totalComputed;

  @override
  int get total => (_$totalComputed ??= Computed<int>(() => super.total,
          name: '_ResultadoQuizControllerBase.total'))
      .value;
  Computed<int>? _$acertosComputed;

  @override
  int get acertos => (_$acertosComputed ??= Computed<int>(() => super.acertos,
          name: '_ResultadoQuizControllerBase.acertos'))
      .value;

  final _$_carregandoAtom =
      Atom(name: '_ResultadoQuizControllerBase._carregando');

  bool get carregando {
    _$_carregandoAtom.reportRead();
    return super._carregando;
  }

  @override
  bool get _carregando => carregando;

  @override
  set _carregando(bool value) {
    _$_carregandoAtom.reportWrite(value, super._carregando, () {
      super._carregando = value;
    });
  }

  final _$carregarAsyncAction =
      AsyncAction('_ResultadoQuizControllerBase.carregar');

  @override
  Future<void> carregar() {
    return _$carregarAsyncAction.run(() => super.carregar());
  }

  @override
  String toString() {
    return '''
total: ${total},
acertos: ${acertos}
    ''';
  }
}

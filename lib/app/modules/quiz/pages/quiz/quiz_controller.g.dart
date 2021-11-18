// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuizController on _QuizControllerBase, Store {
  Computed<List<Questao>>? _$questoesFiltradasComputed;

  @override
  List<Questao> get questoesFiltradas => (_$questoesFiltradasComputed ??=
          Computed<List<Questao>>(() => super.questoesFiltradas,
              name: '_QuizControllerBase.questoesFiltradas'))
      .value;
  Computed<bool>? _$podeConfirmarComputed;

  @override
  bool get podeConfirmar =>
      (_$podeConfirmarComputed ??= Computed<bool>(() => super.podeConfirmar,
              name: '_QuizControllerBase.podeConfirmar'))
          .value;

  final _$alternativaSelecionadaAtom =
      Atom(name: '_QuizControllerBase.alternativaSelecionada');

  @override
  int? get alternativaSelecionada {
    _$alternativaSelecionadaAtom.reportRead();
    return super.alternativaSelecionada;
  }

  @override
  set alternativaSelecionada(int? value) {
    _$alternativaSelecionadaAtom
        .reportWrite(value, super.alternativaSelecionada, () {
      super.alternativaSelecionada = value;
    });
  }

  @override
  String toString() {
    return '''
alternativaSelecionada: ${alternativaSelecionada},
questoesFiltradas: ${questoesFiltradas},
podeConfirmar: ${podeConfirmar}
    ''';
  }
}

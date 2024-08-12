// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selecionar_questoes_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SelecionarQuestoesController
    on SelecionarQuestoesControllerBase, Store {
  Computed<bool>? _$alteradaComputed;

  @override
  bool get alterada =>
      (_$alteradaComputed ??= Computed<bool>(() => super.alterada,
              name: 'SelecionarQuestoesControllerBase.alterada'))
          .value;
  Computed<int>? _$numQuestoesComputed;

  @override
  int get numQuestoes =>
      (_$numQuestoesComputed ??= Computed<int>(() => super.numQuestoes,
              name: 'SelecionarQuestoesControllerBase.numQuestoes'))
          .value;
  Computed<int>? _$numQuestoesSelecionadasComputed;

  @override
  int get numQuestoesSelecionadas => (_$numQuestoesSelecionadasComputed ??=
          Computed<int>(() => super.numQuestoesSelecionadas,
              name: 'SelecionarQuestoesControllerBase.numQuestoesSelecionadas'))
      .value;
  Computed<bool>? _$selecionadaComputed;

  @override
  bool get selecionada =>
      (_$selecionadaComputed ??= Computed<bool>(() => super.selecionada,
              name: 'SelecionarQuestoesControllerBase.selecionada'))
          .value;

  late final _$mostrarSomenteQuestoesSelecionadasAtom = Atom(
      name:
          'SelecionarQuestoesControllerBase.mostrarSomenteQuestoesSelecionadas',
      context: context);

  @override
  bool get mostrarSomenteQuestoesSelecionadas {
    _$mostrarSomenteQuestoesSelecionadasAtom.reportRead();
    return super.mostrarSomenteQuestoesSelecionadas;
  }

  @override
  set mostrarSomenteQuestoesSelecionadas(bool value) {
    _$mostrarSomenteQuestoesSelecionadasAtom
        .reportWrite(value, super.mostrarSomenteQuestoesSelecionadas, () {
      super.mostrarSomenteQuestoesSelecionadas = value;
    });
  }

  @override
  String toString() {
    return '''
mostrarSomenteQuestoesSelecionadas: ${mostrarSomenteQuestoesSelecionadas},
alterada: ${alterada},
numQuestoes: ${numQuestoes},
numQuestoesSelecionadas: ${numQuestoesSelecionadas},
selecionada: ${selecionada}
    ''';
  }
}

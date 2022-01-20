// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selecionar_questoes_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SelecionarQuestoesController
    on _SelecionarQuestoesControllerBase, Store {
  Computed<int>? _$numQuestoesSelecionadasComputed;

  @override
  int get numQuestoesSelecionadas => (_$numQuestoesSelecionadasComputed ??=
          Computed<int>(() => super.numQuestoesSelecionadas,
              name:
                  '_SelecionarQuestoesControllerBase.numQuestoesSelecionadas'))
      .value;
  Computed<bool>? _$selecionadaComputed;

  @override
  bool get selecionada =>
      (_$selecionadaComputed ??= Computed<bool>(() => super.selecionada,
              name: '_SelecionarQuestoesControllerBase.selecionada'))
          .value;

  @override
  String toString() {
    return '''
numQuestoesSelecionadas: ${numQuestoesSelecionadas},
selecionada: ${selecionada}
    ''';
  }
}

mixin _$_Filtros on __FiltrosBase, Store {
  final _$mostrarSomenteQuestoesSelecionadasAtom =
      Atom(name: '__FiltrosBase.mostrarSomenteQuestoesSelecionadas');

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
mostrarSomenteQuestoesSelecionadas: ${mostrarSomenteQuestoesSelecionadas}
    ''';
  }
}

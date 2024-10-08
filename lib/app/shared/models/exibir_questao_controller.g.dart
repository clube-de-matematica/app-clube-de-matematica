// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exibir_questao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExibirQuestaoController on ExibirQuestaoControllerBase, Store {
  Computed<bool>? _$podeAvancarComputed;

  @override
  bool get podeAvancar =>
      (_$podeAvancarComputed ??= Computed<bool>(() => super.podeAvancar,
              name: 'ExibirQuestaoControllerBase.podeAvancar'))
          .value;
  Computed<bool>? _$podeVoltarComputed;

  @override
  bool get podeVoltar =>
      (_$podeVoltarComputed ??= Computed<bool>(() => super.podeVoltar,
              name: 'ExibirQuestaoControllerBase.podeVoltar'))
          .value;

  late final _$_indiceAtom =
      Atom(name: 'ExibirQuestaoControllerBase._indice', context: context);

  int get indice {
    _$_indiceAtom.reportRead();
    return super._indice;
  }

  @override
  int get _indice => indice;

  bool __indiceIsInitialized = false;

  @override
  set _indice(int value) {
    _$_indiceAtom
        .reportWrite(value, __indiceIsInitialized ? super._indice : null, () {
      super._indice = value;
      __indiceIsInitialized = true;
    });
  }

  late final _$numQuestoesAtom =
      Atom(name: 'ExibirQuestaoControllerBase.numQuestoes', context: context);

  @override
  int get numQuestoes {
    _$numQuestoesAtom.reportRead();
    return super.numQuestoes;
  }

  @override
  set numQuestoes(int value) {
    _$numQuestoesAtom.reportWrite(value, super.numQuestoes, () {
      super.numQuestoes = value;
    });
  }

  late final _$_questaoAtualAtom =
      Atom(name: 'ExibirQuestaoControllerBase._questaoAtual', context: context);

  ObservableFuture<Questao?> get questaoAtual {
    _$_questaoAtualAtom.reportRead();
    return super._questaoAtual;
  }

  @override
  ObservableFuture<Questao?> get _questaoAtual => questaoAtual;

  @override
  set _questaoAtual(ObservableFuture<Questao?> value) {
    _$_questaoAtualAtom.reportWrite(value, super._questaoAtual, () {
      super._questaoAtual = value;
    });
  }

  late final _$ExibirQuestaoControllerBaseActionController =
      ActionController(name: 'ExibirQuestaoControllerBase', context: context);

  @override
  @protected
  void definirIndice(int valor, {bool forcar = false}) {
    final _$actionInfo = _$ExibirQuestaoControllerBaseActionController
        .startAction(name: 'ExibirQuestaoControllerBase.definirIndice');
    try {
      return super.definirIndice(valor, forcar: forcar);
    } finally {
      _$ExibirQuestaoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
numQuestoes: ${numQuestoes},
podeAvancar: ${podeAvancar},
podeVoltar: ${podeVoltar}
    ''';
  }
}

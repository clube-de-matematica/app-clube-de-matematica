// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exibir_questao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ExibirQuestaoController on _ExibirQuestaoControllerBase, Store {
  Computed<bool>? _$podeAvancarComputed;

  @override
  bool get podeAvancar =>
      (_$podeAvancarComputed ??= Computed<bool>(() => super.podeAvancar,
              name: '_ExibirQuestaoControllerBase.podeAvancar'))
          .value;
  Computed<bool>? _$podeVoltarComputed;

  @override
  bool get podeVoltar =>
      (_$podeVoltarComputed ??= Computed<bool>(() => super.podeVoltar,
              name: '_ExibirQuestaoControllerBase.podeVoltar'))
          .value;

  final _$_indiceAtom = Atom(name: '_ExibirQuestaoControllerBase._indice');

  int get indice {
    _$_indiceAtom.reportRead();
    return super._indice;
  }

  @override
  int get _indice => indice;

  @override
  set _indice(int value) {
    _$_indiceAtom.reportWrite(value, super._indice, () {
      super._indice = value;
    });
  }

  final _$numQuestoesAtom =
      Atom(name: '_ExibirQuestaoControllerBase.numQuestoes');

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

  final _$_questaoAtualAtom =
      Atom(name: '_ExibirQuestaoControllerBase._questaoAtual');

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

  final _$_ExibirQuestaoControllerBaseActionController =
      ActionController(name: '_ExibirQuestaoControllerBase');

  @override
  void definirIndice(int valor, {bool forcar = false}) {
    final _$actionInfo = _$_ExibirQuestaoControllerBaseActionController
        .startAction(name: '_ExibirQuestaoControllerBase.definirIndice');
    try {
      return super.definirIndice(valor, forcar: forcar);
    } finally {
      _$_ExibirQuestaoControllerBaseActionController.endAction(_$actionInfo);
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

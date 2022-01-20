// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exibir_questao_com_filtro_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ExibirQuestaoComFiltroController
    on _ExibirQuestaoComFiltroControllerBase, Store {
  Computed<ObservableFuture<Questao?>>? _$questaoAtualComputed;

  @override
  ObservableFuture<Questao?> get questaoAtual => (_$questaoAtualComputed ??=
          Computed<ObservableFuture<Questao?>>(() => super.questaoAtual,
              name: '_ExibirQuestaoComFiltroControllerBase.questaoAtual'))
      .value;

  final _$_questaoAtualAtom =
      Atom(name: '_ExibirQuestaoComFiltroControllerBase._questaoAtual');

  @override
  ObservableFuture<Questao?> get _questaoAtual {
    _$_questaoAtualAtom.reportRead();
    return super._questaoAtual;
  }

  @override
  set _questaoAtual(ObservableFuture<Questao?> value) {
    _$_questaoAtualAtom.reportWrite(value, super._questaoAtual, () {
      super._questaoAtual = value;
    });
  }

  final _$_ExibirQuestaoComFiltroControllerBaseActionController =
      ActionController(name: '_ExibirQuestaoComFiltroControllerBase');

  @override
  void voltar() {
    final _$actionInfo = _$_ExibirQuestaoComFiltroControllerBaseActionController
        .startAction(name: '_ExibirQuestaoComFiltroControllerBase.voltar');
    try {
      return super.voltar();
    } finally {
      _$_ExibirQuestaoComFiltroControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void avancar() {
    final _$actionInfo = _$_ExibirQuestaoComFiltroControllerBaseActionController
        .startAction(name: '_ExibirQuestaoComFiltroControllerBase.avancar');
    try {
      return super.avancar();
    } finally {
      _$_ExibirQuestaoComFiltroControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void definirIndice(int valor, {bool forcar = false}) {
    final _$actionInfo =
        _$_ExibirQuestaoComFiltroControllerBaseActionController.startAction(
            name: '_ExibirQuestaoComFiltroControllerBase.definirIndice');
    try {
      return super.definirIndice(valor, forcar: forcar);
    } finally {
      _$_ExibirQuestaoComFiltroControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
questaoAtual: ${questaoAtual}
    ''';
  }
}

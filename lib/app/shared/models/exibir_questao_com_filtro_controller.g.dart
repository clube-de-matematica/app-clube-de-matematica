// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exibir_questao_com_filtro_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExibirQuestaoComFiltroController
    on ExibirQuestaoComFiltroControllerBase, Store {
  Computed<ObservableFuture<int>>? _$_numQuestoesAssincComputed;

  @override
  ObservableFuture<int> get _numQuestoesAssinc =>
      (_$_numQuestoesAssincComputed ??= Computed<ObservableFuture<int>>(
              () => super._numQuestoesAssinc,
              name: 'ExibirQuestaoComFiltroControllerBase._numQuestoesAssinc'))
          .value;
  Computed<int>? _$numQuestoesComputed;

  @override
  int get numQuestoes =>
      (_$numQuestoesComputed ??= Computed<int>(() => super.numQuestoes,
              name: 'ExibirQuestaoComFiltroControllerBase.numQuestoes'))
          .value;
  Computed<ObservableFuture<Questao?>>? _$questaoAtualComputed;

  @override
  ObservableFuture<Questao?> get questaoAtual => (_$questaoAtualComputed ??=
          Computed<ObservableFuture<Questao?>>(() => super.questaoAtual,
              name: 'ExibirQuestaoComFiltroControllerBase.questaoAtual'))
      .value;
  Computed<int>? _$indiceComputed;

  @override
  int get indice => (_$indiceComputed ??= Computed<int>(() => super.indice,
          name: 'ExibirQuestaoComFiltroControllerBase.indice'))
      .value;

  late final _$_carregadoAtom = Atom(
      name: 'ExibirQuestaoComFiltroControllerBase._carregado',
      context: context);

  @override
  Completer<bool> get _carregado {
    _$_carregadoAtom.reportRead();
    return super._carregado;
  }

  @override
  set _carregado(Completer<bool> value) {
    _$_carregadoAtom.reportWrite(value, super._carregado, () {
      super._carregado = value;
    });
  }

  late final _$_questaoAtualAtom = Atom(
      name: 'ExibirQuestaoComFiltroControllerBase._questaoAtual',
      context: context);

  @override
  ObservableFuture<Questao?> get _questaoAtual {
    _$_questaoAtualAtom.reportRead();
    return super._questaoAtual;
  }

  bool __questaoAtualIsInitialized = false;

  @override
  set _questaoAtual(ObservableFuture<Questao?> value) {
    _$_questaoAtualAtom.reportWrite(
        value, __questaoAtualIsInitialized ? super._questaoAtual : null, () {
      super._questaoAtual = value;
      __questaoAtualIsInitialized = true;
    });
  }

  late final _$abrirPaginaFiltrosAsyncAction = AsyncAction(
      'ExibirQuestaoComFiltroControllerBase.abrirPaginaFiltros',
      context: context);

  @override
  Future<Filtros> abrirPaginaFiltros(BuildContext context) {
    return _$abrirPaginaFiltrosAsyncAction
        .run(() => super.abrirPaginaFiltros(context));
  }

  late final _$ExibirQuestaoComFiltroControllerBaseActionController =
      ActionController(
          name: 'ExibirQuestaoComFiltroControllerBase', context: context);

  @override
  Future<bool> recarregar() {
    final _$actionInfo = _$ExibirQuestaoComFiltroControllerBaseActionController
        .startAction(name: 'ExibirQuestaoComFiltroControllerBase.recarregar');
    try {
      return super.recarregar();
    } finally {
      _$ExibirQuestaoComFiltroControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void voltar() {
    final _$actionInfo = _$ExibirQuestaoComFiltroControllerBaseActionController
        .startAction(name: 'ExibirQuestaoComFiltroControllerBase.voltar');
    try {
      return super.voltar();
    } finally {
      _$ExibirQuestaoComFiltroControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void avancar() {
    final _$actionInfo = _$ExibirQuestaoComFiltroControllerBaseActionController
        .startAction(name: 'ExibirQuestaoComFiltroControllerBase.avancar');
    try {
      return super.avancar();
    } finally {
      _$ExibirQuestaoComFiltroControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void definirIndice(int valor, {bool forcar = false}) {
    final _$actionInfo =
        _$ExibirQuestaoComFiltroControllerBaseActionController.startAction(
            name: 'ExibirQuestaoComFiltroControllerBase.definirIndice');
    try {
      return super.definirIndice(valor, forcar: forcar);
    } finally {
      _$ExibirQuestaoComFiltroControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
numQuestoes: ${numQuestoes},
questaoAtual: ${questaoAtual},
indice: ${indice}
    ''';
  }
}

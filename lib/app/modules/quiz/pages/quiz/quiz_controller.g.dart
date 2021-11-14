// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuizController on _QuizControllerBase, Store {
  Computed<List<Questao>>? _$itensFiltradosComputed;

  @override
  List<Questao> get itensFiltrados => (_$itensFiltradosComputed ??=
          Computed<List<Questao>>(() => super.itensFiltrados,
              name: '_QuizControllerBase.itensFiltrados'))
      .value;
  Computed<Questao>? _$questaoComputed;

  @override
  Questao get questao =>
      (_$questaoComputed ??= Computed<Questao>(() => super.questao,
              name: '_QuizControllerBase.questao'))
          .value;
  Computed<int>? _$indiceComputed;

  @override
  int get indice => (_$indiceComputed ??=
          Computed<int>(() => super.indice, name: '_QuizControllerBase.indice'))
      .value;
  Computed<String>? _$textoContadorBarOpcoesItemComputed;

  @override
  String get textoContadorBarOpcoesItem =>
      (_$textoContadorBarOpcoesItemComputed ??= Computed<String>(
              () => super.textoContadorBarOpcoesItem,
              name: '_QuizControllerBase.textoContadorBarOpcoesItem'))
          .value;
  Computed<bool>? _$podeAvancarComputed;

  @override
  bool get podeAvancar =>
      (_$podeAvancarComputed ??= Computed<bool>(() => super.podeAvancar,
              name: '_QuizControllerBase.podeAvancar'))
          .value;
  Computed<bool>? _$podeVoltarComputed;

  @override
  bool get podeVoltar =>
      (_$podeVoltarComputed ??= Computed<bool>(() => super.podeVoltar,
              name: '_QuizControllerBase.podeVoltar'))
          .value;
  Computed<bool>? _$podeConfirmarComputed;

  @override
  bool get podeConfirmar =>
      (_$podeConfirmarComputed ??= Computed<bool>(() => super.podeConfirmar,
              name: '_QuizControllerBase.podeConfirmar'))
          .value;

  final _$_indiceAtom = Atom(name: '_QuizControllerBase._indice');

  @override
  int get _indice {
    _$_indiceAtom.reportRead();
    return super._indice;
  }

  @override
  set _indice(int value) {
    _$_indiceAtom.reportWrite(value, super._indice, () {
      super._indice = value;
    });
  }

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

  final _$_QuizControllerBaseActionController =
      ActionController(name: '_QuizControllerBase');

  @override
  void _setIndice(int valor, {bool force = false}) {
    final _$actionInfo = _$_QuizControllerBaseActionController.startAction(
        name: '_QuizControllerBase._setIndice');
    try {
      return super._setIndice(valor, force: force);
    } finally {
      _$_QuizControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
alternativaSelecionada: ${alternativaSelecionada},
itensFiltrados: ${itensFiltrados},
questao: ${questao},
indice: ${indice},
textoContadorBarOpcoesItem: ${textoContadorBarOpcoesItem},
podeAvancar: ${podeAvancar},
podeVoltar: ${podeVoltar},
podeConfirmar: ${podeConfirmar}
    ''';
  }
}

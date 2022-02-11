// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuizController on _QuizControllerBase, Store {
  Computed<ObservableFuture<Questao?>>? _$questaoAtualComputed;

  @override
  ObservableFuture<Questao?> get questaoAtual => (_$questaoAtualComputed ??=
          Computed<ObservableFuture<Questao?>>(() => super.questaoAtual,
              name: '_QuizControllerBase.questaoAtual'))
      .value;
  Computed<int?>? _$alternativaSelecionadaComputed;

  @override
  int? get alternativaSelecionada => (_$alternativaSelecionadaComputed ??=
          Computed<int?>(() => super.alternativaSelecionada,
              name: '_QuizControllerBase.alternativaSelecionada'))
      .value;

  final _$_respostaAtom = Atom(name: '_QuizControllerBase._resposta');

  RespostaQuestao? get resposta {
    _$_respostaAtom.reportRead();
    return super._resposta;
  }

  @override
  RespostaQuestao? get _resposta => resposta;

  @override
  set _resposta(RespostaQuestao? value) {
    _$_respostaAtom.reportWrite(value, super._resposta, () {
      super._resposta = value;
    });
  }

  final _$_QuizControllerBaseActionController =
      ActionController(name: '_QuizControllerBase');

  @override
  void _definirResposta(RespostaQuestao? valor) {
    final _$actionInfo = _$_QuizControllerBaseActionController.startAction(
        name: '_QuizControllerBase._definirResposta');
    try {
      return super._definirResposta(valor);
    } finally {
      _$_QuizControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
questaoAtual: ${questaoAtual},
alternativaSelecionada: ${alternativaSelecionada}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QuizController on QuizControllerBase, Store {
  Computed<ObservableFuture<Questao?>>? _$questaoAtualComputed;

  @override
  ObservableFuture<Questao?> get questaoAtual => (_$questaoAtualComputed ??=
          Computed<ObservableFuture<Questao?>>(() => super.questaoAtual,
              name: 'QuizControllerBase.questaoAtual'))
      .value;
  Computed<int?>? _$alternativaSelecionadaComputed;

  @override
  int? get alternativaSelecionada => (_$alternativaSelecionadaComputed ??=
          Computed<int?>(() => super.alternativaSelecionada,
              name: 'QuizControllerBase.alternativaSelecionada'))
      .value;

  late final _$_respostaAtom =
      Atom(name: 'QuizControllerBase._resposta', context: context);

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

  late final _$QuizControllerBaseActionController =
      ActionController(name: 'QuizControllerBase', context: context);

  @override
  void _definirResposta(RespostaQuestao? valor) {
    final _$actionInfo = _$QuizControllerBaseActionController.startAction(
        name: 'QuizControllerBase._definirResposta');
    try {
      return super._definirResposta(valor);
    } finally {
      _$QuizControllerBaseActionController.endAction(_$actionInfo);
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

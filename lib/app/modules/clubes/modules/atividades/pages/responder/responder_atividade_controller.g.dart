// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responder_atividade_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ResponderAtividadeController
    on ResponderAtividadeControllerBase, Store {
  Computed<ObservableList<QuestaoAtividade>>? _$questoesComputed;

  @override
  ObservableList<QuestaoAtividade> get questoes => (_$questoesComputed ??=
          Computed<ObservableList<QuestaoAtividade>>(() => super.questoes,
              name: 'ResponderAtividadeControllerBase.questoes'))
      .value;
  Computed<int>? _$numQuestoesComputed;

  @override
  int get numQuestoes =>
      (_$numQuestoesComputed ??= Computed<int>(() => super.numQuestoes,
              name: 'ResponderAtividadeControllerBase.numQuestoes'))
          .value;
  Computed<QuestaoAtividade?>? _$_questaoAtualComputed;

  @override
  QuestaoAtividade? get _questaoAtual => (_$_questaoAtualComputed ??=
          Computed<QuestaoAtividade?>(() => super._questaoAtual,
              name: 'ResponderAtividadeControllerBase._questaoAtual'))
      .value;
  Computed<ObservableFuture<QuestaoAtividade?>>? _$questaoAtualComputed;

  @override
  ObservableFuture<QuestaoAtividade?> get questaoAtual =>
      (_$questaoAtualComputed ??= Computed<ObservableFuture<QuestaoAtividade?>>(
              () => super.questaoAtual,
              name: 'ResponderAtividadeControllerBase.questaoAtual'))
          .value;
  Computed<RespostaQuestaoAtividade?>? _$respostaComputed;

  @override
  RespostaQuestaoAtividade? get resposta => (_$respostaComputed ??=
          Computed<RespostaQuestaoAtividade?>(() => super.resposta,
              name: 'ResponderAtividadeControllerBase.resposta'))
      .value;
  Computed<bool>? _$isEmptyComputed;

  @override
  bool get isEmpty => (_$isEmptyComputed ??= Computed<bool>(() => super.isEmpty,
          name: 'ResponderAtividadeControllerBase.isEmpty'))
      .value;
  Computed<bool>? _$isNotEmptyComputed;

  @override
  bool get isNotEmpty =>
      (_$isNotEmptyComputed ??= Computed<bool>(() => super.isNotEmpty,
              name: 'ResponderAtividadeControllerBase.isNotEmpty'))
          .value;
  Computed<bool>? _$podeConcluirComputed;

  @override
  bool get podeConcluir =>
      (_$podeConcluirComputed ??= Computed<bool>(() => super.podeConcluir,
              name: 'ResponderAtividadeControllerBase.podeConcluir'))
          .value;

  @override
  String toString() {
    return '''
questoes: ${questoes},
numQuestoes: ${numQuestoes},
questaoAtual: ${questaoAtual},
resposta: ${resposta},
isEmpty: ${isEmpty},
isNotEmpty: ${isNotEmpty},
podeConcluir: ${podeConcluir}
    ''';
  }
}

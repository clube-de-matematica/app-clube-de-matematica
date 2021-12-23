// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responder_atividade_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ResponderAtividadeController
    on _ResponderAtividadeControllerBase, Store {
  Computed<List<QuestaoAtividade>>? _$questoesComputed;

  @override
  List<QuestaoAtividade> get questoes => (_$questoesComputed ??=
          Computed<List<QuestaoAtividade>>(() => super.questoes,
              name: '_ResponderAtividadeControllerBase.questoes'))
      .value;
  Computed<QuestaoAtividade?>? _$questaoComputed;

  @override
  QuestaoAtividade? get questao =>
      (_$questaoComputed ??= Computed<QuestaoAtividade?>(() => super.questao,
              name: '_ResponderAtividadeControllerBase.questao'))
          .value;
  Computed<RespostaQuestaoAtividade?>? _$respostaComputed;

  @override
  RespostaQuestaoAtividade? get resposta => (_$respostaComputed ??=
          Computed<RespostaQuestaoAtividade?>(() => super.resposta,
              name: '_ResponderAtividadeControllerBase.resposta'))
      .value;
  Computed<bool>? _$podeConfirmarComputed;

  @override
  bool get podeConfirmar =>
      (_$podeConfirmarComputed ??= Computed<bool>(() => super.podeConfirmar,
              name: '_ResponderAtividadeControllerBase.podeConfirmar'))
          .value;

  @override
  String toString() {
    return '''
questoes: ${questoes},
questao: ${questao},
resposta: ${resposta},
podeConfirmar: ${podeConfirmar}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_atividade.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestaoAtividade on _QuestaoAtividadeBase, Store {
  Computed<Set<RespostaQuestaoAtividade>>? _$respostasComputed;

  @override
  Set<RespostaQuestaoAtividade> get respostas => (_$respostasComputed ??=
          Computed<Set<RespostaQuestaoAtividade>>(() => super.respostas,
              name: '_QuestaoAtividadeBase.respostas'))
      .value;

  @override
  String toString() {
    return '''
respostas: ${respostas}
    ''';
  }
}

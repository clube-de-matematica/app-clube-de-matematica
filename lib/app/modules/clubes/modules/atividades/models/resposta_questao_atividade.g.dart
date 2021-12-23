// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resposta_questao_atividade.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RespostaQuestaoAtividade on _RespostaQuestaoAtividadeBase, Store {
  final _$sequencialAtom =
      Atom(name: '_RespostaQuestaoAtividadeBase.sequencial');

  @override
  int? get sequencial {
    _$sequencialAtom.reportRead();
    return super.sequencial;
  }

  @override
  set sequencial(int? value) {
    _$sequencialAtom.reportWrite(value, super.sequencial, () {
      super.sequencial = value;
    });
  }

  final _$sequencialTemporarioAtom =
      Atom(name: '_RespostaQuestaoAtividadeBase.sequencialTemporario');

  @override
  int? get sequencialTemporario {
    _$sequencialTemporarioAtom.reportRead();
    return super.sequencialTemporario;
  }

  @override
  set sequencialTemporario(int? value) {
    _$sequencialTemporarioAtom.reportWrite(value, super.sequencialTemporario,
        () {
      super.sequencialTemporario = value;
    });
  }

  @override
  String toString() {
    return '''
sequencial: ${sequencial},
sequencialTemporario: ${sequencialTemporario}
    ''';
  }
}

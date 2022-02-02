// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atividade.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Atividade on _AtividadeBase, Store {
  Computed<bool>? _$encerradaComputed;

  @override
  bool get encerrada =>
      (_$encerradaComputed ??= Computed<bool>(() => super.encerrada,
              name: '_AtividadeBase.encerrada'))
          .value;
  Computed<bool>? _$liberadaComputed;

  @override
  bool get liberada => (_$liberadaComputed ??=
          Computed<bool>(() => super.liberada, name: '_AtividadeBase.liberada'))
      .value;

  final _$liberacaoAtom = Atom(name: '_AtividadeBase.liberacao');

  @override
  DateTime? get liberacao {
    _$liberacaoAtom.reportRead();
    return super.liberacao;
  }

  @override
  set liberacao(DateTime? value) {
    _$liberacaoAtom.reportWrite(value, super.liberacao, () {
      super.liberacao = value;
    });
  }

  final _$encerramentoAtom = Atom(name: '_AtividadeBase.encerramento');

  @override
  DateTime? get encerramento {
    _$encerramentoAtom.reportRead();
    return super.encerramento;
  }

  @override
  set encerramento(DateTime? value) {
    _$encerramentoAtom.reportWrite(value, super.encerramento, () {
      super.encerramento = value;
    });
  }

  @override
  String toString() {
    return '''
liberacao: ${liberacao},
encerramento: ${encerramento},
encerrada: ${encerrada},
liberada: ${liberada}
    ''';
  }
}

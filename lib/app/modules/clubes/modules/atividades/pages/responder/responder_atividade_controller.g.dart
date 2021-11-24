// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responder_atividade_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ResponderAtividadeController
    on _ResponderAtividadeControllerBase, Store {
  Computed<bool>? _$podeConfirmarComputed;

  @override
  bool get podeConfirmar =>
      (_$podeConfirmarComputed ??= Computed<bool>(() => super.podeConfirmar,
              name: '_ResponderAtividadeControllerBase.podeConfirmar'))
          .value;

  final _$alternativaSelecionadaAtom =
      Atom(name: '_ResponderAtividadeControllerBase.alternativaSelecionada');

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

  @override
  String toString() {
    return '''
alternativaSelecionada: ${alternativaSelecionada},
podeConfirmar: ${podeConfirmar}
    ''';
  }
}

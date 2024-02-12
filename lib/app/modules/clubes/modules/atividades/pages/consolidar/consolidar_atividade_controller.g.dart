// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consolidar_atividade_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConsolidarAtividadeController
    on _ConsolidarAtividadeControllerBase, Store {
  Computed<bool>? _$podeLiberarComputed;

  @override
  bool get podeLiberar =>
      (_$podeLiberarComputed ??= Computed<bool>(() => super.podeLiberar,
              name: '_ConsolidarAtividadeControllerBase.podeLiberar'))
          .value;
  Computed<bool>? _$podeExcluirComputed;

  @override
  bool get podeExcluir =>
      (_$podeExcluirComputed ??= Computed<bool>(() => super.podeExcluir,
              name: '_ConsolidarAtividadeControllerBase.podeExcluir'))
          .value;
  Computed<bool>? _$podeEditarComputed;

  @override
  bool get podeEditar =>
      (_$podeEditarComputed ??= Computed<bool>(() => super.podeEditar,
              name: '_ConsolidarAtividadeControllerBase.podeEditar'))
          .value;

  @override
  String toString() {
    return '''
podeLiberar: ${podeLiberar},
podeExcluir: ${podeExcluir},
podeEditar: ${podeEditar}
    ''';
  }
}

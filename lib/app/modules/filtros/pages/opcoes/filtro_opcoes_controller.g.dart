// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtro_opcoes_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FiltroOpcoesController on _FiltroOpcoesControllerBase, Store {
  Computed<int>? _$totalSelecinadoComputed;

  @override
  int get totalSelecinado =>
      (_$totalSelecinadoComputed ??= Computed<int>(() => super.totalSelecinado,
              name: '_FiltroOpcoesControllerBase.totalSelecinado'))
          .value;
  Computed<bool>? _$ativarLimparComputed;

  @override
  bool get ativarLimpar =>
      (_$ativarLimparComputed ??= Computed<bool>(() => super.ativarLimpar,
              name: '_FiltroOpcoesControllerBase.ativarLimpar'))
          .value;

  @override
  String toString() {
    return '''
totalSelecinado: ${totalSelecinado},
ativarLimpar: ${ativarLimpar}
    ''';
  }
}

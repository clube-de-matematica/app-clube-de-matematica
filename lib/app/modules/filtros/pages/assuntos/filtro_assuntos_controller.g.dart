// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtro_assuntos_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FiltroAssuntosController on FiltroAssuntosControllerBase, Store {
  Computed<int>? _$totalSelecinadoComputed;

  @override
  int get totalSelecinado =>
      (_$totalSelecinadoComputed ??= Computed<int>(() => super.totalSelecinado,
              name: 'FiltroAssuntosControllerBase.totalSelecinado'))
          .value;
  Computed<bool>? _$ativarLimparComputed;

  @override
  bool get ativarLimpar =>
      (_$ativarLimparComputed ??= Computed<bool>(() => super.ativarLimpar,
              name: 'FiltroAssuntosControllerBase.ativarLimpar'))
          .value;
  Computed<List<Assunto>>? _$unidadesComputed;

  @override
  List<Assunto> get unidades =>
      (_$unidadesComputed ??= Computed<List<Assunto>>(() => super.unidades,
              name: 'FiltroAssuntosControllerBase.unidades'))
          .value;
  Computed<ObservableSet<int>>? _$selecionadosComputed;

  @override
  ObservableSet<int> get selecionados => (_$selecionadosComputed ??=
          Computed<ObservableSet<int>>(() => super.selecionados,
              name: 'FiltroAssuntosControllerBase.selecionados'))
      .value;

  @override
  String toString() {
    return '''
totalSelecinado: ${totalSelecinado},
ativarLimpar: ${ativarLimpar},
unidades: ${unidades},
selecionados: ${selecionados}
    ''';
  }
}

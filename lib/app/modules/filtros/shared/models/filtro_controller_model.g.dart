// GENERATED CODE - DO NOT MODIFY BY HAND


part of 'filtro_controller_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FiltroController on _FiltroControllerBase, Store {
  Computed<Map<TiposFiltro, Set<OpcaoFiltro>>>? _$allFiltersComputed;

  @override
  Map<TiposFiltro, Set<OpcaoFiltro>> get allFilters => (_$allFiltersComputed ??=
          Computed<Map<TiposFiltro, Set<OpcaoFiltro>>>(() => super.allFilters,
              name: '_FiltroControllerBase.allFilters'))
      .value;
  Computed<bool>? _$ativarAplicarComputed;

  @override
  bool get ativarAplicar =>
      (_$ativarAplicarComputed ??= Computed<bool>(() => super.ativarAplicar,
              name: '_FiltroControllerBase.ativarAplicar'))
          .value;

  final _$_FiltroControllerBaseActionController =
      ActionController(name: '_FiltroControllerBase');

  @override
  void aplicar() {
    final _$actionInfo = _$_FiltroControllerBaseActionController.startAction(
        name: '_FiltroControllerBase.aplicar');
    try {
      return super.aplicar();
    } finally {
      _$_FiltroControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
allFilters: ${allFilters},
ativarAplicar: ${ativarAplicar}
    ''';
  }
}

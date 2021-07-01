// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opcao_filtro_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OpcaoFiltro on _OpcaoFiltroBase, Store {
  Computed<bool>? _$isSelectedComputed;

  @override
  bool get isSelected =>
      (_$isSelectedComputed ??= Computed<bool>(() => super.isSelected,
              name: '_OpcaoFiltroBase.isSelected'))
          .value;

  final _$_isSelectedAtom = Atom(name: '_OpcaoFiltroBase._isSelected');

  @override
  bool get _isSelected {
    _$_isSelectedAtom.reportRead();
    return super._isSelected;
  }

  @override
  set _isSelected(bool value) {
    _$_isSelectedAtom.reportWrite(value, super._isSelected, () {
      super._isSelected = value;
    });
  }

  final _$_OpcaoFiltroBaseActionController =
      ActionController(name: '_OpcaoFiltroBase');

  @override
  void changeIsSelected(Filtros filtros,
      {bool forcAdd = false, bool forcRemove = false}) {
    final _$actionInfo = _$_OpcaoFiltroBaseActionController.startAction(
        name: '_OpcaoFiltroBase.changeIsSelected');
    try {
      return super
          .changeIsSelected(filtros, forcAdd: forcAdd, forcRemove: forcRemove);
    } finally {
      _$_OpcaoFiltroBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isSelected: ${isSelected}
    ''';
  }
}

mixin _$OpcaoFiltroAssunto on _OpcaoFiltroAssuntoBase, Store {
  @override
  String toString() {
    return '''

    ''';
  }
}

mixin _$OpcaoFiltroAssuntoUnidade on _OpcaoFiltroAssuntoUnidadeBase, Store {
  Computed<bool>? _$isSelectedAllAsuntosComputed;

  @override
  bool get isSelectedAllAsuntos => (_$isSelectedAllAsuntosComputed ??=
          Computed<bool>(() => super.isSelectedAllAsuntos,
              name: '_OpcaoFiltroAssuntoUnidadeBase.isSelectedAllAsuntos'))
      .value;
  Computed<int>? _$numAsuntosSelectedComputed;

  @override
  int get numAsuntosSelected => (_$numAsuntosSelectedComputed ??= Computed<int>(
          () => super.numAsuntosSelected,
          name: '_OpcaoFiltroAssuntoUnidadeBase.numAsuntosSelected'))
      .value;

  @override
  String toString() {
    return '''
isSelectedAllAsuntos: ${isSelectedAllAsuntos},
numAsuntosSelected: ${numAsuntosSelected}
    ''';
  }
}

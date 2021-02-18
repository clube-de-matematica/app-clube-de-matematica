// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtros_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Filtros on _FiltrosBase, Store {
  Computed<Map<TiposFiltro, Set<OpcaoFiltro>>> _$allFiltersComputed;

  @override
  Map<TiposFiltro, Set<OpcaoFiltro>> get allFilters => (_$allFiltersComputed ??=
          Computed<Map<TiposFiltro, Set<OpcaoFiltro>>>(() => super.allFilters,
              name: '_FiltrosBase.allFilters'))
      .value;
  Computed<int> _$totalSelecinadoComputed;

  @override
  int get totalSelecinado =>
      (_$totalSelecinadoComputed ??= Computed<int>(() => super.totalSelecinado,
              name: '_FiltrosBase.totalSelecinado'))
          .value;
  Computed<List<Item>> _$allItensComputed;

  @override
  List<Item> get allItens =>
      (_$allItensComputed ??= Computed<List<Item>>(() => super.allItens,
              name: '_FiltrosBase.allItens'))
          .value;
  Computed<List<Item>> _$itensFiltradosComputed;

  @override
  List<Item> get itensFiltrados => (_$itensFiltradosComputed ??=
          Computed<List<Item>>(() => super.itensFiltrados,
              name: '_FiltrosBase.itensFiltrados'))
      .value;

  final _$assuntosAtom = Atom(name: '_FiltrosBase.assuntos');

  @override
  ObservableSet<OpcaoFiltro> get assuntos {
    _$assuntosAtom.reportRead();
    return super.assuntos;
  }

  @override
  set assuntos(ObservableSet<OpcaoFiltro> value) {
    _$assuntosAtom.reportWrite(value, super.assuntos, () {
      super.assuntos = value;
    });
  }

  final _$anosAtom = Atom(name: '_FiltrosBase.anos');

  @override
  ObservableSet<OpcaoFiltro> get anos {
    _$anosAtom.reportRead();
    return super.anos;
  }

  @override
  set anos(ObservableSet<OpcaoFiltro> value) {
    _$anosAtom.reportWrite(value, super.anos, () {
      super.anos = value;
    });
  }

  final _$niveisAtom = Atom(name: '_FiltrosBase.niveis');

  @override
  ObservableSet<OpcaoFiltro> get niveis {
    _$niveisAtom.reportRead();
    return super.niveis;
  }

  @override
  set niveis(ObservableSet<OpcaoFiltro> value) {
    _$niveisAtom.reportWrite(value, super.niveis, () {
      super.niveis = value;
    });
  }

  final _$dificuldadesAtom = Atom(name: '_FiltrosBase.dificuldades');

  @override
  ObservableSet<OpcaoFiltro> get dificuldades {
    _$dificuldadesAtom.reportRead();
    return super.dificuldades;
  }

  @override
  set dificuldades(ObservableSet<OpcaoFiltro> value) {
    _$dificuldadesAtom.reportWrite(value, super.dificuldades, () {
      super.dificuldades = value;
    });
  }

  final _$_FiltrosBaseActionController = ActionController(name: '_FiltrosBase');

  @override
  void add(OpcaoFiltro opcao) {
    final _$actionInfo =
        _$_FiltrosBaseActionController.startAction(name: '_FiltrosBase.add');
    try {
      return super.add(opcao);
    } finally {
      _$_FiltrosBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void remove(OpcaoFiltro opcao) {
    final _$actionInfo =
        _$_FiltrosBaseActionController.startAction(name: '_FiltrosBase.remove');
    try {
      return super.remove(opcao);
    } finally {
      _$_FiltrosBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void aplicar(Filtros other) {
    final _$actionInfo = _$_FiltrosBaseActionController.startAction(
        name: '_FiltrosBase.aplicar');
    try {
      return super.aplicar(other);
    } finally {
      _$_FiltrosBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
assuntos: ${assuntos},
anos: ${anos},
niveis: ${niveis},
dificuldades: ${dificuldades},
allFilters: ${allFilters},
totalSelecinado: ${totalSelecinado},
allItens: ${allItens},
itensFiltrados: ${itensFiltrados}
    ''';
  }
}

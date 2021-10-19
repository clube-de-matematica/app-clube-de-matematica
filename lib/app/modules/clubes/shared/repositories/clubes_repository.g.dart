// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clubes_repository.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ClubesRepository on _ClubesRepositoryBase, Store {
  Computed<List<Clube>>? _$clubesComputed;

  @override
  List<Clube> get clubes =>
      (_$clubesComputed ??= Computed<List<Clube>>(() => super.clubes,
              name: '_ClubesRepositoryBase.clubes'))
          .value;

  final _$_clubesAtom = Atom(name: '_ClubesRepositoryBase._clubes');

  @override
  ObservableList<Clube> get _clubes {
    _$_clubesAtom.reportRead();
    return super._clubes;
  }

  @override
  set _clubes(ObservableList<Clube> value) {
    _$_clubesAtom.reportWrite(value, super._clubes, () {
      super._clubes = value;
    });
  }

  final _$carregarClubesAsyncAction =
      AsyncAction('_ClubesRepositoryBase.carregarClubes');

  @override
  Future<List<Clube>> carregarClubes() {
    return _$carregarClubesAsyncAction.run(() => super.carregarClubes());
  }

  final _$criarClubeAsyncAction =
      AsyncAction('_ClubesRepositoryBase.criarClube');

  @override
  Future<Clube?> criarClube(
      String nome, String? descricao, String? capa, bool privado,
      {List<int>? administradores, List<int>? membros}) {
    return _$criarClubeAsyncAction.run(() => super.criarClube(
        nome, descricao, capa, privado,
        administradores: administradores, membros: membros));
  }

  final _$sairClubeAsyncAction = AsyncAction('_ClubesRepositoryBase.sairClube');

  @override
  Future<bool> sairClube(Clube clube) {
    return _$sairClubeAsyncAction.run(() => super.sairClube(clube));
  }

  final _$entrarClubeAsyncAction =
      AsyncAction('_ClubesRepositoryBase.entrarClube');

  @override
  Future<Clube?> entrarClube(String codigo) {
    return _$entrarClubeAsyncAction.run(() => super.entrarClube(codigo));
  }

  final _$_ClubesRepositoryBaseActionController =
      ActionController(name: '_ClubesRepositoryBase');

  @override
  void _addInClubes(Clube clube) {
    final _$actionInfo = _$_ClubesRepositoryBaseActionController.startAction(
        name: '_ClubesRepositoryBase._addInClubes');
    try {
      return super._addInClubes(clube);
    } finally {
      _$_ClubesRepositoryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _cleanClubes() {
    final _$actionInfo = _$_ClubesRepositoryBaseActionController.startAction(
        name: '_ClubesRepositoryBase._cleanClubes');
    try {
      return super._cleanClubes();
    } finally {
      _$_ClubesRepositoryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
clubes: ${clubes}
    ''';
  }
}

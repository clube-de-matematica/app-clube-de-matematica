// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itens_repository.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ItensRepository on _ItensRepositoryBase, Store {
  Computed<List<Item>>? _$itensComputed;

  @override
  List<Item> get itens =>
      (_$itensComputed ??= Computed<List<Item>>(() => super.itens,
              name: '_ItensRepositoryBase.itens'))
          .value;

  final _$_itensAtom = Atom(name: '_ItensRepositoryBase._itens');

  @override
  ObservableList<Item> get _itens {
    _$_itensAtom.reportRead();
    return super._itens;
  }

  @override
  set _itens(ObservableList<Item> value) {
    _$_itensAtom.reportWrite(value, super._itens, () {
      super._itens = value;
    });
  }

  final _$carregarItensAsyncAction =
      AsyncAction('_ItensRepositoryBase.carregarItens');

  @override
  Future<List<Item>> carregarItens() {
    return _$carregarItensAsyncAction.run(() => super.carregarItens());
  }

  final _$_carregarItemReferenciadoAsyncAction =
      AsyncAction('_ItensRepositoryBase._carregarItemReferenciado');

  @override
  Future<Item?> _carregarItemReferenciado(
      QuerySnapshot dbItensSnapshot, Map<String, dynamic> itemReferenciador) {
    return _$_carregarItemReferenciadoAsyncAction.run(() =>
        super._carregarItemReferenciado(dbItensSnapshot, itemReferenciador));
  }

  final _$_ItensRepositoryBaseActionController =
      ActionController(name: '_ItensRepositoryBase');

  @override
  void _addInItens(Item item) {
    final _$actionInfo = _$_ItensRepositoryBaseActionController.startAction(
        name: '_ItensRepositoryBase._addInItens');
    try {
      return super._addInItens(item);
    } finally {
      _$_ItensRepositoryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
itens: ${itens}
    ''';
  }
}

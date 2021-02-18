// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagem_item_repository.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ImagemItemRepository on _ImagemItemRepositoryBase, Store {
  final _$imagensAtom = Atom(name: '_ImagemItemRepositoryBase.imagens');

  @override
  ObservableList<ImagemItem> get imagens {
    _$imagensAtom.reportRead();
    return super.imagens;
  }

  @override
  set imagens(ObservableList<ImagemItem> value) {
    _$imagensAtom.reportWrite(value, super.imagens, () {
      super.imagens = value;
    });
  }

  final _$_ImagemItemRepositoryBaseActionController =
      ActionController(name: '_ImagemItemRepositoryBase');

  @override
  void _addInImagens(ImagemItem imagem) {
    final _$actionInfo = _$_ImagemItemRepositoryBaseActionController
        .startAction(name: '_ImagemItemRepositoryBase._addInImagens');
    try {
      return super._addInImagens(imagem);
    } finally {
      _$_ImagemItemRepositoryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  ImagemItem _getImagemByNome(String nome) {
    final _$actionInfo = _$_ImagemItemRepositoryBaseActionController
        .startAction(name: '_ImagemItemRepositoryBase._getImagemByNome');
    try {
      return super._getImagemByNome(nome);
    } finally {
      _$_ImagemItemRepositoryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
imagens: ${imagens}
    ''';
  }
}

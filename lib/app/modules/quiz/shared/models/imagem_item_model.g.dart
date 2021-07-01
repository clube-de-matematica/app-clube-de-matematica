// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagem_item_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ImagemItem on _ImagemItemBase, Store {
  Computed<ImageProvider<Object>?>? _$providerComputed;

  @override
  ImageProvider<Object>? get provider => (_$providerComputed ??=
          Computed<ImageProvider<Object>?>(() => super.provider,
              name: '_ImagemItemBase.provider'))
      .value;

  final _$_providerAtom = Atom(name: '_ImagemItemBase._provider');

  @override
  ImageProvider<Object>? get _provider {
    _$_providerAtom.reportRead();
    return super._provider;
  }

  @override
  set _provider(ImageProvider<Object>? value) {
    _$_providerAtom.reportWrite(value, super._provider, () {
      super._provider = value;
    });
  }

  final _$_ImagemItemBaseActionController =
      ActionController(name: '_ImagemItemBase');

  @override
  void _setProvider(ImageProvider<Object>? valor) {
    final _$actionInfo = _$_ImagemItemBaseActionController.startAction(
        name: '_ImagemItemBase._setProvider');
    try {
      return super._setProvider(valor);
    } finally {
      _$_ImagemItemBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
provider: ${provider}
    ''';
  }
}

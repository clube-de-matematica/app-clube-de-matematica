// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagem_questao_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ImagemQuestao on _ImagemQuestaoBase, Store {
  Computed<ImageProvider<Object>?>? _$providerComputed;

  @override
  ImageProvider<Object>? get provider => (_$providerComputed ??=
          Computed<ImageProvider<Object>?>(() => super.provider,
              name: '_ImagemQuestaoBase.provider'))
      .value;

  late final _$_providerAtom =
      Atom(name: '_ImagemQuestaoBase._provider', context: context);

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

  late final _$_ImagemQuestaoBaseActionController =
      ActionController(name: '_ImagemQuestaoBase', context: context);

  @override
  void _setProvider(ImageProvider<Object>? valor) {
    final _$actionInfo = _$_ImagemQuestaoBaseActionController.startAction(
        name: '_ImagemQuestaoBase._setProvider');
    try {
      return super._setProvider(valor);
    } finally {
      _$_ImagemQuestaoBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
provider: ${provider}
    ''';
  }
}

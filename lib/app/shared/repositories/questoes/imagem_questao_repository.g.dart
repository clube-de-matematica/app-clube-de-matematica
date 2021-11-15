// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagem_questao_repository.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ImagemQuestaoRepository on _ImagemQuestaoRepositoryBase, Store {
  final _$imagensAtom = Atom(name: '_ImagemQuestaoRepositoryBase.imagens');

  @override
  ObservableList<ImagemQuestao> get imagens {
    _$imagensAtom.reportRead();
    return super.imagens;
  }

  @override
  set imagens(ObservableList<ImagemQuestao> value) {
    _$imagensAtom.reportWrite(value, super.imagens, () {
      super.imagens = value;
    });
  }

  final _$_ImagemQuestaoRepositoryBaseActionController =
      ActionController(name: '_ImagemQuestaoRepositoryBase');

  @override
  void _addInImagens(ImagemQuestao imagem) {
    final _$actionInfo = _$_ImagemQuestaoRepositoryBaseActionController
        .startAction(name: '_ImagemQuestaoRepositoryBase._addInImagens');
    try {
      return super._addInImagens(imagem);
    } finally {
      _$_ImagemQuestaoRepositoryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
imagens: ${imagens}
    ''';
  }
}

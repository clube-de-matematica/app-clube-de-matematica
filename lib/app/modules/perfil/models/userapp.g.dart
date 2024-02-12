// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userapp.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserApp on _UserAppBase, Store {
  Computed<int?>? _$idComputed;

  @override
  int? get id =>
      (_$idComputed ??= Computed<int?>(() => super.id, name: '_UserAppBase.id'))
          .value;
  Computed<String?>? _$nameComputed;

  @override
  String? get name => (_$nameComputed ??=
          Computed<String?>(() => super.name, name: '_UserAppBase.name'))
      .value;

  late final _$_idAtom = Atom(name: '_UserAppBase._id', context: context);

  @override
  int? get _id {
    _$_idAtom.reportRead();
    return super._id;
  }

  @override
  set _id(int? value) {
    _$_idAtom.reportWrite(value, super._id, () {
      super._id = value;
    });
  }

  late final _$_nameAtom = Atom(name: '_UserAppBase._name', context: context);

  @override
  String? get _name {
    _$_nameAtom.reportRead();
    return super._name;
  }

  @override
  set _name(String? value) {
    _$_nameAtom.reportWrite(value, super._name, () {
      super._name = value;
    });
  }

  late final _$setAsyncAction =
      AsyncAction('_UserAppBase.set', context: context);

  @override
  Future<void> set(int? id, String? name, String? email, String? pathAvatar,
      String? urlAvatar) {
    return _$setAsyncAction
        .run(() => super.set(id, name, email, pathAvatar, urlAvatar));
  }

  late final _$_UserAppBaseActionController =
      ActionController(name: '_UserAppBase', context: context);

  @override
  void _setId(int? id) {
    final _$actionInfo =
        _$_UserAppBaseActionController.startAction(name: '_UserAppBase._setId');
    try {
      return super._setId(id);
    } finally {
      _$_UserAppBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setName(String? name) {
    final _$actionInfo = _$_UserAppBaseActionController.startAction(
        name: '_UserAppBase._setName');
    try {
      return super._setName(name);
    } finally {
      _$_UserAppBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
id: ${id},
name: ${name}
    ''';
  }
}

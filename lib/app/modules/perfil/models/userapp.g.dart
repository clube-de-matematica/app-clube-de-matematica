// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userapp.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserApp on _UserAppBase, Store {
  Computed<String?>? _$nameComputed;

  @override
  String? get name => (_$nameComputed ??=
          Computed<String?>(() => super.name, name: '_UserAppBase.name'))
      .value;

  final _$_nameAtom = Atom(name: '_UserAppBase._name');

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

  final _$_UserAppBaseActionController = ActionController(name: '_UserAppBase');

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
name: ${name}
    ''';
  }
}

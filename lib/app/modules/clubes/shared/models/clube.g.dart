// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clube.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Clube on _ClubeBase, Store {
  Computed<ObservableList<UsuarioClube>>? _$usuariosComputed;

  @override
  ObservableList<UsuarioClube> get usuarios => (_$usuariosComputed ??=
          Computed<ObservableList<UsuarioClube>>(() => super.usuarios,
              name: '_ClubeBase.usuarios'))
      .value;
  Computed<ObservableList<UsuarioClube>>? _$administradoresComputed;

  @override
  ObservableList<UsuarioClube> get administradores =>
      (_$administradoresComputed ??= Computed<ObservableList<UsuarioClube>>(
              () => super.administradores,
              name: '_ClubeBase.administradores'))
          .value;
  Computed<ObservableList<UsuarioClube>>? _$membrosComputed;

  @override
  ObservableList<UsuarioClube> get membros => (_$membrosComputed ??=
          Computed<ObservableList<UsuarioClube>>(() => super.membros,
              name: '_ClubeBase.membros'))
      .value;

  final _$nomeAtom = Atom(name: '_ClubeBase.nome');

  @override
  String get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(String value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  final _$descricaoAtom = Atom(name: '_ClubeBase.descricao');

  @override
  String? get descricao {
    _$descricaoAtom.reportRead();
    return super.descricao;
  }

  @override
  set descricao(String? value) {
    _$descricaoAtom.reportWrite(value, super.descricao, () {
      super.descricao = value;
    });
  }

  final _$_usuariosAtom = Atom(name: '_ClubeBase._usuarios');

  @override
  ObservableSet<UsuarioClube> get _usuarios {
    _$_usuariosAtom.reportRead();
    return super._usuarios;
  }

  @override
  set _usuarios(ObservableSet<UsuarioClube> value) {
    _$_usuariosAtom.reportWrite(value, super._usuarios, () {
      super._usuarios = value;
    });
  }

  final _$capaAtom = Atom(name: '_ClubeBase.capa');

  @override
  Color get capa {
    _$capaAtom.reportRead();
    return super.capa;
  }

  @override
  set capa(Color value) {
    _$capaAtom.reportWrite(value, super.capa, () {
      super.capa = value;
    });
  }

  final _$_ClubeBaseActionController = ActionController(name: '_ClubeBase');

  @override
  void sobrescrever(Clube outro) {
    final _$actionInfo = _$_ClubeBaseActionController.startAction(
        name: '_ClubeBase.sobrescrever');
    try {
      return super.sobrescrever(outro);
    } finally {
      _$_ClubeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addUsuarios(Iterable<UsuarioClube> usuarios, {bool verificar = false}) {
    final _$actionInfo = _$_ClubeBaseActionController.startAction(
        name: '_ClubeBase.addUsuarios');
    try {
      return super.addUsuarios(usuarios, verificar: verificar);
    } finally {
      _$_ClubeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removerUsuarios(Iterable<UsuarioClube> usuarios) {
    final _$actionInfo = _$_ClubeBaseActionController.startAction(
        name: '_ClubeBase.removerUsuarios');
    try {
      return super.removerUsuarios(usuarios);
    } finally {
      _$_ClubeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
nome: ${nome},
descricao: ${descricao},
capa: ${capa},
usuarios: ${usuarios},
administradores: ${administradores},
membros: ${membros}
    ''';
  }
}

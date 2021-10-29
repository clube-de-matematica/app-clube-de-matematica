// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_clube.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UsuarioClube on _UsuarioClubeBase, Store {
  Computed<bool>? _$proprietarioComputed;

  @override
  bool get proprietario =>
      (_$proprietarioComputed ??= Computed<bool>(() => super.proprietario,
              name: '_UsuarioClubeBase.proprietario'))
          .value;
  Computed<bool>? _$administradorComputed;

  @override
  bool get administrador =>
      (_$administradorComputed ??= Computed<bool>(() => super.administrador,
              name: '_UsuarioClubeBase.administrador'))
          .value;
  Computed<bool>? _$membroComputed;

  @override
  bool get membro => (_$membroComputed ??=
          Computed<bool>(() => super.membro, name: '_UsuarioClubeBase.membro'))
      .value;

  final _$emailAtom = Atom(name: '_UsuarioClubeBase.email');

  @override
  String? get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String? value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$nomeAtom = Atom(name: '_UsuarioClubeBase.nome');

  @override
  String? get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(String? value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  final _$fotoAtom = Atom(name: '_UsuarioClubeBase.foto');

  @override
  String? get foto {
    _$fotoAtom.reportRead();
    return super.foto;
  }

  @override
  set foto(String? value) {
    _$fotoAtom.reportWrite(value, super.foto, () {
      super.foto = value;
    });
  }

  final _$permissaoAtom = Atom(name: '_UsuarioClubeBase.permissao');

  @override
  PermissoesClube get permissao {
    _$permissaoAtom.reportRead();
    return super.permissao;
  }

  @override
  set permissao(PermissoesClube value) {
    _$permissaoAtom.reportWrite(value, super.permissao, () {
      super.permissao = value;
    });
  }

  final _$_UsuarioClubeBaseActionController =
      ActionController(name: '_UsuarioClubeBase');

  @override
  void sobrescrever(UsuarioClube outro) {
    final _$actionInfo = _$_UsuarioClubeBaseActionController.startAction(
        name: '_UsuarioClubeBase.sobrescrever');
    try {
      return super.sobrescrever(outro);
    } finally {
      _$_UsuarioClubeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
nome: ${nome},
foto: ${foto},
permissao: ${permissao},
proprietario: ${proprietario},
administrador: ${administrador},
membro: ${membro}
    ''';
  }
}

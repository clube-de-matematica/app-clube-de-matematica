// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clube.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Clube on _ClubeBase, Store {
  Computed<Iterable<UsuarioClube>>? _$administradoresComputed;

  @override
  Iterable<UsuarioClube> get administradores => (_$administradoresComputed ??=
          Computed<Iterable<UsuarioClube>>(() => super.administradores,
              name: '_ClubeBase.administradores'))
      .value;
  Computed<Iterable<UsuarioClube>>? _$membrosComputed;

  @override
  Iterable<UsuarioClube> get membros => (_$membrosComputed ??=
          Computed<Iterable<UsuarioClube>>(() => super.membros,
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

  final _$codigoAtom = Atom(name: '_ClubeBase.codigo');

  @override
  String get codigo {
    _$codigoAtom.reportRead();
    return super.codigo;
  }

  @override
  set codigo(String value) {
    _$codigoAtom.reportWrite(value, super.codigo, () {
      super.codigo = value;
    });
  }

  @override
  String toString() {
    return '''
nome: ${nome},
descricao: ${descricao},
capa: ${capa},
codigo: ${codigo},
administradores: ${administradores},
membros: ${membros}
    ''';
  }
}

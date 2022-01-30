// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clubes_repository.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ClubesRepository on _ClubesRepositoryBase, Store {
  final _$criarClubeAsyncAction =
      AsyncAction('_ClubesRepositoryBase.criarClube');

  @override
  Future<Clube?> criarClube(RawClube dados) {
    return _$criarClubeAsyncAction.run(() => super.criarClube(dados));
  }

  final _$sairClubeAsyncAction = AsyncAction('_ClubesRepositoryBase.sairClube');

  @override
  Future<bool> sairClube(Clube clube) {
    return _$sairClubeAsyncAction.run(() => super.sairClube(clube));
  }

  final _$entrarClubeAsyncAction =
      AsyncAction('_ClubesRepositoryBase.entrarClube');

  @override
  Future<Clube?> entrarClube(String codigo) {
    return _$entrarClubeAsyncAction.run(() => super.entrarClube(codigo));
  }

  final _$atualizarClubeAsyncAction =
      AsyncAction('_ClubesRepositoryBase.atualizarClube');

  @override
  Future<bool> atualizarClube(
      {required Clube clube,
      required String nome,
      required String codigo,
      String? descricao,
      required Color capa,
      required bool privado}) {
    return _$atualizarClubeAsyncAction.run(() => super.atualizarClube(
        clube: clube,
        nome: nome,
        codigo: codigo,
        descricao: descricao,
        capa: capa,
        privado: privado));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}

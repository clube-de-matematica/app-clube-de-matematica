// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clubes_repository.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClubesRepository on ClubesRepositoryBase, Store {
  late final _$criarClubeAsyncAction =
      AsyncAction('ClubesRepositoryBase.criarClube', context: context);

  @override
  Future<Clube?> criarClube(RawClube dados) {
    return _$criarClubeAsyncAction.run(() => super.criarClube(dados));
  }

  late final _$sairClubeAsyncAction =
      AsyncAction('ClubesRepositoryBase.sairClube', context: context);

  @override
  Future<bool> sairClube(Clube clube) {
    return _$sairClubeAsyncAction.run(() => super.sairClube(clube));
  }

  late final _$entrarClubeAsyncAction =
      AsyncAction('ClubesRepositoryBase.entrarClube', context: context);

  @override
  Future<Clube?> entrarClube(String codigo) {
    return _$entrarClubeAsyncAction.run(() => super.entrarClube(codigo));
  }

  late final _$atualizarClubeAsyncAction =
      AsyncAction('ClubesRepositoryBase.atualizarClube', context: context);

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

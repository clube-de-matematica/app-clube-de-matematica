import 'dart:async';

import '../utils/strings_db.dart';

enum CollectionType { itens, assuntos }

extension ExtensionCollectionType on CollectionType {
  /// Retorna o nome da coleção (ou tabela) correspondente a [this].
  String get name {
    switch (this) {
      case CollectionType.assuntos:
        return DbConst.kDbDataCollectionAssuntos;
      case CollectionType.itens:
        return DbConst.kDbDataCollectionItens;
    }
  }
}

/// O objeto usado em consultas condicionais.
///
/// [args] deve conter apenas entradas ou de um [DataItem] ou de um [DataAssunto].
class DataWhere {
  final CollectionType collection;

  /// Deve conter apenas entradas ou de um [DataItem] ou de um [DataAssunto].
  final Map<String, dynamic> args;
  DataWhere(
    this.collection,
    this.args,
  )   : assert(args.isNotEmpty),
        assert(() {
          final List<String> keys;
          switch (collection) {
            case CollectionType.assuntos:
              keys = [
                DbConst.kDbDataAssuntoKeyArvore,
                DbConst.kDbDataAssuntoKeyTitulo
              ];
              break;
            case CollectionType.itens:
              keys = [
                DbConst.kDbDataItemKeyAlternativas,
                DbConst.kDbDataItemKeyAno,
                DbConst.kDbDataItemKeyAssuntos,
                DbConst.kDbDataItemKeyDificuldade,
                DbConst.kDbDataItemKeyEnunciado,
                DbConst.kDbDataItemKeyGabarito,
                DbConst.kDbDataItemKeyId,
                DbConst.kDbDataItemKeyImagensEnunciado,
                DbConst.kDbDataItemKeyIndice,
                DbConst.kDbDataItemKeyNivel,
                DbConst.kDbDataItemKeyReferencia
              ];
              break;
          }
          for (var key in args.keys) {
            if (!keys.contains(key)) return false;
          }
          return true;
        }(),
            'Os argumentos ${args.toString()} não corresponderão a nenhum documento (ou '
            'registro) da coleção (ou tabela) "${collection.name}".');
}

/// O super tipo para repositórios de banco de dados remoto.
abstract class IRemoteDbRepository implements IDbRepository {}

/// O super tipo para repositórios de banco de dados local.
abstract class ILocalDbRepository implements IDbRepository {}

/// Deve ser implementada pelas classes que gerenciam a conexão com o banco de dados.
abstract class IDbRepository {
  /* /// O caminho para a coleção (ou o nome da visualização) de itens.
  String get pathItens;

  /// O caminho para a coleção (ou o nome da visualização) de assuntos.
  String get pathAssuntos; */

  /// Retorna os dados da coleção correspondente a [collection] no banco de dados.
  Future<DataCollection> getCollection(
    CollectionType collection,

    ///
    /// Se fornecido, o resultado de [onError] será retornado quando ocorrer um erro na solicitação.
    // {FutureOr<DataCollection> onError(Object error)?,}
  );

  /// Retorna os dados do documento (ou registro), na coleção (ou tabela) correspondente a
  /// [where.collection], cujos campos correspondentes às chaves de [where.args] possuem os
  /// respectivos valores destas.
  ///
  /// Retorna um [DataDocument] vazio caso ocorra um erro ou não seja encontrada uma
  /// correspondência.
  Future<DataDocument> getDoc(
    DataWhere where,

    ///
    /// Se fornecido, o resultado de [onError] será retornado quando ocorrer um erro na solicitação.
    // {FutureOr<DataDocument> onError(Object error)?,}
  );

  /// Retorna o id do documento cuja referência é [ref].
  //String getDocId(ref);

  /// Salvar [data] se ainda não existir o documento [id] na coleção (ou tabrla) correspondente
  /// a [collection].
  /// Se [id] for `null`, será gerado um id automaticamente.
  Future<bool> setDocumentIfNotExist(
    CollectionType collection,
    Map<String, dynamic> data, {
    String? id,

    ///
    /// Se [onExist] não for `null`, seu resultado será retornado quando já existir o documento
    /// [id] em [collectionPath]. Por padrão o retorno é `false`.
    ///
    /// Se [onSuccess] não for `null`, será chamado quando o documento for inserido com exito.
    ///
    /// Se [onError] não for `null`, seu resultado será retornado quando ocorrer um erro na
    /// transação. Por padrão o retorno é `false`.
    /* FutureOr<bool> onExist()?,
    VoidCallback? onSuccess,
    FutureOr<bool> onError(Object error)?, */
  });
}

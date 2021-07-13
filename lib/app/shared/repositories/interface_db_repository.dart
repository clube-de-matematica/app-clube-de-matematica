import 'dart:async';
import 'dart:ui';

/// O tipo com os dados de um documento (ou campo) no banco de dados.
typedef DataDocument = Map<String, dynamic>;

/// O tipo com os dados de uma coleção (ou tabela) no banco de dados.
typedef DataCollection = List<DataDocument>;

/// O super tipo para repositórios de banco de dados remoto.
abstract class IRemoteDbRepository implements IDbRepository {}

/// O super tipo para repositórios de banco de dados local.
abstract class ILocalDbRepository implements IDbRepository {}

/// Deve ser implementada pelas classes que gerenciam a conexão com o banco de dados.
abstract class IDbRepository {
  /// O caminho para a coleção (ou tabela) de itens.
  String get pathItens;

  /// O caminho para a coleção (ou tabela) de assuntos.
  String get pathAssuntos;

  /// Retorna os dados da coleção [path] no banco de dados.
  ///
  /// Se fornecido, o resultado de [onError] será retornado quando ocorrer um erro na solicitação.
  Future<DataCollection> getCollection(
    String path, {
    FutureOr<DataCollection> onError(Object error)?,
  });

  /// Retorna os dados do documento [id] da coleção (ou tabela) [collectionPath] no banco de dados.
  ///
  /// Se fornecido, o resultado de [onError] será retornado quando ocorrer um erro na solicitação.
  Future<DataDocument> getDoc(
    String collectionPath,
    String id, {
    FutureOr<DataDocument> onError(Object error)?,
  });

  /// Retorna o id do documento cuja referência é [ref].
  String getDocId(ref);

  ///Salvar [data] se ainda não existir o documento [id] em [collectionPath].
  ///Se [id] for `null`, será gerado um id automaticamente.
  ///
  ///Se [onExist] não for `null`, seu resultado será retornado quando já existir o documento
  ///[id] em [collectionPath]. Por padrão o retorno é `false`.
  ///
  ///Se [onSuccess] não for `null`, será chamado quando o documento for inserido com exito.
  ///
  ///Se [onError] não for `null`, seu resultado será retornado quando ocorrer um erro na
  ///transação. Por padrão o retorno é `false`.
  Future<bool> setDocumentIfNotExist(
    String collectionPath,
    Map<String, dynamic> data, {
    String? id,
    FutureOr<bool> onExist()?,
    VoidCallback? onSuccess,
    FutureOr<bool> onError(Object error)?,
  });
}

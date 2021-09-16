import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart'; // TODO: Comentar antes de compilar para lançamento.
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/debug.dart';
import '../../models/exceptions/my_exception.dart';
import '../../utils/strings_db.dart';
import '../firebase/auth_repository.dart';
import '../interface_db_repository.dart';
import '../mixin_db_repository.dart';

part 'sqlite_repository_core.dart';
//part 'sqlite_repository_test.dart';

/// Fáz o gerenciamento do banco de dados SQLite.
///
/// O termo "codificado" é usado para dizer que os tipos não suportados pelo SQLite foram
/// convertidos para String usando [JsonCodec.encode].
class SqliteRepository
    with _SqliteRepositoryCore, DbRepositoryMixin
    implements ILocalDbRepository {
  static const _debugName = "SqliteRepository";

// O singleton está sendo implementado pelo pacote Modular.
/* 
  //Padrão singleton
  static SqliteRepository? _conexaoSQL;
  SqliteRepository._interno(this._authRepository);
  factory SqliteRepository(AuthRepository authRepository) {
    _conexaoSQL ??= SqliteRepository._interno(authRepository);
    return _conexaoSQL!;
  }
  //Fim da implementação do padrão singleton
*/
  SqliteRepository(AuthRepository authRepository)
      : _authRepository = authRepository;

  final AuthRepository _authRepository;

  /// Lançará uma exceção se não houver um usuário conectado.
  void _checkAuthentication(String memberName) {
    _authRepository.checkAuthentication(_debugName, memberName);
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* 
  @override
  Future<DataCollection> getCollection(CollectionType collection) async {
    assert(Debug.print("[INFO] Chamando $_debugName.getCollection..."));

    _checkAuthentication("getCollection()");
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados da visualização "${_getView(collection)}"...'));
      final result = await _dbRead(_getView(collection));
      return result.map((data) => _decode(data, collection)).toList();
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados da visualização "${_getView(collection)}".'));
      rethrow;
    }
  }

  @override
  Future<DataDocument> getDoc(DataWhere where) async {
    assert(Debug.print("[INFO] Chamando $_debugName.getDoc..."));

    _checkAuthentication("getDoc()");

    final collection = where.collection;
    final args = _encode(where.args, collection);
    try {
      assert(Debug.print(
          '[INFO] Solicitando os dados de "${_getView(collection)}" onde '
          '"${args.toString()}...'));
      final result = await _dbRead(
        _getView(collection),
        where: _where(args.keys.toList(), args.values.toList()),
        whereArgs: args.values.toList(),
        limit: 1,
      );
      return result.length == 1
          ? _decode(result[0], collection)
          : DataDocument();
    } catch (error) {
      assert(Debug.print(
          '[ERROR] Erro ao solicitar os dados de "${_getView(collection)}" onde '
          '"${args.toString()}.'));
      assert(Debug.printBetweenLine(error, ''));
      return DataDocument();
    }
  }

  @override
  Future<bool> setDocumentIfNotExist(
    CollectionType collection,
    Map<String, dynamic> data, {
    String? id,
  }) async {
    assert(Debug.print("[INFO] Chamando $_debugName.setDocumentIfNotExist..."));

    _checkAuthentication("setDocumentIfNotExist()");

    try {
      final bool inserted;
      switch (collection) {
        case CollectionType.assuntos:
          inserted = await _dbInsertIfNotExist(
              _kTbAssuntos, _encode(data, collection));
          break;
        case CollectionType.questoes:
          inserted = await _dbInsertItemIfNotExist(data);
          break;
      }
      return inserted;
    } catch (error) {
      assert(Debug.print('[ERROR] Não foi possível inserir o '
          '${collection == CollectionType.questoes ? "item" : "assunto"} $data.'));
      assert(Debug.printBetweenLine(error, ''));
      return false;
    }
  }
 */
////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* 
  /// Retorna o nome da visualização correspondente à [collection].
  String _getView(CollectionType collection) {
    switch (collection) {
      case CollectionType.assuntos:
        return _kViewAssuntos;
      case CollectionType.questoes:
        return _kViewAllItens;
    }
  }

  /// Recebe um objeto [DataQuestao] por meio de [data] e insere seus valores nas tabelas
  /// [_kTbItens] e [_kTbItensRef].
  Future<bool> _dbInsertItemIfNotExist(DataQuestao data) async {
    /// Verificar se o item referencia outro. Nesse caso, os dados serão inseridos apenas
    /// em `_kTbItensRef`.
    if (data.containsKey(DbConst.kDbDataQuestaoKeyReferencia)) {
      assert(data[DbConst.kDbDataQuestaoKeyReferencia] != null);
      final inserted = await _dbInsertIfNotExist(_kTbItensRef, data);
      return inserted;
    } else {
      final dataForTbItens = DataDocument();
      final dataForTbItensRef = DataDocument();

      /// Separar os dados para serem inseridos nas tabelas `_kTbItens` e `_kTbItensRef`.
      data.forEach((key, value) {
        if (key == DbConst.kDbDataQuestaoKeyId) {
          dataForTbItens[key] = value;
          dataForTbItensRef[key] = value;
          dataForTbItensRef[DbConst.kDbDataQuestaoKeyReferencia] = value;
        } else if (key == DbConst.kDbDataQuestaoKeyNivel ||
            key == DbConst.kDbDataQuestaoKeyIndice) {
          dataForTbItensRef[key] = value;
        } else {
          dataForTbItens[key] = value;
        }
      });
      final exist = await _exist(_kTbItensRef, [_kTbItensRefColId],
          [dataForTbItensRef[_kTbItensRefColId]]);
      if (!exist) {
        final inserted = await _dbInsertInTransaction({
          _kTbItens: _encode(dataForTbItens, CollectionType.questoes),
          _kTbItensRef: dataForTbItensRef,
        });
        return inserted;
      }
      return false;
    }
  } */

  /// Codifica os dados para serem inseridos no banco de dados.
  DataSQLite _encode(DataDocument data, CollectionType collection) {
    return data.map<String, Object?>(
      (key, value) => MapEntry(
        key,
        _isDataDocumentKeyOfUnsupportedValue(key, collection)
            ? json.encode(value)
            : value,
      ),
    );
  }

  /// Decodifica os dados retornados do banco de dados.
  DataDocument _decode(DataSQLite data, CollectionType collection) {
    final entries = data.entries
        // Descartar as entradas com valores nulos.
        .where((element) => element.value != null)
        // Decodificar os valores codificados para String.
        .map<MapEntry<String, dynamic>>(
          (e) => MapEntry(
            e.key,
            _isDataDocumentKeyOfUnsupportedValue(e.key, collection)
                ? json.decode(e.value as String)
                : e.value,
          ),
        );
    return Map.fromEntries(entries);
  }

  /// Retorna `true` se [key] corresponder a uma chave de [DataQuestao] ou [DataAssunto] cujo
  /// valor precisa ser codificado para String Json antes de ser inserido no banco de dados
  /// gerenciado pelo [Sqflite].
  bool _isDataDocumentKeyOfUnsupportedValue(
      String key, CollectionType collection) {
    switch (collection) {
      case CollectionType.questoes:
        return key == DbConst.kDbDataQuestaoKeyAlternativas ||
            key == DbConst.kDbDataQuestaoKeyAssuntos ||
            key == DbConst.kDbDataQuestaoKeyEnunciado ||
            key == DbConst.kDbDataQuestaoKeyImagensEnunciado;
      case CollectionType.assuntos:
        return key == DbConst.kDbDataAssuntoKeyHierarquia;
    }
  }

  @override
  Future<DataCollection> getAssuntos() {
    // TODO: implement getAssuntos
    throw UnimplementedError();
  }

  @override
  Future<DataCollection> getQuestoes() {
    // TODO: implement getQuestoes
    throw UnimplementedError();
  }

  @override
  Future<bool> setAssunto(DataDocument data) {
    // TODO: implement setAssunto
    throw UnimplementedError();
  }

  @override
  Future<bool> setQuestao(DataDocument data) {
    // TODO: implement setQuestao
    throw UnimplementedError();
  }
}

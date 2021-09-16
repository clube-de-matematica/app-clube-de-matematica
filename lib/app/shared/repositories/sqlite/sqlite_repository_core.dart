part of 'sqlite_repository.dart';

/// O objeto usado para definir ações a serem executadas dentro da tranzação [txn].
typedef _DbTansactionActions = Future<void> Function(Transaction txn);

/// O objeto [Map] usado pelo [Sqflite] nas operações com o banco de dados.
///
/// Os valores desse objeto devem estar codificados.
typedef DataSQLite = Map<String, Object?>;

/// Nome do arquivo de banco de dados para os itens.
const _kDbFileName = "clubedematematica.db";
const _tb_questao_x_assunto = 'questao_x_assunto';
const _tb_tipos_alternativa = '_tb_tipos_alternativa';
const _tb_alternativas = '_tb_alternativas';
const _tb_questoes_caderno = '_tb_questoes_caderno';

/// O objeto responsável pela manipulação do [Sqflite].
///
/// Os dados passados para os métodos [_dbInsertInTransaction], [_dbInsert] e [_dbUpdate]
/// devem estar codificados, isto é, os tipos não suportados devem estar como string json.
abstract class _SqliteRepositoryCore {
  /// Retorna assincronamente a instância do banco de dados.
  /// Caso o banco ainda não exista, ele será criado.
  Future<Database> get _dataBase async {
    final path = join(await getDatabasesPath(), _kDbFileName);
    try {
      assert(Debug.print('[INFO] Abrindo o banco de dados SQLite...'));
      return await openDatabase(
        path,
        version: 1,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] Não foi possível abrir o banco de dados SQLite.'));
      rethrow;
    }
  }

  /// Usado em [openDatabase].
  FutureOr<void> _onConfigure(Database db) async {
    assert(Debug.print('[INFO] Iniciando a configuração do banco de dados...'));
    // Habilitar a restrição de chave estrangeira.
    await db.execute('PRAGMA foreign_keys = ON;');
    assert(Debug.print('[INFO] Configuração concluída.'));
  }

  /// Usado em [openDatabase].
  FutureOr<void> _onCreate(Database db, int dbVercao) async {
    await db.transaction((txn) async {
      assert(Debug.print(
          '[INFO] Iniciando a tranzação de criação do esquema do banco de dados...'));
      await _createTbQuestoes(txn);
      await _createTbAssuntos(txn);
      await _createTbQuestaoAssunto(txn);
      await _createTbTiposAlternativa(txn);
      await _createTbAlternativa(txn);
      await _createTbQuestoesCaderno(txn);
      assert(Debug.print(
          '[INFO] Tranzação de criação do esquema do banco de dados concluída.'));
    });
  }

  /// Cria a tabela para os itens, caso ainda não exista.
  Future<void> _createTbQuestoes(Transaction txn) async {
    try {
      assert(Debug.print(
          '[INFO] Criando a tabela "${DbConst.kDbDataCollectionQuestoes}"...'));
      await txn.execute(
        'CREATE TABLE IF NOT EXISTS "${DbConst.kDbDataCollectionQuestoes}" ('
        '"${DbConst.kDbDataQuestaoKeyId}" INTEGER PRIMARY KEY NOT NULL, '
        '"${DbConst.kDbDataQuestaoKeyEnunciado}" TEXT NOT NULL, '
        '"${DbConst.kDbDataQuestaoKeyGabarito}" INTEGER NOT NULL, '
        '"${DbConst.kDbDataQuestaoKeyImagensEnunciado}" TEXT'
        '); ',
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] A tabela "${DbConst.kDbDataCollectionQuestoes}" não foi criada.'));
      rethrow;
    }
  }

  /// Cria a tabela para os assuntos, caso ainda não exista.
  Future<void> _createTbAssuntos(Transaction txn) async {
    try {
      assert(Debug.print(
          '[INFO] Criando a tabela "${DbConst.kDbDataCollectionAssuntos}"...'));
      await txn.execute(
        'CREATE TABLE IF NOT EXISTS "${DbConst.kDbDataCollectionAssuntos}" ('
        // O SQLite recomenda que não seja usado o atributo AUTOINCREMENT.
        '"${DbConst.kDbDataAssuntoKeyId}" INTEGER PRIMARY KEY NOT NULL ' /* AUTOINCREMENT */ ', '
        '"${DbConst.kDbDataAssuntoKeyTitulo}" TEXT NOT NULL, '
        '"${DbConst.kDbDataAssuntoKeyHierarquia}" TEXT DEFAULT NULL, '
        'UNIQUE ("${DbConst.kDbDataAssuntoKeyTitulo}", "${DbConst.kDbDataAssuntoKeyHierarquia}")'
        '); ',
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] A tabela "${DbConst.kDbDataCollectionAssuntos}" não foi criada.'));
      rethrow;
    }
  }

  /// Cria a tabela que faz o relacionamento muitos para muitos entre as tabelas
  /// [DbConst.kDbDataCollectionQuestoes] e [DbConst.kDbDataCollectionAssuntos].
  Future<void> _createTbQuestaoAssunto(Transaction txn) async {
    try {
      assert(
          Debug.print('[INFO] Criando a tabela "$_tb_questao_x_assunto"...'));
      await txn.execute(
        'CREATE TABLE "$_tb_questao_x_assunto" ('
        '"id_questao" INTEGER NOT NULL, '
        '"id_assunto" INTEGER NOT NULL, '
        'PRIMARY KEY ("id_questao", "id_assunto"), '
        'FOREIGN KEY ("id_questao") REFERENCES "${DbConst.kDbDataCollectionQuestoes}" ("${DbConst.kDbDataQuestaoKeyId}") ON DELETE CASCADE ON UPDATE CASCADE, '
        'FOREIGN KEY ("id_assunto") REFERENCES "${DbConst.kDbDataCollectionAssuntos}" ("${DbConst.kDbDataAssuntoKeyId}") ON DELETE RESTRICT ON UPDATE CASCADE'
        ');',
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] A tabela "$_tb_questao_x_assunto" não foi criada.'));
      rethrow;
    }
  }

  /// Cria a tabela para os tipos de alternativa disponíveis.
  Future<void> _createTbTiposAlternativa(Transaction txn) async {
    try {
      assert(
          Debug.print('[INFO] Criando a tabela "$_tb_tipos_alternativa"...'));
      await txn.execute(
        'CREATE TABLE "$_tb_tipos_alternativa" ('
        '"id" INTEGER PRIMARY KEY NOT NULL, '
        '"tipo" VARCHAR UNIQUE NOT NULL'
        ');',
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] A tabela "$_tb_tipos_alternativa" não foi criada.'));
      rethrow;
    }
  }

  /// Cria a tabela para as alternativas de resposta usadas nas questões.
  Future<void> _createTbAlternativa(Transaction txn) async {
    try {
      assert(Debug.print('[INFO] Criando a tabela "$_tb_alternativas"...'));
      await txn.execute(
        'CREATE TABLE "$_tb_alternativas" ('
        '"id_questao" INTEGER NOT NULL, '
        '"sequencial" INTEGER NOT NULL, '
        '"id_tipo" INTEGER NOT NULL, '
        '"conteudo" TEXT NOT NULL, '
        'PRIMARY KEY ("id_questao", "sequencial"), '
        'FOREIGN KEY ("id_questao") REFERENCES "${DbConst.kDbDataCollectionQuestoes}" ("${DbConst.kDbDataQuestaoKeyId}") ON DELETE CASCADE ON UPDATE CASCADE, '
        'FOREIGN KEY ("id_tipo") REFERENCES "$_tb_tipos_alternativa" ("id") ON DELETE RESTRICT ON UPDATE CASCADE'
        ');',
      );
    } catch (_) {
      assert(
          Debug.print('[ERROR] A tabela "$_tb_alternativas" não foi criada.'));
      rethrow;
    }
  }

  /// Cria a tabela que relaciona as questões por caderno. Se uma questão foi usada em mais
  /// de um caderno, nesta tabela ela possuirá um registro para cada um desses cadernos.
  Future<void> _createTbQuestoesCaderno(Transaction txn) async {
    try {
      assert(Debug.print('[INFO] Criando a tabela "$_tb_questoes_caderno"...'));
      await txn.execute(
        'CREATE TABLE "$_tb_questoes_caderno" ('
        '"id" VARCHAR PRIMARY KEY NOT NULL, '
        '"${DbConst.kDbDataQuestaoKeyAno}" INTEGER NOT NULL, '
        '"${DbConst.kDbDataQuestaoKeyNivel}" INTEGER NOT NULL, '
        '"${DbConst.kDbDataQuestaoKeyIndice}" INTEGER NOT NULL, '
        '"id_questao" INTEGER NOT NULL,'
        'FOREIGN KEY ("id_questao") REFERENCES "${DbConst.kDbDataCollectionQuestoes}" ("${DbConst.kDbDataQuestaoKeyId}") ON DELETE RESTRICT ON UPDATE CASCADE'
        ');',
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] A tabela "$_tb_questoes_caderno" não foi criada.'));
      rethrow;
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////
/* 
  /// Cria a tabela para as referências dos itens, caso ainda não exista.
  Future<void> _createTbItensRef(Transaction txn) async {
    try {
      assert(Debug.print('[INFO] Criando a tabela "$_kTbItensRef"...'));
      await txn.execute(
        'CREATE TABLE IF NOT EXISTS "$_kTbItensRef" ('
        '"$_kTbItensRefColId" VARCHAR PRIMARY KEY NOT NULL, '
        '"$_kTbItensRefColNivel" INTEGER NOT NULL, '
        '"$_kTbItensRefColIndice" INTEGER NOT NULL, '
        '"$_kTbItensRefColReferencia" VARCHAR NOT NULL, '
        'FOREIGN KEY("$_kTbItensRefColReferencia") REFERENCES "$_kTbItens"("${DbConst.kDbDataQuestaoKeyId}") ON DELETE RESTRICT'
        '); ',
      );
    } catch (_) {
      assert(Debug.print('[ERROR] A tabela "$_kTbItensRef" não foi criada.'));
      rethrow;
    }
  }

  /// Caso ainda não exista, cria a visualização para "consolidar" os dados dos itens.
  /// Esta visualização conterá um registro para cada aplicação do item. Isso significa
  /// que se o item foi aplicado em dois cadernos, possuirá um registro para cada um destes.
  Future<void> _createViewAllItens(Transaction txn) async {
    try {
      assert(Debug.print('[INFO] Criando a vizualização "$_kViewAllItens"...'));
      await txn.execute(
        'CREATE VIEW IF NOT EXISTS "$_kViewAllItens" AS '
        'SELECT '
        '"$_kTbItensRef"."$_kTbItensRefColId" AS "${DbConst.kDbDataQuestaoKeyId}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyAno}", '
        '"$_kTbItensRef"."$_kTbItensRefColNivel" AS "${DbConst.kDbDataQuestaoKeyNivel}", '
        '"$_kTbItensRef"."$_kTbItensRefColIndice" AS "${DbConst.kDbDataQuestaoKeyIndice}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyAssuntos}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyEnunciado}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyAlternativas}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyGabarito}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyDificuldade}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyImagensEnunciado}" '
        'FROM "$_kTbItensRef" '
        'INNER JOIN "$_kTbItens" ON "$_kTbItens"."${DbConst.kDbDataQuestaoKeyId}" = "$_kTbItensRef"."$_kTbItensRefColReferencia"'
        '; ',
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] A vizualização "$_kViewAllItens" não foi criada.'));
      rethrow;
    }
  }

  /// Caso ainda não exista, cria a visualização para "consolidar" os dados dos itens,
  /// excluindo-se os casos de reaplicação.
  /// Nesta visualização, mesmo que um item tenha sido aplicado em mais de um caderno,
  /// ele possuirá um único registro.
  Future<void> _createViewDistinctItens(Transaction txn) async {
    try {
      assert(Debug.print(
          '[INFO] Criando a vizualização "$_kViewDistinctItens"...'));
      await txn.execute(
        'CREATE VIEW IF NOT EXISTS "$_kViewDistinctItens" AS '
        'SELECT '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyId}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyAno}", '
        '"$_kTbItensRef"."$_kTbItensRefColNivel" AS "${DbConst.kDbDataQuestaoKeyNivel}", '
        '"$_kTbItensRef"."$_kTbItensRefColIndice" AS "${DbConst.kDbDataQuestaoKeyIndice}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyAssuntos}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyEnunciado}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyAlternativas}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyGabarito}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyDificuldade}", '
        '"$_kTbItens"."${DbConst.kDbDataQuestaoKeyImagensEnunciado}" '
        'FROM "$_kTbItens" '
        'INNER JOIN "$_kTbItensRef" ON "$_kTbItensRef"."$_kTbItensRefColId" = "$_kTbItens"."${DbConst.kDbDataQuestaoKeyId}"'
        '; ',
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] A vizualização "$_kViewDistinctItens" não foi criada.'));
      rethrow;
    }
  }

  /// Cria um gatilho para impedir a sobreposição acidental dos registros já
  /// inseridos na tabela de itens.
  Future<void> _createTriggerNotInsertInTbItens(Transaction txn) async {
    try {
      assert(Debug.print(
          '[INFO] Criando o gatilho "trigger_insert_in_tb_itens_if_not_exists"...'));
      await txn.execute(
        'CREATE TRIGGER "trigger_insert_in_tb_itens_if_not_exists" BEFORE INSERT ON "$_kTbItens" '
        'WHEN EXISTS (SELECT 1 FROM "$_kTbItens" WHERE "${DbConst.kDbDataQuestaoKeyId}" = NEW."${DbConst.kDbDataQuestaoKeyId}") '
        'BEGIN '
        'SELECT RAISE(ABORT,"A tabela $_kTbItens já possui um registro com o id fornecido."); '
        'END; ',
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] O gatilho "trigger_insert_in_tb_itens_if_not_exists" não foi criado.'));
      rethrow;
    }
  }

  /// Cria a tabela para os assuntos, caso ainda não exista.
  Future<void> _createTbClubes(Transaction txn) async {
    try {
      assert(Debug.print(
          '[INFO] Criando a tabela "${DbConst.kDbDataCollectionAssuntos}"...'));
      await txn.execute(
        'CREATE TABLE IF NOT EXISTS "${DbConst.kDbDataCollectionAssuntos}" ('
        // O SQLite recomenda que não seja usado o atributo AUTOINCREMENT.
        '"$_kTbAssuntosColId" INTEGER PRIMARY KEY NOT NULL ' /* AUTOINCREMENT */ ', '
        '"${DbConst.kDbDataAssuntoKeyTitulo}" TEXT NOT NULL, '
        '"${DbConst.kDbDataAssuntoKeyHierarquia}" TEXT'
        '); ',
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] A tabela "${DbConst.kDbDataCollectionAssuntos}" não foi criada.'));
      rethrow;
    }
  } */

  /// Cria uma tranzaçao para inserir os dados dos valores de [keyTableValueData].
  /// As chaves de [keyTableValueData] devem conter o nome da tabela na qual os dados do seu
  /// valor devem ser inseridos. Esses dados já devem estar codificatos.
  Future<bool> _dbInsertInTransaction(
      Map<String, DataSQLite> keyTableValueData) async {
    assert(keyTableValueData.isNotEmpty);
    if (keyTableValueData.isEmpty) {
      return false;
    } else {
      final _db = await _dataBase;
      try {
        assert(Debug.print(
            '[INFO] Iniciando uma tranzação para inserir registros...'));
        final result = await _db.transaction<bool>((txn) async {
          keyTableValueData.forEach((table, values) async {
            if (!_isTableName(table)) {
              assert(Debug.print('[ERROR] "$table" não é um nome de tabela.'));
              // Isso fará com que a tranzação desfaça as alterações já realizadas.
              throw MyException('"$table" não é um nome de tabela.');
            } else {
              final id = await txn.insert(
                table,
                values,
                conflictAlgorithm: ConflictAlgorithm.rollback,
              );
              if (id == 0) {
                assert(Debug.print(
                    '[ERROR] O registro não foi inserido em "$table". \n'
                    'Dados do registro: \n${values.toString()}'));
                // Isso fará com que a tranzação desfaça as alterações já realizadas.
                throw MyException('O registro não foi inserido em "$table".');
              }
            }
          });
          return true;
        });
        return result;
      } on MyException catch (_) {
        assert(Debug.print('[ERROR] A tranzação foi cancelada.'));
        return false;
      } catch (_) {
        assert(Debug.print('[ERROR] A tranzação foi cancelada.'));
        rethrow;
      }
    }
  }

  /// Retorna `true` se [name] é o nome de uma tabela.
  bool _isTableName(String name) {
    return [
      DbConst.kDbDataCollectionAssuntos,
      DbConst.kDbDataCollectionQuestoes,
      _tb_alternativas,
      _tb_questao_x_assunto,
      _tb_questoes_caderno,
      _tb_tipos_alternativa,
    ].contains(name);
  }

  /// Retorna `true` se [name] é o nome de uma visualização.
  bool _isViewName(String name) {
    return [].contains(name);
  }

  /// Se ainda não existir, insere [values] na tabela [table].
  /// [values] já deve estar codificado.
  Future<bool> _dbInsertIfNotExist(String table, DataSQLite values) async {
    assert(_isTableName(table));
    /* if (_isTableName(table)) {
      Future<bool> Function() exist;
      if (table == DbConst.kDbDataCollectionAssuntos) {
        exist = () async =>
            await _exist(table, values.keys.toList(), values.values.toList());
      } else {
        String? colId;
        if (table == _kTbItens) {
          colId = DbConst.kDbDataQuestaoKeyId;
        } else if (table == _kTbItensRef) {
          colId = _kTbItensRefColId;
        }
        exist = () async => await _exist(table, [colId!], [values[colId]]);
      }
      if (!(await exist())) {
        final _id = await _dbInsert(table, values);
        if (_id > 0) {
          return await exist();
        }
      }
    } */
    return false;
  }

  /// Insere [values] na tabela [table].
  /// [values] já deve estar codificado.
  Future<int> _dbInsert(String table, DataSQLite values) async {
    final _db = await _dataBase;
    return await _db.insert(table, values,
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  /// Retorna assincronamente uma lista com o resuldado de uma consulta ainda codificado.
  /// Retorna uma lista vazia se a consulta não encontrar nenhuma correspondência.
  Future<List<DataSQLite>> _dbRead(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    assert(_isTableName(table) || _isViewName(table));
    final _db = await _dataBase;
    return await _db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /* Future<void> _dbDelete(
    String tabela,
    String where,
    List whereArgs,
  ) async {
    //db.then((value) => value.delete(tabela, where: where, whereArgs: whereArgs));
  }

  /// [dados] já deve estar codificado
  Future<void> _dbUpdate(
    DataSQLite dados,
    String where,
    List whereArgs,
  ) async {
    //db.then((value) => value.update(_TB_QUESTOES_1, dados, where: where, whereArgs: whereArgs));
  } */

  /// Retorna a string usada pelo parâmetro `where` de [_dbRead].
  /// A string terá um `?` para cada elemento de [values].
  String _where(List<String> columns, List<Object?> values) {
    assert(columns.isNotEmpty && values.isNotEmpty);
    assert(columns.length == values.length);
    String where = '';
    for (var i = 0; i < columns.length; i++) {
      if (where.isNotEmpty) where += ' AND ';
      where += '"${columns[i]}" ' + (values[i] == null ? 'IS ?' : '= ?');
    }
    return where;
  }

  /// Retorna `true` se existir algum registro com o valor em [values] no respectivo campo
  /// em [columns] da tabela [table].
  Future<bool> _exist(
      String table, List<String> columns, List<Object?> values) async {
    Debug.print('[INFO] Verificando se o registro existe...');
    try {
      final searchResult = await _dbRead(
        table,
        where: _where(columns, values),
        whereArgs: values,
        limit: 1,
      );
      return searchResult.isNotEmpty;
    } catch (error) {
      assert(Debug.print(
          '[ERROR] Erro ao verificar a existência de um registro em "$table" '
          'onde \n${columns.toString().replaceAll(',', ',\n')} \ncorresponde a '
          '${values.toString().replaceAll(',', ',\n')}.'));
      assert(Debug.printBetweenLine(error, ''));
      return false;
    }
  }
}

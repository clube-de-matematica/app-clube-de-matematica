part of 'sqlite_repository.dart';

/// O objeto usado para definir ações a serem executadas dentro da tranzação [txn].
typedef _DbTansactionActions = Future<void> Function(Transaction txn);

/// O objeto [Map] usado pelo [Sqflite] nas operações com o banco de dados.
///
/// Os valores desse objeto devem estar codificados.
typedef DataSQLite = Map<String, Object?>;

/// Nome do arquivo de banco de dados para os itens.
const _kDbFileName = "clubedematematica.db";

/// Nome da tabela que contém os assuntos ligados a cada item.
const _kTbAssuntos = DbConst.kDbDataCollectionAssuntos;

/// Chave primária. Osvalores são gerados pelo próprio banco de dados.
const _kTbAssuntosColId = "id";

/// Nome da tabela que contém os itens.
const _kTbItens = DbConst.kDbDataCollectionItens;

/// Nome da tabela que relaciona os itens por caderno com a tabela de itens
/// [DbConst.kDbDataCollectionItens].
///
/// Se um item foi usado em mais de um caderno, nesta tabela ele possuirá uma entrada para
/// cada um desses cadernos.
const _kTbItensRef = "tb_itens_ref";

/// Nome da coluna para o ID do item.
/// Os valores desta coluna são do tipo `VARCHAR` e estão no formato `2019PF1N1Q01`, onde:
/// * 2019 é o ano de aplicação da prova;
/// * PF1 indica que a prova é da primeira fase;
/// * N1 indica que a prova é do nível 1;
/// * Q01 indica que trata-se do primeiro item do caderno.
/// Esta coluna é uma chave primária.
const _kTbItensRefColId = "id";

/// Nome do campo para o número do item (questão) no caderno de prova. Os valores
/// para esse campo são do tipo [int].
const _kTbItensRefColIndice = DbConst.kDbDataItemKeyIndice;

/// Nome do campo para o nível da prova da OBMEP. Os valores para esse campo são do
/// tipo [int].
const _kTbItensRefColNivel = DbConst.kDbDataItemKeyNivel;

/// Chave estrangeira para a coluna [DbConst.kDbDataItemKeyId] da tabela [_kTbItens].
const _kTbItensRefColReferencia = DbConst.kDbDataItemKeyReferencia;

/// Nome da tabela que contém os clubes.
const _kTbClubes = DbConst.kDbDataCollectionClubes;

/// Nome da tabela que contém os tarefas.
const _kTbTarefas = DbConst.kDbDataCollectionTarefas;

/// Nome da View que relaciona os dados das tabelas [_kTbItensRef] e [_kTbItens].
/// Esta visualização conterá um registro para cada aplicação do item. Isso significa que
/// se o item foi aplicado em dois cadernos, possuirá um registro para cada um destes.
/// Criada para facilitar as consultas de dados.
const _kViewAllItens = "view_all_itens";

/// Nome da View que relaciona os dados das tabelas [_kTbItens] e [_kTbItensRef].
/// Nessta visualização, mesmo que um item tenha sido aplicado em mais de um caderno, ele
/// possuirá um único registro.
/// Criada para facilitar as consultas de dados.
const _kViewDistinctItens = "view_distinct_itens";

/// Nome da visualização para a tabela [_kTbAssuntos].
const _kViewAssuntos = 'view_assuntos';

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
      await _createTbAssuntos(txn);
      await _createViewAssuntos(txn);
      await _createTbItens(txn);
      await _createTbItensRef(txn);
      await _createViewAllItens(txn);
      await _createViewDistinctItens(txn);
      await _createTriggerNotInsertInTbItens(txn);
      await _createTbClubes(txn);
      assert(Debug.print(
          '[INFO] Tranzação de criação do esquema do banco de dados concluída.'));
    });
  }

  /// Cria a tabela para os assuntos, caso ainda não exista.
  Future<void> _createTbAssuntos(Transaction txn) async {
    try {
      assert(Debug.print('[INFO] Criando a tabela "$_kTbAssuntos"...'));
      await txn.execute(
        'CREATE TABLE IF NOT EXISTS "$_kTbAssuntos" ('
        // O SQLite recomenda que não seja usado o atributo AUTOINCREMENT.
        '"$_kTbAssuntosColId" INTEGER PRIMARY KEY NOT NULL ' /* AUTOINCREMENT */ ', '
        '"${DbConst.kDbDataAssuntoKeyTitulo}" TEXT NOT NULL, '
        '"${DbConst.kDbDataAssuntoKeyArvore}" TEXT'
        '); ',
      );
    } catch (_) {
      assert(Debug.print('[ERROR] A tabela "$_kTbAssuntos" não foi criada.'));
      rethrow;
    }
  }

  /// Caso ainda não exista, cria a visualização para "consolidar" os dados dos assuntos.
  Future<void> _createViewAssuntos(Transaction txn) async {
    try {
      assert(Debug.print('[INFO] Criando a vizualização "$_kViewAssuntos"...'));
      await txn.execute(
        'CREATE VIEW IF NOT EXISTS "$_kViewAssuntos" AS '
        'SELECT '
        //'"$_kTbAssuntosColId", '
        '"${DbConst.kDbDataAssuntoKeyTitulo}", '
        '"${DbConst.kDbDataAssuntoKeyArvore}" '
        'FROM "$_kTbAssuntos" '
        'ORDER BY '
        // Concatenar o título do assunto ao final da árvore para fazer a ordenação.
        '("${DbConst.kDbDataAssuntoKeyArvore}" || \'/\' '
        '|| "${DbConst.kDbDataAssuntoKeyTitulo}") ASC, '
        // Se a árvore for nula, a concatenação também será nula. Nesse caso, o título do
        // assunto permitirá a ordenação desses valores nulos.
        '"${DbConst.kDbDataAssuntoKeyTitulo}" ASC'
        '; ',
      );
    } catch (_) {
      assert(Debug.print(
          '[ERROR] A vizualização "$_kViewAssuntos" não foi criada.'));
      rethrow;
    }
  }

  /// Cria a tabela para os itens, caso ainda não exista.
  Future<void> _createTbItens(Transaction txn) async {
    try {
      assert(Debug.print('[INFO] Criando a tabela "$_kTbItens"...'));
      await txn.execute(
        'CREATE TABLE IF NOT EXISTS "$_kTbItens" ('
        '"${DbConst.kDbDataItemKeyId}" VARCHAR PRIMARY KEY NOT NULL, '
        '"${DbConst.kDbDataItemKeyAno}" INTEGER NOT NULL, '
        '"${DbConst.kDbDataItemKeyAssuntos}" VARCHAR NOT NULL, '
        '"${DbConst.kDbDataItemKeyEnunciado}" TEXT NOT NULL, '
        '"${DbConst.kDbDataItemKeyAlternativas}" TEXT NOT NULL, '
        '"${DbConst.kDbDataItemKeyGabarito}" VARCHAR NOT NULL, '
        '"${DbConst.kDbDataItemKeyDificuldade}" VARCHAR NOT NULL, '
        '"${DbConst.kDbDataItemKeyImagensEnunciado}" TEXT'
        '); ',
      );
    } catch (_) {
      assert(Debug.print('[ERROR] A tabela "$_kTbItens" não foi criada.'));
      rethrow;
    }
  }

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
        'FOREIGN KEY("$_kTbItensRefColReferencia") REFERENCES "$_kTbItens"("${DbConst.kDbDataItemKeyId}") ON DELETE RESTRICT'
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
        '"$_kTbItensRef"."$_kTbItensRefColId" AS "${DbConst.kDbDataItemKeyId}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyAno}", '
        '"$_kTbItensRef"."$_kTbItensRefColNivel" AS "${DbConst.kDbDataItemKeyNivel}", '
        '"$_kTbItensRef"."$_kTbItensRefColIndice" AS "${DbConst.kDbDataItemKeyIndice}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyAssuntos}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyEnunciado}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyAlternativas}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyGabarito}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyDificuldade}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyImagensEnunciado}" '
        'FROM "$_kTbItensRef" '
        'INNER JOIN "$_kTbItens" ON "$_kTbItens"."${DbConst.kDbDataItemKeyId}" = "$_kTbItensRef"."$_kTbItensRefColReferencia"'
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
        '"$_kTbItens"."${DbConst.kDbDataItemKeyId}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyAno}", '
        '"$_kTbItensRef"."$_kTbItensRefColNivel" AS "${DbConst.kDbDataItemKeyNivel}", '
        '"$_kTbItensRef"."$_kTbItensRefColIndice" AS "${DbConst.kDbDataItemKeyIndice}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyAssuntos}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyEnunciado}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyAlternativas}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyGabarito}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyDificuldade}", '
        '"$_kTbItens"."${DbConst.kDbDataItemKeyImagensEnunciado}" '
        'FROM "$_kTbItens" '
        'INNER JOIN "$_kTbItensRef" ON "$_kTbItensRef"."$_kTbItensRefColId" = "$_kTbItens"."${DbConst.kDbDataItemKeyId}"'
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
        'WHEN EXISTS (SELECT 1 FROM "$_kTbItens" WHERE "${DbConst.kDbDataItemKeyId}" = NEW."${DbConst.kDbDataItemKeyId}") '
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
      assert(Debug.print('[INFO] Criando a tabela "$_kTbAssuntos"...'));
      await txn.execute(
        'CREATE TABLE IF NOT EXISTS "$_kTbAssuntos" ('
        // O SQLite recomenda que não seja usado o atributo AUTOINCREMENT.
        '"$_kTbAssuntosColId" INTEGER PRIMARY KEY NOT NULL ' /* AUTOINCREMENT */ ', '
        '"${DbConst.kDbDataAssuntoKeyTitulo}" TEXT NOT NULL, '
        '"${DbConst.kDbDataAssuntoKeyArvore}" TEXT'
        '); ',
      );
    } catch (_) {
      assert(Debug.print('[ERROR] A tabela "$_kTbAssuntos" não foi criada.'));
      rethrow;
    }
  }

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
    return name == _kTbAssuntos || name == _kTbItens || name == _kTbItensRef;
  }

  /// Retorna `true` se [name] é o nome de uma visualização.
  bool _isViewName(String name) {
    return name == _kViewAssuntos ||
        name == _kViewAllItens ||
        name == _kViewDistinctItens;
  }

  /// Se ainda não existir, insere [values] na tabela [table].
  /// [values] já deve estar codificado.
  Future<bool> _dbInsertIfNotExist(String table, DataSQLite values) async {
    assert(_isTableName(table));
    if (_isTableName(table)) {
      Future<bool> Function() exist;
      if (table == _kTbAssuntos) {
        exist = () async =>
            await _exist(table, values.keys.toList(), values.values.toList());
      } else {
        String? colId;
        if (table == _kTbItens) {
          colId = DbConst.kDbDataItemKeyId;
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
    }
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

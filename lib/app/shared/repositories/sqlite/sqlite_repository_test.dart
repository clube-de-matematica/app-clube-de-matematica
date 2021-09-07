part of 'sqlite_repository.dart';

// TODO: Comentar todo o código abaixo antes de compilar para lançamento.
class _SqliteRepositoryTest extends SqliteRepository {
  _SqliteRepositoryTest(AuthRepository authRepository) : super(authRepository);

  /// Se [actions] é vazia, [_dataBase] usará [_onCreate].
  final List<_DbTansactionActions> actions = <_DbTansactionActions>[];
  Database? _dbCach;

  Future<bool> _dbCloseAndDelete() async {
    if (_dbCach != null) {
      await _dbCach!.close();
      final _path = _dbCach!.path;
      if (await File(_path).exists()) {
        await File(_path).delete();
        assert(!(await File(_path).exists()));
      }
    }
    return true;
  }

  /// A cada chamada, Retorna assincronamente um novo [Database] no diretório de cache.
  Future<Database> get _dataBase async {
    final _path =
        join((await getTemporaryDirectory()).path, 'clubedematemática.db'
            /* Random.secure().hashCode.toString() + '.db' */);
    return _dbCach ??= await openDatabase(
      _path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  /// Executa apenas os comandos incluídos nas funções armazenadas em [actions].
  @override
  FutureOr<void> _onCreate(Database db, int dbVercao) async {
    if (actions.isEmpty) return super._onCreate(db, dbVercao);
    return await db.transaction((txn) async {
      for (var action in actions) {
        await action(txn);
      }
    });
  }

  /// Listar o nome das entidades criadas no banco de dados.
  Future<List<String>> tablesNames() async {
    final _db = await _dataBase;
    final tables = await _db.query(
      'sqlite_master', /*  where: 'type = ?', whereArgs: ['table'] */
    );
    return tables.map((row) => row['name'] as String).toList();
  }

  /// Retorna `true` se a tabela [_kTbAssuntos] for criada.
  Future<bool> testCreateTbAssuntos() async {
    Debug.print('[TEST] Testando a criação da tabela "$_kTbAssuntos"...');
    actions
      ..clear()
      ..add((txn) => _createTbAssuntos(txn));
    final tables = await tablesNames();
    final result = tables.contains(_kTbAssuntos);
    Debug.print(
        '[TEST]${result ? "" : "[FAIL]"} A tabela ${result ? "" : "não "}foi criada.');
    assert(await _dbCloseAndDelete());
    return result;
  }

  /// Retorna `true` se a visualização [_kViewAssuntos] for criada.
  Future<bool> testCreateViewAssuntos() async {
    Debug.print(
        '[TEST] Testando a criação da visualização "$_kViewAssuntos"...');
    actions
      ..clear()
      ..add((txn) => _createTbAssuntos(txn))
      ..add((txn) => _createViewAssuntos(txn));
    final tables = await tablesNames();
    final result = tables.contains(_kViewAssuntos);
    Debug.print(
        '[TEST]${result ? "" : "[FAIL]"} A visualização ${result ? "" : "não "}foi criada.');
    assert(await _dbCloseAndDelete());
    return result;
  }

  /// Retorna `true` se a tabela [_kTbItens] for criada.
  Future<bool> testCreateTbItens() async {
    Debug.print('[TEST] Testando a criação da tabela "$_kTbItens"...');
    actions
      ..clear()
      ..add((txn) => _createTbItens(txn));
    final tables = await tablesNames();
    final result = tables.contains(_kTbItens);
    Debug.print(
        '[TEST]${result ? "" : "[FAIL]"} A tabela ${result ? "" : "não "}foi criada.');
    assert(await _dbCloseAndDelete());
    return result;
  }

  /// Retorna `true` se a tabela [_kTbItensRef] for criada.
  Future<bool> testCreateTbItensRef() async {
    Debug.print('[TEST] Testando a criação da tabela "$_kTbItensRef"...');
    actions
      ..clear()
      ..add((txn) => _createTbItens(txn))
      ..add((txn) => _createTbItensRef(txn));
    final tables = await tablesNames();
    final result = tables.contains(_kTbItensRef);
    Debug.print(
        '[TEST]${result ? "" : "[FAIL]"} A tabela ${result ? "" : "não "}foi criada.');
    assert(await _dbCloseAndDelete());
    return result;
  }

  /// Retorna `true` se a visualização [_kViewDistinctItens] for criada.
  Future<bool> testCreateViewDistinctItens() async {
    Debug.print(
        '[TEST] Testando a criação da visualização "$_kViewDistinctItens"...');
    actions
      ..clear()
      ..add((txn) => _createTbItens(txn))
      ..add((txn) => _createTbItensRef(txn))
      ..add((txn) => _createViewDistinctItens(txn));
    final tables = await tablesNames();
    final result = tables.contains(_kViewDistinctItens);
    Debug.print(
        '[TEST]${result ? "" : "[FAIL]"} A visualização ${result ? "" : "não "}foi criada.');
    assert(await _dbCloseAndDelete());
    return result;
  }

  /// Retorna `true` se a visualização [_kViewAllItens] for criada.
  Future<bool> testCreateViewAllItens() async {
    Debug.print(
        '[TEST] Testando a criação da visualização "$_kViewAllItens"...');
    actions
      ..clear()
      ..add((txn) => _createTbItens(txn))
      ..add((txn) => _createTbItensRef(txn))
      ..add((txn) => _createViewAllItens(txn));
    final tables = await tablesNames();
    final result = tables.contains(_kViewAllItens);
    Debug.print(
        '[TEST]${result ? "" : "[FAIL]"} A visualização ${result ? "" : "não "}foi criada.');
    assert(await _dbCloseAndDelete());
    return result;
  }

  /// Retorna um [DataDocument] de um item que não faz referência a outro item.
  DataDocument item1() => {
        DbConst.kDbDataQuestaoKeyId: '2019pf1n1q01',
        DbConst.kDbDataQuestaoKeyAno: 2019,
        DbConst.kDbDataQuestaoKeyNivel: 1,
        DbConst.kDbDataQuestaoKeyIndice: 1,
        DbConst.kDbDataQuestaoKeyAssuntos: ['Área', 'Regra de três'],
        DbConst.kDbDataQuestaoKeyEnunciado: [
          'Primeira parte ',
          '##ml##',
          'segunda parte'
        ],
        DbConst.kDbDataQuestaoKeyAlternativas: [
          {
            DbConst.kDbDataAlternativaKeySequencial: 'a',
            DbConst.kDbDataAlternativaKeyTipo:
                DbConst.kDbDataAlternativaKeyTipoValTexto,
            DbConst.kDbDataAlternativaKeyConteudo: 'Alternativa "A".'
          },
          {
            DbConst.kDbDataAlternativaKeySequencial: 'b',
            DbConst.kDbDataAlternativaKeyTipo:
                DbConst.kDbDataAlternativaKeyTipoValTexto,
            DbConst.kDbDataAlternativaKeyConteudo: 'Alternativa "B".'
          },
          {
            DbConst.kDbDataAlternativaKeySequencial: 'c',
            DbConst.kDbDataAlternativaKeyTipo:
                DbConst.kDbDataAlternativaKeyTipoValTexto,
            DbConst.kDbDataAlternativaKeyConteudo: 'Alternativa "C".'
          },
          {
            DbConst.kDbDataAlternativaKeySequencial: 'd',
            DbConst.kDbDataAlternativaKeyTipo:
                DbConst.kDbDataAlternativaKeyTipoValTexto,
            DbConst.kDbDataAlternativaKeyConteudo: 'Alternativa "D".'
          },
          {
            DbConst.kDbDataAlternativaKeySequencial: 'e',
            DbConst.kDbDataAlternativaKeyTipo:
                DbConst.kDbDataAlternativaKeyTipoValTexto,
            DbConst.kDbDataAlternativaKeyConteudo: 'Alternativa "E".'
          }
        ],
        DbConst.kDbDataQuestaoKeyGabarito: 'a',
        DbConst.kDbDataQuestaoKeyDificuldade:
            DbConst.kDbDataQuestaoKeyDificuldadeValBaixa,
        DbConst.kDbDataQuestaoKeyImagensEnunciado: [
          {
            DbConst.kDbDataImagemKeyBase64: '2019PF1N1Q01.PNG',
            DbConst.kDbDataImagemKeyAltura: 300,
            DbConst.kDbDataImagemKeyLargura: 200
          }
        ]
      };

  /// Retorna `true` se o retorno de [item1] for inserido.
  Future<bool> testInsertItem1() async {
    Debug.print('[TEST] Testando inserção de "_SqliteRepositoryTest.item1"...');
    bool result = false;
    final item = item1();
    final inserted = await setDocumentIfNotExist(CollectionType.questoes, item);
    if (inserted) {
      final where = DataWhere(
        CollectionType.questoes,
        {DbConst.kDbDataQuestaoKeyId: item[DbConst.kDbDataQuestaoKeyId]},
      );
      final returned = await getDoc(where);
      result = DeepCollectionEquality().equals(returned, item);
    }
    Debug.print(
        '[TEST]${result ? "" : "[FAIL]"} O registro ${result ? "" : "não "}foi inserido.');
    assert(await _dbCloseAndDelete());
    return result;
  }

  /// Retorna um [DataDocument] de um item que não faz referência a outro item.
  DataDocument item2() {
    return item1()
      ..remove(DbConst.kDbDataQuestaoKeyImagensEnunciado)
      ..addAll({
        DbConst.kDbDataQuestaoKeyId: '2020pf1n1q01',
        DbConst.kDbDataQuestaoKeyAno: 2020,
        DbConst.kDbDataQuestaoKeyAssuntos: ['Divisibilidade']
      });
  }

  /// Retorna um [DataDocument] de um item que faz referência ao [item1].
  DataDocument item3() => {
        DbConst.kDbDataQuestaoKeyId: '2019pf1n2q04',
        DbConst.kDbDataQuestaoKeyNivel: 2,
        DbConst.kDbDataQuestaoKeyIndice: 4,
        DbConst.kDbDataQuestaoKeyReferencia: '2019pf1n1q01'
      };

  /// Retorna `true` se não for possível inserir o retorno de [item3] antes do de [item1],
  /// pois o primeiro faz referência ao segundo.
  Future<bool> testInsertItem3BeforeItem1() async {
    Debug.print(
      '[TEST] Testando inserção de um item que faz referêcia a outro antes desse outro '
      'ser inserido: "_SqliteRepositoryTest.item3" antes de "_SqliteRepositoryTest.item1"...',
    );
    final item = item3();
    assert(!(await _exist(
      _kTbItens,
      [DbConst.kDbDataQuestaoKeyId],
      [item[_kTbItensRefColReferencia]],
    )));
    final inserted = await setDocumentIfNotExist(CollectionType.questoes, item);
    bool result = !inserted;
    if (inserted) {
      final where = DataWhere(
        CollectionType.questoes,
        {DbConst.kDbDataQuestaoKeyId: item[DbConst.kDbDataQuestaoKeyId]},
      );
      final returned = await getDoc(where);
      result = !(DeepCollectionEquality().equals(returned, item));
    }
    Debug.print(
        '[TEST]${result ? "" : "[FAIL]"} O registro ${result ? "não " : ""}foi '
        'inserido antes do que é referenciado por ele.');
    assert(await _dbCloseAndDelete());
    return result;
  }

  /// Retorna `true` se o retorno de [item1], [item2] e [item3] for inserido.
  Future<bool> testInsertThreeItens() async {
    Debug.print(
        '[TEST] Testando inserção do item "_SqliteRepositoryTest.item3" que faz '
        'referêcia ao item "_SqliteRepositoryTest.item1"...');
    bool result = false;
    final _item1 = item1();
    final _item2 = item2();
    final _item3 = item3();
    if (await setDocumentIfNotExist(CollectionType.questoes, _item1)) {
      if (await setDocumentIfNotExist(CollectionType.questoes, _item2)) {
        if (await setDocumentIfNotExist(CollectionType.questoes, _item3)) {
          final returned = await getCollection(CollectionType.questoes);
          result = returned.length == 3;
        }
      }
    }
    Debug.print(
        '[TEST]${result ? "" : "[FAIL]"} O registro ${result ? "" : "não "}foi inserido.');
    assert(await _dbCloseAndDelete());
    return result;
  }

  /// Retorna um [DataDocument] de um assunto que não é uma unidade.
  DataDocument assunto1() => {
        DbConst.kDbDataAssuntoKeyTitulo: 'Área',
        DbConst.kDbDataAssuntoKeyHierarquia: ['Geometria', 'Polígonos']
      };

  /// Retorna `true` se o retorno de [assunto1] for inserido.
  Future<bool> testInsertAssunto1() async {
    Debug.print(
        'Testando inserção de um assunto com unidade: "_SqliteRepositoryTest.assunto1"...');
    bool result = false;
    final assunto = assunto1();
    final inserted =
        await setDocumentIfNotExist(CollectionType.assuntos, assunto);
    if (inserted) {
      final where = DataWhere(CollectionType.assuntos, assunto);
      final returned = await getDoc(where);
      result = DeepCollectionEquality().equals(returned, assunto);
    }
    Debug.print('O registro ${result ? "" : "não "}foi inserido.');
    assert(await _dbCloseAndDelete());
    return result;
  }

  /// Retorna um [DataDocument] de um assunto que não é uma unidade.
  DataDocument assunto2() => {
        DbConst.kDbDataAssuntoKeyTitulo: 'Regra de três',
        DbConst.kDbDataAssuntoKeyHierarquia: [
          'Matemática financeira',
          'Proporcionalidade'
        ]
      };

  /// Retorna um [DataDocument] de um assunto que é uma unidade.
  DataDocument assunto3() => {DbConst.kDbDataAssuntoKeyTitulo: 'Aritmética'};

  /// Retorna `true` se o retorno de [assunto3] for inserido.
  Future<bool> testInsertAssunto3() async {
    Debug.print(
        'Testando inserção de um assunto sem unidade: "_SqliteRepositoryTest.assunto3"...');
    bool result = false;
    final assunto = assunto3();
    final inserted =
        await setDocumentIfNotExist(CollectionType.assuntos, assunto);
    if (inserted) {
      final where = DataWhere(CollectionType.assuntos, assunto);
      final returned = await getDoc(where);
      result = DeepCollectionEquality().equals(returned, assunto);
    }
    Debug.print('O registro ${result ? "" : "não "}foi inserido.');
    assert(await _dbCloseAndDelete());
    return result;
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

/// Usado para executar um aplicativo simples e testar o banco de dados.
/// Não foi possível realizar testes de unidade, por isso este mecanismo.
Future<void> testSqliteRepository() async {
  final a = _kSQL;
  runZonedGuarded(() async {
    assert(Debug.call(() async {
      // Inicializar o Flutter.
      WidgetsFlutterBinding.ensureInitialized();
      // Inicializar o Firebase.
      await Firebase.initializeApp();
      final auth = AuthRepository(FirebaseAuth.instance);
      // Gerar uma autenticação.
      await auth.signInAnonymously();
      assert(auth.connected);

      Debug.printBetweenLine("TESTANDO O BANCO DE DADOS LOCAL...");
      assert(
        await _SqliteRepositoryTest(auth).testCreateTbAssuntos(),
        'A tablela "$_kTbAssuntos" não foi criada.',
      );
      assert(
        await _SqliteRepositoryTest(auth).testCreateViewAssuntos(),
        'A visualização "$_kViewAssuntos" não foi criada.',
      );
      assert(
        await _SqliteRepositoryTest(auth).testCreateTbItens(),
        'A tablela "$_kTbItens" não foi criada.',
      );
      assert(
        await _SqliteRepositoryTest(auth).testCreateTbItensRef(),
        'A tablela "$_kTbItensRef" não foi criada.',
      );
      assert(
        await _SqliteRepositoryTest(auth).testCreateViewDistinctItens(),
        'A visualização "$_kViewDistinctItens" não foi criada.',
      );
      assert(
        await _SqliteRepositoryTest(auth).testCreateViewAllItens(),
        'A visualização "$_kViewAllItens" não foi criada.',
      );
      assert(
        await _SqliteRepositoryTest(auth).testInsertItem1(),
        'O item retornado por "_SqliteRepositoryTest.item1" não foi inserido.',
      );

      assert(
        await _SqliteRepositoryTest(auth).testInsertItem3BeforeItem1(),
        'A inserção do retorno de "_SqliteRepositoryTest.item3" antes do de '
        '"_SqliteRepositoryTest.item1" não foi impedida.',
      );

      assert(
        await _SqliteRepositoryTest(auth).testInsertThreeItens(),
        'Os itens não foram inseridos.',
      );

      assert(
        await _SqliteRepositoryTest(auth).testInsertAssunto1(),
        'O assunto retornado por "_SqliteRepositoryTest.assunto1" não foi inserido.',
      );

      assert(
        await _SqliteRepositoryTest(auth).testInsertAssunto3(),
        'O assunto retornado por "_SqliteRepositoryTest.assunto3" não foi inserido.',
      );

      try {
        // Habilitando o console de depuração do Sqflite.
        Sqflite.devSetDebugModeOn(true);

        //final repo = _SqliteRepositoryTest(auth);

      } catch (e) {
        Debug.printBetweenLine('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
      }
    }));
  }, (er, stack) {
    Debug.printBetweenLine(er);
  });
}

const _kSQL =

    /// Cria a tabela para os assuntos, caso ainda não exista.
    'CREATE TABLE IF NOT EXISTS "$_kTbAssuntos" ('
    // O SQLite recomenda que não seja usado o atributo AUTOINCREMENT.
    '"$_kTbAssuntosColId" INTEGER PRIMARY KEY NOT NULL ' /* AUTOINCREMENT */ ', '
    '"${DbConst.kDbDataAssuntoKeyTitulo}" TEXT NOT NULL, '
    '"${DbConst.kDbDataAssuntoKeyHierarquia}" TEXT'
    '); '

    /// Caso ainda não exista, cria a visualização para "consolidar" os dados dos assuntos.
    'CREATE VIEW IF NOT EXISTS "$_kViewAssuntos" AS '
    'SELECT '
    //'"$_kTbAssuntosColId", '
    '"${DbConst.kDbDataAssuntoKeyTitulo}", '
    '"${DbConst.kDbDataAssuntoKeyHierarquia}" '
    'FROM "$_kTbAssuntos" '
    'ORDER BY '
    // Concatenar o título do assunto ao final da árvore para fazer a ordenação.
    '("${DbConst.kDbDataAssuntoKeyHierarquia}" || \'/\' '
    '|| "${DbConst.kDbDataAssuntoKeyTitulo}") ASC, '
    // Se a árvore for nula, a concatenação também será nula. Nesse caso, o título do
    // assunto permitirá a ordenação desses valores nulos.
    '"${DbConst.kDbDataAssuntoKeyTitulo}" ASC'
    '; '

    /// Cria a tabela para os itens, caso ainda não exista.
    'CREATE TABLE IF NOT EXISTS "$_kTbItens" ('
    '"${DbConst.kDbDataQuestaoKeyId}" VARCHAR PRIMARY KEY NOT NULL, '
    '"${DbConst.kDbDataQuestaoKeyAno}" INTEGER NOT NULL, '
    '"${DbConst.kDbDataQuestaoKeyAssuntos}" VARCHAR NOT NULL, '
    '"${DbConst.kDbDataQuestaoKeyEnunciado}" TEXT NOT NULL, '
    '"${DbConst.kDbDataQuestaoKeyAlternativas}" TEXT NOT NULL, '
    '"${DbConst.kDbDataQuestaoKeyGabarito}" VARCHAR NOT NULL, '
    '"${DbConst.kDbDataQuestaoKeyDificuldade}" VARCHAR NOT NULL, '
    '"${DbConst.kDbDataQuestaoKeyImagensEnunciado}" TEXT'
    '); '

    /// Cria a tabela para as referências dos itens, caso ainda não exista.
    'CREATE TABLE IF NOT EXISTS "$_kTbItensRef" ('
    '"$_kTbItensRefColId" VARCHAR PRIMARY KEY NOT NULL, '
    '"$_kTbItensRefColNivel" INTEGER NOT NULL, '
    '"$_kTbItensRefColIndice" INTEGER NOT NULL, '
    '"$_kTbItensRefColReferencia" VARCHAR NOT NULL, '
    'FOREIGN KEY("$_kTbItensRefColReferencia") REFERENCES "$_kTbItens"("${DbConst.kDbDataQuestaoKeyId}") ON DELETE RESTRICT'
    '); '

    /// Caso ainda não exista, cria a visualização para "consolidar" os dados dos itens.
    /// Esta visualização conterá um registro para cada aplicação do item. Isso significa
    /// que se o item foi aplicado em dois cadernos, possuirá um registro para cada um destes.
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
    '; '

    /// Caso ainda não exista, cria a visualização para "consolidar" os dados dos itens,
    /// excluindo-se os casos de reaplicação.
    /// Nesta visualização, mesmo que um item tenha sido aplicado em mais de um caderno,
    /// ele possuirá um único registro.
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
    '; '

    /// Cria um gatilho para impedir a sobreposição acidental dos registros já
    /// inseridos na tabela de itens.
    'CREATE TRIGGER "trigger_insert_in_tb_itens_if_not_exists" BEFORE INSERT ON "$_kTbItens" '
    'WHEN EXISTS (SELECT 1 FROM "$_kTbItens" WHERE "${DbConst.kDbDataQuestaoKeyId}" = NEW."${DbConst.kDbDataQuestaoKeyId}") '
    'BEGIN '
    'SELECT RAISE(ABORT,"A tabela $_kTbItens já possui um registro com o id fornecido."); '
    'END; '

    /// Cria a tabela para os assuntos, caso ainda não exista.
    'CREATE TABLE IF NOT EXISTS "$_kTbAssuntos" ('
    // O SQLite recomenda que não seja usado o atributo AUTOINCREMENT.
    '"$_kTbAssuntosColId" INTEGER PRIMARY KEY NOT NULL ' /* AUTOINCREMENT */ ', '
    '"${DbConst.kDbDataAssuntoKeyTitulo}" TEXT NOT NULL, '
    '"${DbConst.kDbDataAssuntoKeyHierarquia}" TEXT'
    '); ';

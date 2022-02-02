import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../models/debug.dart';
import '../../models/exceptions/error_handler.dart';
import '../../utils/db/codificacao.dart';
import '../../utils/strings_db_sql.dart';
import 'esquema.dart';

part 'drift_db.g.dart';

@DriftDatabase(
  include: {'esquema.drift'},
  tables: [
    TbQuestoes,
    TbAssuntos,
    TbQuestaoAssunto,
    TbTiposAlternativa,
    TbAlternativas,
    TbQuestoesCaderno,
    TbUsuarios,
    TbClubes,
    TbTiposPermissao,
    TbClubeUsuario,
    TbAtividades,
    TbQuestaoAtividade,
    TbRespostaQuestaoAtividade,
    TbRespostaQuestao,
  ],
)
class DriftDb extends _$DriftDb {
  // TODO: Definir local de armazenamento.
  DriftDb()
      : /* super(abrirConexao()); // */ super(
            NativeDatabase.memory(/* logStatements: true */));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          //if (details.wasCreated) {}
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static LazyDatabase abrirConexao() {
    // O utilitário [LazyDatabase] nos permite encontrar assíncronamente o local certo para o
    // arquivo.
    return LazyDatabase(() async {
      final dbDir = await getApplicationDocumentsDirectory();
      final arquivo = File(path.join(dbDir.path, 'db.sqlite'));
      return NativeDatabase(
        arquivo,
        //logStatements: Debug.inDebugger,
      );
    });
  }

  /// Retorna a data da última modificação de [tabela].
  Future<DateTime?> ultimaModificacao(Tabelas tabela) async {
    final TableInfo _tabela;
    final GeneratedColumn<int?> coluna;
    switch (tabela) {
      case Tabelas.questoes:
        _tabela = tbQuestoes;
        coluna = tbQuestoes.dataModificacao;
        break;
      case Tabelas.assuntos:
        _tabela = tbAssuntos;
        coluna = tbAssuntos.dataModificacao;
        break;
      case Tabelas.questaoAssunto:
        _tabela = tbQuestaoAssunto;
        coluna = tbQuestaoAssunto.dataModificacao;
        break;
      case Tabelas.tiposAlternativa:
        _tabela = tbTiposAlternativa;
        coluna = tbTiposAlternativa.dataModificacao;
        break;
      case Tabelas.alternativas:
        _tabela = tbAlternativas;
        coluna = tbAlternativas.dataModificacao;
        break;
      case Tabelas.questoesCaderno:
        _tabela = tbQuestoesCaderno;
        coluna = tbQuestoesCaderno.dataModificacao;
        break;
      case Tabelas.usuarios:
        _tabela = tbUsuarios;
        coluna = tbUsuarios.dataModificacao;
        break;
      case Tabelas.clubes:
        _tabela = tbClubes;
        coluna = tbClubes.dataModificacao;
        break;
      case Tabelas.tiposPermissao:
        _tabela = tbTiposPermissao;
        coluna = tbTiposPermissao.dataModificacao;
        break;
      case Tabelas.clubeUsuario:
        _tabela = tbClubeUsuario;
        coluna = tbClubeUsuario.dataModificacao;
        break;
      case Tabelas.atividades:
        _tabela = tbAtividades;
        coluna = tbAtividades.dataModificacao;
        break;
      case Tabelas.questaoAtividade:
        _tabela = tbQuestaoAtividade;
        coluna = tbQuestaoAtividade.dataModificacao;
        break;
      case Tabelas.respostaQuestaoAtividade:
        _tabela = tbRespostaQuestaoAtividade;
        coluna = tbRespostaQuestaoAtividade.dataModificacao;
        break;
      case Tabelas.respostaQuestao:
        _tabela = tbRespostaQuestao;
        coluna = tbRespostaQuestao.dataModificacao;
        break;
      /* default:
        return null; */
    }
    final query = selectOnly(_tabela)..addColumns([coluna.max()]);
    final int? milissegundos;
    try {
      milissegundos = (await query.getSingleOrNull())?.read(coluna.max());
    } catch (erro) {
      assert(Debug.printBetweenLine(erro));
      return null;
    }
    final data =
        milissegundos == null ? null : DbLocal.decodificarData(milissegundos);
    return data;
  }

  /// Insere (ou atualiza) os registros correspondentes a [linhas] em [tabela].
  /// Retorna o número de registros Inseridos (ou atualizados).
  ///
  /// **Observação:** Não há previsão da ordem de inserção (ou atualização) dos registro.
  Future<int> upsert(TableInfo tabela, Iterable<Insertable> linhas) async {
    final futuros = <Future>[];
    int contador = 0;
    for (var lin in linhas) {
      futuros.add(
        into(tabela).insertOnConflictUpdate(lin).then((_) => contador++),
      );
    }
    try {
      // Não há previsão da ordem de inserção das linhas.
      await Future.wait(futuros);
    } catch (erro, stack) {
      assert(Debug.printBetweenLine('erro: $erro\nlinhas: $linhas'));
      ErrorHandler.reportError(
        FlutterErrorDetails(
          exception: erro,
          stack: stack,
          library: 'drift_db.dart --> DriftDb.upsert',
          context: DiagnosticsNode.message('linhas: $linhas'),
        ),
      );
    }
    return contador;
  }

  /// Exclui os registros correspondentes a [linhas] em [tabela] usando a chave primária como
  /// condição de exclusão.
  /// Retorna o número de registros diretamente excluídos (sem incluir linhas adicionais que
  /// podem ser afetadas por gatilhos ou restrições de chave estrangeira).
  ///
  /// Se [contarInexistentes] for verdadeiro, os registros não encontrados serão contabilizados
  /// como excluídos.
  ///
  /// **Observação:** Não há previsão da ordem de exclusão dos registro.
  Future<int> deleteSamePrimaryKey(
    TableInfo tabela,
    Iterable<Insertable> linhas, {
    bool contarInexistentes = true,
  }) async {
    final futuros = <Future>[];
    int contador = 0;
    for (var lin in linhas) {
      futuros.add(
        (delete(tabela)..whereSamePrimaryKey(lin)).go().then((cont) {
          if (cont == 0 && contarInexistentes) {
            final query = select(tabela)
              ..whereSamePrimaryKey(lin)
              ..limit(1);
            return query.getSingleOrNull().then((value) {
              if (value == null) contador++;
            });
          }
          contador += cont;
        }),
      );
    }
    try {
      // Não há previsão da ordem de exclusão das linhas.
      await Future.wait(futuros);
    } catch (erro, stack) {
      assert(Debug.printBetweenLine('erro: $erro\nlinhas: $linhas'));
      ErrorHandler.reportError(
        FlutterErrorDetails(
          exception: erro,
          stack: stack,
          library: 'drift_db.dart --> DriftDb.deleteSamePrimaryKey',
          context: tabela != tbUsuarios
              ? DiagnosticsNode.message('linhas: $linhas')
              : null,
        ),
      );
    }
    return contador;
  }

  SimpleSelectStatement<$TbAssuntosTable, LinTbAssuntos> selectAssuntos(
      {List<int> ids = const []}) {
    final query = select(tbAssuntos);
    if (ids.isNotEmpty) {
      query
        ..where((tbl) => tbl.id.isIn(ids))
        ..limit(ids.length);
    }
    return query;
  }

  JoinedSelectStatement<$TbQuestoesCadernoTable, LinTbQuestoesCaderno>
      _joinQuestoes({
    Iterable<String> ids = const [],
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
    bool somenteIds = false,
    int? limit,
    int? offset,
  }) {
    final join = selectOnly(
      tbQuestoesCaderno,
      distinct: assuntos.isNotEmpty,
    )
      ..addColumns([
        tbQuestoesCaderno.id,
        if (!somenteIds) ...[
          tbQuestoesCaderno.ano,
          tbQuestoesCaderno.nivel,
          tbQuestoesCaderno.indice,
          tbQuestoes.id,
          tbQuestoes.enunciado,
          tbQuestoes.gabarito,
          tbQuestoes.imagensEnunciado,
        ],
      ])
      ..join([
        innerJoin(
          tbQuestoes,
          tbQuestoes.id.equalsExp(tbQuestoesCaderno.idQuestao),
          useColumns: false,
        ),
        if (assuntos.isNotEmpty)
          innerJoin(
            tbQuestaoAssunto,
            tbQuestaoAssunto.idQuestao.equalsExp(tbQuestoes.id) &
                tbQuestaoAssunto.idAssunto.isIn(assuntos),
            useColumns: false,
          )
      ])
      ..orderBy([OrderingTerm(expression: tbQuestoesCaderno.id)]);

    if (ids.isNotEmpty) {
      join
        ..where(tbQuestoesCaderno.id.isIn(ids))
        ..limit(ids.length);
    }

    if (limit != null) join.limit(limit, offset: offset);

    if (anos.isNotEmpty) {
      join.where(tbQuestoesCaderno.ano.isIn(anos));
    }

    if (niveis.isNotEmpty) {
      join.where(tbQuestoesCaderno.nivel.isIn(niveis));
    }

    return join;
  }

  Selectable<int> filtrarAnos({
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
  }) {
    final coluna = tbQuestoesCaderno.ano;
    final join = selectOnly(tbQuestoesCaderno, distinct: true)
      ..addColumns([coluna])
      ..join([
        if (assuntos.isNotEmpty)
          innerJoin(
            tbQuestaoAssunto,
            tbQuestaoAssunto.idQuestao.equalsExp(tbQuestoesCaderno.idQuestao) &
                tbQuestaoAssunto.idAssunto.isIn(assuntos),
            useColumns: false,
          )
      ])
      ..orderBy([OrderingTerm(expression: coluna)]);

    if (niveis.isNotEmpty) {
      join.where(tbQuestoesCaderno.nivel.isIn(niveis));
    }

    final retorno = join.map((linha) => linha.read(coluna)!);
    return retorno;
  }

  Selectable<int> filtrarNiveis({
    Iterable<int> anos = const [],
    Iterable<int> assuntos = const [],
  }) {
    final coluna = tbQuestoesCaderno.nivel;
    final join = selectOnly(
      tbQuestoesCaderno,
      distinct: true,
    )
      ..addColumns([coluna])
      ..join([
        if (assuntos.isNotEmpty)
          innerJoin(
            tbQuestaoAssunto,
            tbQuestaoAssunto.idQuestao.equalsExp(tbQuestoesCaderno.idQuestao) &
                tbQuestaoAssunto.idAssunto.isIn(assuntos),
            useColumns: false,
          )
      ])
      ..orderBy([OrderingTerm(expression: coluna)]);

    if (anos.isNotEmpty) {
      join.where(tbQuestoesCaderno.nivel.isIn(anos));
    }

    final retorno = join.map((linha) => linha.read(coluna)!);
    return retorno;
  }

  /// Retorna os assuntos diretamente ligados às questões.
  Selectable<LinTbAssuntos> filtrarAssuntos({
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
  }) {
    final query = customSelect(
      r'SELECT DISTINCT assuntos.* FROM assuntos '
      r'INNER JOIN ('
      r'  SELECT '
      r'    w.id,'
      r'    w.hierarquia,'
      r'    z.id_questao,'
      r'    z.ano,'
      r'    z.nivel'
      r'  FROM assuntos AS w'
      r'  INNER JOIN ('
      // Emular FULL OUTER JOIN. Fonte: https://www.sqlitetutorial.net/sqlite-full-outer-join/
      r'    SELECT '
      r'      x1.id_assunto,'
      r'      x1.id_questao,'
      r'      y1.ano,'
      r'      y1.nivel'
      r'    FROM questao_x_assunto AS x1'
      r'    LEFT JOIN questoes_caderno AS y1 USING(id_questao)'
      r'    UNION ALL'
      r'    SELECT '
      r'      x2.id_assunto,'
      r'      x2.id_questao,'
      r'      y2.ano,'
      r'      y2.nivel'
      r'    FROM questoes_caderno AS y2'
      r'    LEFT JOIN questao_x_assunto AS x2 USING(id_questao)'
      r'    WHERE x2.id_questao IS NULL'
      r'  ) AS z ON w.id = z.id_assunto'
      r') AS juncao ON assuntos.id = juncao.id OR assuntos.id IN ('
      r'  SELECT "value" FROM json_each((juncao.hierarquia))'
      r')'
      r'WHERE '
      r'  ('
      r'    (?1 IS NULL) OR '
      r"    (json_array_length(?1) = 0) OR "
      r'    (juncao.ano IN (SELECT "value" FROM json_each((?1))))'
      r'  ) AND ('
      r'    (?2 IS NULL) OR '
      r"    (json_array_length(?2) = 0) OR "
      r'    (juncao.nivel IN (SELECT "value" FROM json_each((?2))))'
      r'  );',
      variables: [
        Variable.withString(DbLocal.codificarLista(anos.toList())),
        Variable.withString(DbLocal.codificarLista(niveis.toList())),
      ],
      readsFrom: {
        tbAssuntos,
        tbQuestaoAssunto,
        tbQuestoesCaderno,
      },
    );

    final retorno = query.map((linha) {
      return LinTbAssuntos.fromData(linha.data);
    });
    return retorno;
  }

  /// {@template app.DriftDb.contarQuestoes}
  /// Retorna o número de questões que satisfazem os filtros passados.
  ///
  /// Usa a operação de disjunção para elementos da mesma lista, e de conjunção para
  /// elementos de listas diferentes.
  /// {@endtemplate}
  Future<int> contarQuestoes({
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
  }) async {
    final join = _joinQuestoes(
      anos: anos,
      niveis: niveis,
      assuntos: assuntos,
      somenteIds: true,
    );
    final resultado = await join.get();
    return resultado.length;
  }

  Future<List<LinViewQuestoes>> selectQuestoes({
    Iterable<String> ids = const [],
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
    int? limit,
    int? offset,
  }) async {
    final join = _joinQuestoes(
      ids: ids,
      anos: anos,
      niveis: niveis,
      assuntos: assuntos,
      limit: limit,
      offset: offset,
    );

    final questoes = join.map((linha) async {
      final id = linha.read(tbQuestoes.id);

      final queryIdsAssuntos = selectOnly(tbQuestaoAssunto)
        ..addColumns([tbQuestaoAssunto.idAssunto])
        ..where(tbQuestaoAssunto.idQuestao.equals(id));
      final queryAssuntos = select(tbAssuntos)
        ..where((tb) => tb.id.isInQuery(queryIdsAssuntos));
      final assuntos = await queryAssuntos.get();

      final queryAlternativas = select(tbAlternativas)
        ..where((tb) => tb.idQuestao.equals(id));
      final alternativas = await queryAlternativas.get();

      return LinViewQuestoes(
        id: linha.read(tbQuestoesCaderno.id)!,
        ano: linha.read(tbQuestoesCaderno.ano)!,
        nivel: linha.read(tbQuestoesCaderno.nivel)!,
        indice: linha.read(tbQuestoesCaderno.indice)!,
        enunciado: linha.read(tbQuestoes.enunciado)!,
        gabarito: linha.read(tbQuestoes.gabarito)!,
        imagensEnunciado: linha.read(tbQuestoes.imagensEnunciado),
        assuntos: assuntos,
        alternativas: alternativas,
      );
    });

    return Future.wait(await questoes.get());
  }

  /// Retorna os assuntos diretamente ligados às questões.
  Selectable<LinViewClubes> selectClubes(int idUsuario) {
    final id = Sql.tbClubes.id;
    final nome = Sql.tbClubes.nome;
    final descricao = Sql.tbClubes.descricao;
    final dataCriacao = Sql.tbClubes.dataCriacao;
    final privado = Sql.tbClubes.privado;
    final codigo = Sql.tbClubes.codigo;
    final capa = Sql.tbClubes.capa;
    final usuarios = 'usuarios';
    final query = customSelect(
      r'SELECT '
      '  clubes.$id, '
      '  clubes.$nome, '
      '  clubes.$descricao, '
      '  clubes.$dataCriacao, '
      '  clubes.$privado, '
      '  clubes.$codigo,'
      '  clubes.$capa,'
      r'  ('
      r'    SELECT json_group_array(json_object('
      r"      'id_usuario', id_usuario, "
      r"      'nome', (SELECT usuarios.nome FROM usuarios WHERE usuarios.id = id_usuario),"
      r"      'id_clube', id_clube, "
      r"      'id_permissao', id_permissao"
      r'    )) FROM clube_x_usuario WHERE id_clube = clubes.id'
      '  ) AS $usuarios'
      r'  FROM clubes'
      r'  WHERE EXISTS('
      r'    SELECT 1 FROM clube_x_usuario '
      r'    WHERE clube_x_usuario.id_clube = clubes.id AND clube_x_usuario.id_usuario = ?'
      r'  )'
      '  ORDER BY clubes.$dataCriacao;',
      variables: [
        Variable.withInt(idUsuario),
      ],
      readsFrom: {
        tbClubes,
        tbClubeUsuario,
      },
    );

    final retorno = query.map((linha) {
      return LinViewClubes(
        id: linha.data[id],
        nome: linha.data[nome],
        descricao: linha.data[descricao],
        dataCriacao: linha.data[dataCriacao],
        privado: DbLocal.decodificarBooleano(linha.data[privado]),
        codigo: linha.data[codigo],
        capa: linha.data[capa],
        usuarios: linha.data[usuarios],
      );
    });
    return retorno;
  }

  Selectable<LinTbAtividades> selectAtividades(int idClube) {
    final query = select(tbAtividades)
      ..where((tb) => tb.idClube.equals(idClube))
      ..orderBy([(tb) => OrderingTerm(expression: tb.dataLiberacao)]);
    return query;
  }
}

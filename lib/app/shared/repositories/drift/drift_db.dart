import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../models/debug.dart';
import '../../models/exceptions/clube_error.dart';
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
/* 
  queries: {
    'questoes': '''
SELECT 
  questoes_caderno."id" AS id_questao_caderno, 
  questoes_caderno.id_questao AS "id",
  questoes_caderno.ano, 
  questoes_caderno.nivel, 
  questoes_caderno.indice, 
  questoes.enunciado, 
  questoes.gabarito, 
  questoes.imagens_enunciado, 
  (
    SELECT json_group_array(
      -- Exibir o ID dos assuntos.
      id_assunto 
    ) FROM questao_x_assunto WHERE id_questao = questoes_caderno.id_questao
  ) AS assuntos, 
  (
    SELECT json_group_array(
      json_object(
        'id_questao', id_questao, 
        'sequencial', sequencial, 
        'id_tipo', id_tipo, 
        'conteudo', conteudo
      ) 
    ) FROM alternativas WHERE id_questao = questoes."id"
  ) AS alternativas
  FROM questoes_caderno
  INNER JOIN questoes ON questoes."id" = questoes_caderno.id_questao
  WHERE 
    (
      (:ids IS NULL) OR 
      (json_array_length(:ids) = 0) OR 
      (id_questao_caderno IN (SELECT "value" FROM json_each((:ids))))
    ) AND (
      (:anos IS NULL) OR 
      (json_array_length(:anos) = 0) OR 
      (ano IN (SELECT "value" FROM json_each((:anos))))
    ) AND (
      (:niveis IS NULL) OR 
      (json_array_length(:niveis) = 0) OR 
      (nivel IN (SELECT "value" FROM json_each((:niveis))))
    ) AND (
      (:assuntos IS NULL) OR 
      (json_array_length(:assuntos) = 0) OR 
      (
        json_array_length(assuntos) <> 
        (
          SELECT COUNT(*) FROM (
            SELECT "value" FROM json_each((:assuntos))
            EXCEPT
            SELECT "value" FROM json_each((assuntos))
          )
        )
      )
    ) 
  ;
'''
  }, 
*/
)
class DriftDb extends _$DriftDb {
  DriftDb() : super(abrirConexao()) {
    if (kIsWeb) throw UnimplementedError();
  }
  // super(NativeDatabase.memory(/* logStatements: true */));

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

  void _reportarErro(Object erro, StackTrace? stack, String? mensagem) {
    ClubeError.reportFlutterError(
      FlutterErrorDetails(
        exception: erro,
        stack: stack,
        library: 'drift_db.dart',
        context: mensagem == null ? null : DiagnosticsNode.message(mensagem),
      ),
    );
  }

  /// Retorna a data da última modificação de [tabela].
  Future<DateTime?> ultimaModificacao(Tabelas tabela) async {
    final TableInfo _tabela;
    final GeneratedColumn<int> coluna;
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
  Future<DriftDbResposta> upsert(
      TableInfo tabela, Iterable<Insertable> linhas) async {
    final futuros = <Future<Insertable>>[];
    final naoInseridos = linhas.toList();
    int contador = 0;
    for (var lin in linhas) {
      futuros.add(
        into(tabela).insertOnConflictUpdate(lin).then((_) {
          contador++;
          return lin;
        }),
      );
    }
    try {
      // Não há previsão da ordem de inserção das linhas.
      await Future.wait<Insertable>(
        futuros,
        cleanUp: (linha) => naoInseridos.remove(linha),
      );
    } catch (erro, stack) {
      _reportar() => _reportarErro(erro, stack, 'linhas: $naoInseridos');

      if (erro is SqliteException) {
        // SQLITE_CONSTRAINT_FOREIGNKEY
        if (erro.extendedResultCode == 787) {
          final reportar = ![
            // Tabelas onde o erro já está tratado.
            tbClubeUsuario,
            tbAtividades,
            tbQuestaoAtividade,
            tbRespostaQuestaoAtividade,
          ].contains(tabela);
          if (reportar) _reportar();
          return DriftDbResposta(erro: DriftDbErro.sqliteConstraintForeignKey);
        }
      }
      _reportar();
    }
    return DriftDbResposta(dados: contador);
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
    final futuros = <Future<Insertable>>[];
    final naoInseridos = linhas.toList();
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
              return lin;
            });
          }
          contador += cont;
          return lin;
        }),
      );
    }
    try {
      // Não há previsão da ordem de exclusão das linhas.
      await Future.wait<Insertable>(
        futuros,
        cleanUp: (linha) => naoInseridos.remove(linha),
      );
    } catch (erro, stack) {
      _reportarErro(
        erro,
        stack,
        tabela != tbUsuarios ? 'linhas: $naoInseridos' : null,
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
    bool somenteIdAlfanumerico = false,
    int? limit,
    int? offset,
  }) {
    final join = selectOnly(
      tbQuestoesCaderno,
      distinct: assuntos.isNotEmpty,
    )
      ..addColumns([
        tbQuestoesCaderno.id,
        if (!somenteIdAlfanumerico) ...[
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
      join.where(tbQuestoesCaderno.ano.isIn(anos));
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
      r"""
SELECT DISTINCT assuntos.* FROM assuntos 
INNER JOIN (
  SELECT 
    w.id,
    w.hierarquia,
    z.id_questao,
    z.ano,
    z.nivel
  FROM assuntos AS w
  INNER JOIN ("""
// Emular FULL OUTER JOIN. Fonte: https://www.sqlitetutorial.net/sqlite-full-outer-join/
      r"""
    SELECT 
      x1.id_assunto,
      x1.id_questao,
      y1.ano,
      y1.nivel
    FROM questao_x_assunto AS x1
    LEFT JOIN questoes_caderno AS y1 USING(id_questao)
    UNION ALL
    SELECT 
      x2.id_assunto,
      x2.id_questao,
      y2.ano,
      y2.nivel
    FROM questoes_caderno AS y2
    LEFT JOIN questao_x_assunto AS x2 USING(id_questao)
    WHERE x2.id_questao IS NULL
  ) AS z ON w.id = z.id_assunto
) AS juncao ON assuntos.id = juncao.id OR assuntos.id IN (
  SELECT "value" FROM json_each((juncao.hierarquia))
)
WHERE 
  (
    (?1 IS NULL) OR 
    (json_array_length(?1) = 0) OR 
    (juncao.ano IN (SELECT "value" FROM json_each((?1))))
  ) AND (
    (?2 IS NULL) OR 
    (json_array_length(?2) = 0) OR 
    (juncao.nivel IN (SELECT "value" FROM json_each((?2))))
  );""",
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
      return tbAssuntos.map(linha.data);
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
      somenteIdAlfanumerico: true,
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
      final id = linha.read(tbQuestoes.id)!;

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
        idAlfanumerico: linha.read(tbQuestoesCaderno.id)!,
        id: id,
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

  Selectable<LinTbRespostaQuestao> selectRespostaQuestao(int idQuestao) {
    final query = select(tbRespostaQuestao)
      ..where((tb) => tb.idQuestao.equals(idQuestao))
      ..limit(1);
    return query;
  }

  Future<int> deleteRespostaQuestaoInconsistentes(int idUsuario) async {
    final query = delete(tbRespostaQuestao)
      ..where((tbl) =>
          tbl.idUsuario.isNotNull() & tbl.idUsuario.isNotIn([idUsuario]));
    try {
      return await query.go();
    } catch (erro, stack) {
      _reportarErro(erro, stack, null);
      return 0;
    }
  }

  Future<bool> updateUsuario(TbUsuariosCompanion dados) async {
    //if (dados.id.value == null) return false;
    final consulta = update(tbUsuarios)
      ..where((tb) => tb.id.equals(dados.id.value));
    int contagem = 0;
    try {
      contagem = await consulta.write(dados);
    } catch (erro, stack) {
      _reportarErro(erro, stack, 'linhas: $dados');
    }

    if (contagem != 1) return false;
    return true;
  }
}

enum DriftDbErro { sqliteConstraintForeignKey }

class DriftDbResposta {
  DriftDbResposta({
    this.dados,
    this.erro,
  });

  final dynamic dados;
  final DriftDbErro? erro;
}

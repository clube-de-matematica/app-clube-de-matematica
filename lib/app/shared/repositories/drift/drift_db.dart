import 'dart:developer';
import 'dart:io';

import 'package:clubedematematica/app/shared/models/debug.dart';
import 'package:clubedematematica/app/shared/utils/db/codificacao.dart';
import 'package:clubedematematica/app/shared/utils/strings_db_sql.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'esquema.dart';

part 'drift_db.g.dart';

@DriftDatabase(
  include: {'esquema_sql.drift'},
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
  DriftDb() : super(abrirConexao()); // super(NativeDatabase.memory());

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
    } catch (erro) {
      debugger(); //TODO
      assert(Debug.printBetweenLine(erro));
    }
    return contador;
  }

  /// Exclui os registros correspondentes a [linhas] em [tabela] usando a chave primária como
  /// condição de exclusão.
  /// Retorna o número de registros diretamente excluídos (sem incluir linhas adicionais que
  /// podem ser afetadas por gatilhos ou restrições de chave estrangeira).
  ///
  /// **Observação:** Não há previsão da ordem de exclusão dos registro.
  Future<int> deleteSamePrimaryKey(
      TableInfo tabela, Iterable<Insertable> linhas) async {
    final futuros = <Future>[];
    int contador = 0;
    for (var lin in linhas) {
      futuros.add(
        (delete(tabela)..whereSamePrimaryKey(lin))
            .go()
            .then((cont) => contador += cont),
      );
    }
    try {
      // Não há previsão da ordem de exclusão das linhas.
      await Future.wait(futuros);
    } catch (erro) {
      debugger(); //TODO
      assert(Debug.printBetweenLine(erro));
    }
    return contador;
  }

  Future<List<LinTbAssuntos>> get selectAssuntos async {
    return select(tbAssuntos).get();
  }

  Future<List<LinViewQuestoes>> get selectQuestoes async {
    final join = selectOnly(tbQuestoesCaderno)
      ..addColumns([
        tbQuestoesCaderno.id,
        tbQuestoesCaderno.ano,
        tbQuestoesCaderno.nivel,
        tbQuestoesCaderno.indice,
        tbQuestoes.id,
        tbQuestoes.enunciado,
        tbQuestoes.gabarito,
        tbQuestoes.imagensEnunciado,
      ])
      ..join([
        innerJoin(
          tbQuestoes,
          tbQuestoes.id.equalsExp(tbQuestoesCaderno.idQuestao),
          useColumns: false,
        )
      ]);

    //join..limit(1); //TODO

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

  Future<List<LinViewClubes>> get selectClubes async {
    final join = selectOnly(tbClubes)
      ..addColumns([
        tbClubes.id,
        tbClubes.nome,
        tbClubes.descricao,
        tbClubes.dataCriacao,
        tbClubes.privado,
        tbClubes.codigo,
        tbClubes.capa,
        tbClubeUsuario.idUsuario,
      ])
      ..join([
        innerJoin(
          tbClubeUsuario,
          tbClubeUsuario.idClube.equalsExp(tbClubes.id) &
              tbClubeUsuario.idPermissao
                  .equals(Sql.tbTiposPermissao.idProprietario),
          useColumns: false,
        )
      ]);

    final clubes = join.map((linha) async {
      final id = linha.read(tbClubes.id);

      queryUsuarios(int permissao) {
        final query = selectOnly(tbClubeUsuario)
          ..addColumns([tbClubeUsuario.idUsuario])
          ..where(tbClubeUsuario.idClube.equals(id))
          ..where(tbClubeUsuario.idPermissao.equals(permissao));
        return query.map((p0) => p0.read(tbClubeUsuario.idUsuario)!);
      }

      final proprietario =
          await queryUsuarios(Sql.tbTiposPermissao.idProprietario).getSingle();
      final administradores =
          await queryUsuarios(Sql.tbTiposPermissao.idAdministrador).get();
      final membros = await queryUsuarios(Sql.tbTiposPermissao.idMembro).get();

      return LinViewClubes(
        id: linha.read(tbClubes.id)!,
        nome: linha.read(tbClubes.nome)!,
        descricao: linha.read(tbClubes.descricao)!,
        dataCriacao: linha.read(tbClubes.dataCriacao)!,
        privado: linha.read(tbClubes.privado)!,
        codigo: linha.read(tbClubes.codigo)!,
        capa: linha.read(tbClubes.capa),
        proprietario: proprietario,
        administradores: administradores,
        membros: membros,
      );
    });

    return Future.wait(await clubes.get());
  }
}

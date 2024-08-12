import 'dart:async';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../modules/clubes/modules/atividades/models/atividade.dart';
import '../modules/clubes/modules/atividades/models/questao_atividade.dart';
import '../modules/clubes/modules/atividades/models/resposta_questao_atividade.dart';
import '../modules/clubes/shared/models/clube.dart';
import '../modules/perfil/models/userapp.dart';
import '../modules/quiz/shared/models/alternativa_questao_model.dart';
import '../modules/quiz/shared/models/assunto_model.dart';
import '../modules/quiz/shared/models/imagem_questao_model.dart';
import '../modules/quiz/shared/models/questao_model.dart';
import '../modules/quiz/shared/models/resposta_questao.dart';
import '../shared/models/db/remoto/linha_tabela_alternativas.dart';
import '../shared/models/db/remoto/linha_tabela_assuntos.dart';
import '../shared/models/db/remoto/linha_tabela_atividades.dart';
import '../shared/models/db/remoto/linha_tabela_clube_usuario.dart';
import '../shared/models/db/remoto/linha_tabela_clubes.dart';
import '../shared/models/db/remoto/linha_tabela_questao_assunto.dart';
import '../shared/models/db/remoto/linha_tabela_questao_atividade.dart';
import '../shared/models/db/remoto/linha_tabela_questoes.dart';
import '../shared/models/db/remoto/linha_tabela_questoes_caderno.dart';
import '../shared/models/db/remoto/linha_tabela_resposta_questao.dart';
import '../shared/models/db/remoto/linha_tabela_resposta_questao_atividade.dart';
import '../shared/models/db/remoto/linha_tabela_tipos_alternativa.dart';
import '../shared/models/db/remoto/linha_tabela_tipos_permissao.dart';
import '../shared/models/db/remoto/linha_tabela_usuarios.dart';
import '../shared/repositories/drift/drift_db.dart';
import '../shared/repositories/drift/esquema.dart';
import '../shared/repositories/interface_auth_repository.dart';
import '../shared/repositories/supabase/supabase_db_repository.dart';
import '../shared/utils/db/codificacao.dart';
import '../shared/utils/strings_db.dart';
import '../shared/utils/strings_db_sql.dart';
import 'conectividade.dart';
import 'db_servicos_interface.dart';

class DbServicos extends IDbServicos {
  DbServicos(
    SupabaseDbRepository dbRemoto,
    IAuthRepository auth,
  ) : super(dbRemoto, auth) {
    if (kIsWeb) {
      throw UnimplementedError();
    }
    bool sincronizar = true;
    _authStateSubscription = auth.authState.listen((evento) {
      if (evento == AuthChangeState.signedIn) {
        if (sincronizar) _sincronizar();
        sincronizar = false;
      }
      if (evento == AuthChangeState.signedOut) {
        sincronizar = true;
      }
    });
  }

  late final StreamSubscription<AuthChangeState> _authStateSubscription;

  DriftDb get dbLocal => Modular.get<DriftDb>();

  late final _inicializando = _sincronizar();

  /// Se verdadeiro, indica que uma chamada de [_sincronizar] está em andamento;
  bool _sincronizando = false;

  @override
  void close() {
    dbLocal.close();
    _authStateSubscription.cancel();
  }

  /// Última verificação de conectividade.
  DateTime _ultimaVerificacao = DateTime.fromMillisecondsSinceEpoch(0);

  /// Retorna o resultado de uma verificação de conectividade, fazendo uma nova
  /// verificação, caso a última tenha ocorrido a mais de 10 segundos, com o dispoositivo
  /// estando conectado, ou a mais de 2 segundos, estando desconectado.
  Future<bool> _verificarConectividade([bool forcar = false]) async {
    final estado = Conectividade.instancia.conectado;
    final verificar = forcar ||
        DateTime.now().isAfter(
          _ultimaVerificacao.add(
            Duration(seconds: estado ? 10 : 2),
          ),
        );
    if (verificar) {
      return await Conectividade.instancia
          .verificar()
          .whenComplete(() => _ultimaVerificacao = DateTime.now());
    } else {
      return estado;
    }
  }

  // TODO: Envolver em um isolado.
  Future<void> _sincronizar() async {
    final conectado = await _verificarConectividade();
    if (!_sincronizando && conectado) {
      _sincronizando = true;
      final sincQuestoes = _sincronizarTbQuestoes();
      final sincUsuarios = _sincronizarTbUsuarios();
      final sincClubes = _sincronizarTbClubes();
      final sincQuestaoAssunto =
          Future.wait([sincQuestoes, _sincronizarTbAssuntos()])
              .then((_) => _sincronizarTbQuestaoAssunto());
      final sincAlternativas =
          Future.wait([sincQuestoes, _sincronizarTbTiposAlternativa()])
              .then((_) => _sincronizarTbAlternativas());
      final sincQuestoesCaderno =
          sincQuestoes.then((_) => _sincronizarTbQuestoesCaderno());
      final sincClubeUsuario = Future.wait(
              [sincUsuarios, sincClubes, _sincronizarTbTiposPermissao()])
          .then((_) => _sincronizarTbClubeUsuario());
      final sincAtividades = Future.wait([sincUsuarios, sincClubes])
          .then((_) => _sincronizarTbAtividades());
      final sincQuestaoAtividade =
          Future.wait([sincQuestoesCaderno, sincAtividades])
              .then((_) => _sincronizarTbQuestaoAtividade());
      final sincRespostaQuestaoAtividade =
          Future.wait([sincUsuarios, sincQuestaoAtividade])
              .then((_) => _sincronizarTbRespostaQuestaoAtividade());
      final sincRespostaQuestao = Future.wait([sincQuestoes, sincUsuarios])
          .then((_) => _sincronizarTbRespostaQuestao());

      await Future.wait([
        sincQuestaoAssunto,
        sincAlternativas,
        sincClubeUsuario,
        sincQuestaoAtividade,
        sincRespostaQuestaoAtividade,
        sincRespostaQuestao,
      ]);

      _sincronizando = false;
    }
    return;
  }

  Future<void> _sincronizarTbQuestoes() async {
    if (!await _verificarConectividade()) return;
    final novosRegistros = await dbRemoto.obterTbQuestoes(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.questoes),
    );
    final resposta = (await dbLocal.upsert(
      dbLocal.tbQuestoes,
      novosRegistros.map((e) => e.toDbLocal()),
    ));
    assert(() {
      if (resposta.dados != novosRegistros.length) debugger();
      return true;
    }());
  }

  Future<void> _sincronizarTbAssuntos() async {
    if (!await _verificarConectividade()) return;
    final novosRegistros = await dbRemoto.obterTbAssuntos(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.assuntos),
    );
    final resposta = (await dbLocal.upsert(
      dbLocal.tbAssuntos,
      novosRegistros.map((e) => e.toDbLocal()),
    ));
    assert(() {
      if (resposta.dados != novosRegistros.length) debugger();
      return true;
    }());
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbQuestoes] e
  /// [_sincronizarTbAssuntos] ser concluído.
  Future<void> _sincronizarTbQuestaoAssunto(
      [bool sincronizarDependencias = false]) async {
    if (!await _verificarConectividade()) return;
    if (sincronizarDependencias) {
      await Future.wait([_sincronizarTbQuestoes(), _sincronizarTbAssuntos()]);
    }
    final novosRegistros = await dbRemoto.obterTbQuestaoAssunto(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.questaoAssunto),
    );
    final resposta = (await dbLocal.upsert(
      dbLocal.tbQuestaoAssunto,
      novosRegistros.map((e) => e.toDbLocal()),
    ));
    assert(() {
      if (resposta.dados != novosRegistros.length) debugger();
      return true;
    }());
  }

  Future<void> _sincronizarTbTiposAlternativa() async {
    if (!await _verificarConectividade()) return;
    final novosRegistros = await dbRemoto.obterTbTiposAlternativa(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.tiposAlternativa),
    );
    final resposta = (await dbLocal.upsert(
      dbLocal.tbTiposAlternativa,
      novosRegistros.map((e) => e.toDbLocal()),
    ));
    assert(() {
      if (resposta.dados != novosRegistros.length) debugger();
      return true;
    }());
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbQuestoes] e
  /// [_sincronizarTbTiposAlternativa] ser concluído.
  Future<void> _sincronizarTbAlternativas(
      [bool sincronizarDependencias = false]) async {
    if (!await _verificarConectividade()) return;
    if (sincronizarDependencias) {
      await Future.wait(
          [_sincronizarTbQuestoes(), _sincronizarTbTiposAlternativa()]);
    }
    final novosRegistros = await dbRemoto.obterTbAlternativas(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.alternativas),
    );
    final resposta = (await dbLocal.upsert(
      dbLocal.tbAlternativas,
      novosRegistros.map((e) => e.toDbLocal()),
    ));
    assert(() {
      if (resposta.dados != novosRegistros.length) debugger();
      return true;
    }());
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbQuestoes] ser concluído.
  Future<void> _sincronizarTbQuestoesCaderno(
      [bool sincronizarDependencias = false]) async {
    if (!await _verificarConectividade()) return;
    if (sincronizarDependencias) {
      await _sincronizarTbQuestoes();
    }
    final novosRegistros = await dbRemoto.obterTbQuestoesCaderno(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.questoesCaderno),
    );
    final resposta = (await dbLocal.upsert(
      dbLocal.tbQuestoesCaderno,
      novosRegistros.map((e) => e.toDbLocal()),
    ));
    assert(() {
      if (resposta.dados != novosRegistros.length) debugger();
      return true;
    }());
  }

  /// [forcar] é usado para obter todos os registros, independentemente da data de modificação.
  Future<void> _sincronizarTbUsuarios({bool forcar = false}) async {
    if (idUsuarioApp == null) return;
    final id = idUsuarioApp!;

    if (!await _verificarConectividade()) return;

    final consultaLocal = dbLocal.select(dbLocal.tbUsuarios)
      ..where((tb) => tb.sincronizar.equals(true) & tb.id.equals(id))
      ..limit(1);

    final dadosLocal = await consultaLocal.map((linha) {
      return RawUserApp(
        id: linha.id,
        name: linha.nome,
        email: linha.email,
      );
    }).getSingleOrNull();

    if (dadosLocal?.name != null) {
      await auth.updateUserName(dadosLocal!.name!);
      //await _dbRemoto.updateUser(dadosLocal);
    }

    final novosRegistros = await dbRemoto.obterTbUsuarios(
      modificadoApos:
          forcar ? null : await dbLocal.ultimaModificacao(Tabelas.usuarios),
    );
    final resposta = (await dbLocal.upsert(
      dbLocal.tbUsuarios,
      novosRegistros.map((e) => e.toDbLocal()),
    ));
    assert(() {
      if (resposta.dados != novosRegistros.length) debugger();
      return true;
    }());
  }

  /// [forcar] é usado para obter todos os registros, independentemente da data de modificação.
  Future<void> _sincronizarTbClubes({bool forcar = false}) async {
    if (!logado) return;
    if (!await _verificarConectividade()) return;
    final novosRegistros = await dbRemoto.obterTbClubes(
      modificadoApos:
          forcar ? null : await dbLocal.ultimaModificacao(Tabelas.clubes),
    );
    int contagem = 0;

    // excluir os registros marcados para exclusão.
    final excluir =
        novosRegistros.where((e) => e.excluir).map((e) => e.toDbLocal());
    contagem += await dbLocal.deleteSamePrimaryKey(dbLocal.tbClubes, excluir);

    // Inserir ou atualizar os registros não marcados para exclusão.
    final upsert =
        novosRegistros.where((e) => !e.excluir).map((e) => e.toDbLocal());
    final resposta = await dbLocal.upsert(dbLocal.tbClubes, upsert);
    contagem += (resposta.dados as int?) ?? 0;
    assert(() {
      if (contagem != novosRegistros.length) debugger();
      return true;
    }());
  }

  Future<void> _sincronizarTbTiposPermissao() async {
    if (!logado) return;
    if (!await _verificarConectividade()) return;
    final novosRegistros = await dbRemoto.obterTbTiposPermissao(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.tiposPermissao),
    );
    final resposta = (await dbLocal.upsert(
      dbLocal.tbTiposPermissao,
      novosRegistros.map((e) => e.toDbLocal()),
    ));
    assert(() {
      if (resposta.dados != novosRegistros.length) debugger();
      return true;
    }());
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbUsuarios],
  /// [_sincronizarTbClubes] e [_sincronizarTbTiposPermissao] ser concluído.
  /// [forcar] é usado para obter todos os registros, independentemente da data de modificação.
  Future<void> _sincronizarTbClubeUsuario({
    bool sincronizarDependencias = false,
    bool forcar = false,
  }) async {
    if (!logado) return;
    if (!await _verificarConectividade()) return;

    dependencias([bool forcar = false]) async {
      await Future.wait([
        _sincronizarTbUsuarios(forcar: forcar),
        _sincronizarTbClubes(forcar: forcar),
        _sincronizarTbTiposPermissao(),
      ]);
    }

    if (sincronizarDependencias) await dependencias();

    sinc() async {
      final novosRegistros = await dbRemoto.obterTbClubeUsuario(
        modificadoApos: forcar
            ? null
            : await dbLocal.ultimaModificacao(Tabelas.clubeUsuario),
      );
      // excluir os registros marcados para exclusão.
      await dbLocal.deleteSamePrimaryKey(
        dbLocal.tbClubeUsuario,
        novosRegistros.where((e) => e.excluir).map((e) => e.toDbLocal()),
      );
      // Inserir ou atualizar os registros não marcados para exclusão.
      final upsert =
          novosRegistros.where((e) => !e.excluir).map((e) => e.toDbLocal());

      final resposta = await dbLocal.upsert(dbLocal.tbClubeUsuario, upsert);
      return resposta;
    }

    final resposta = await sinc();
    if (resposta.erro == DriftDbErro.sqliteConstraintForeignKey) {
      await dependencias(true);
      await sinc();
    }
    return;
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbUsuarios] e
  /// [_sincronizarTbClubes] ser concluído.
  Future<void> _sincronizarTbAtividades({
    bool sincronizarDependencias = false,
    bool forcar = false,
  }) async {
    if (!logado) return;
    if (!await _verificarConectividade()) return;

    dependencias([bool forcar = false]) async {
      await Future.wait([
        _sincronizarTbUsuarios(forcar: forcar),
        _sincronizarTbClubes(forcar: forcar),
      ]);
    }

    if (sincronizarDependencias) await dependencias();

    sinc() async {
      final novosRegistros = await dbRemoto.obterTbAtividades(
        modificadoApos:
            forcar ? null : await dbLocal.ultimaModificacao(Tabelas.atividades),
      );

      // excluir os registros marcados para exclusão.
      await dbLocal.deleteSamePrimaryKey(
        dbLocal.tbAtividades,
        novosRegistros.where((e) => e.excluir).map((e) => e.toDbLocal()),
      );
      // Inserir ou atualizar os registros não marcados para exclusão.
      final resposta = await dbLocal.upsert(
        dbLocal.tbAtividades,
        novosRegistros.where((e) => !e.excluir).map((e) => e.toDbLocal()),
      );
      return resposta;
    }

    final resposta = await sinc();
    if (resposta.erro == DriftDbErro.sqliteConstraintForeignKey) {
      await dependencias(true);
      await sinc();
    }
    return;
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbQuestoesCaderno] e
  /// [_sincronizarTbAtividades] ser concluído.
  Future<void> _sincronizarTbQuestaoAtividade({
    bool sincronizarDependencias = false,
    bool forcar = false,
  }) async {
    if (!logado) return;
    if (!await _verificarConectividade()) return;

    dependencias([bool forcar = false]) async {
      await Future.wait([
        _sincronizarTbQuestoesCaderno(true),
        _sincronizarTbAtividades(sincronizarDependencias: true, forcar: forcar),
      ]);
    }

    if (sincronizarDependencias) await dependencias();

    sinc() async {
      final novosRegistros = await dbRemoto.obterTbQuestaoAtividade(
        modificadoApos: forcar
            ? null
            : await dbLocal.ultimaModificacao(Tabelas.questaoAtividade),
      );
      // excluir os registros marcados para exclusão.
      await dbLocal.deleteSamePrimaryKey(
        dbLocal.tbQuestaoAtividade,
        novosRegistros.where((e) => e.excluir).map((e) => e.toDbLocal()),
      );
      // Inserir ou atualizar os registros não marcados para exclusão.
      final resposta = await dbLocal.upsert(
        dbLocal.tbQuestaoAtividade,
        novosRegistros.where((e) => !e.excluir).map((e) => e.toDbLocal()),
      );
      return resposta;
    }

    final resposta = await sinc();
    if (resposta.erro == DriftDbErro.sqliteConstraintForeignKey) {
      await dependencias(true);
      await sinc();
    }
    return;
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbUsuarios] e
  /// [_sincronizarTbQuestaoAtividade] ser concluído.
  Future<void> _sincronizarTbRespostaQuestaoAtividade({
    bool sincronizarDependencias = false,
    bool forcar = false,
  }) async {
    if (!logado) return;
    if (!await _verificarConectividade()) return;

    final consultaNovosLocal = dbLocal
        .select(dbLocal.tbRespostaQuestaoAtividade, distinct: true)
      ..where((tb) => tb.sincronizar.equals(true));

    final novosLocal = await consultaNovosLocal.map((linha) {
      return RawRespostaQuestaoAtividade(
        idQuestaoAtividade: linha.idQuestaoAtividade,
        idUsuario: linha.idUsuario,
        sequencial: linha.resposta,
      );
    }).get();

    if (novosLocal.isNotEmpty) {
      await dbRemoto.upsertRespostasAtividade(novosLocal);
    }

    dependencias([bool forcar = false]) async {
      await Future.wait([
        _sincronizarTbUsuarios(forcar: forcar),
        _sincronizarTbQuestaoAtividade(
          sincronizarDependencias: true,
          forcar: forcar,
        ),
      ]);
    }

    if (sincronizarDependencias) await dependencias();

    sinc() async {
      final novosRemoto = await dbRemoto.obterTbRespostaQuestaoAtividade(
        modificadoApos: forcar
            ? null
            : await dbLocal.ultimaModificacao(Tabelas.respostaQuestaoAtividade),
      );
      // excluir os registros marcados para exclusão.
      await dbLocal.deleteSamePrimaryKey(
        dbLocal.tbRespostaQuestaoAtividade,
        novosRemoto.where((e) => e.excluir).map((e) => e.toDbLocal()),
      );
      // Inserir ou atualizar os registros não marcados para exclusão.
      final resposta = await dbLocal.upsert(
        dbLocal.tbRespostaQuestaoAtividade,
        novosRemoto.where((e) => !e.excluir).map((e) => e.toDbLocal()),
      );
      return resposta;
    }

    final resposta = await sinc();
    if (resposta.erro == DriftDbErro.sqliteConstraintForeignKey) {
      await dependencias(true);
      await sinc();
    }
    return;
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbQuestoes] e
  /// [_sincronizarTbUsuarios] ser concluído.
  Future<void> _sincronizarTbRespostaQuestao(
      [bool sincronizarDependencias = false]) async {
    if (idUsuarioApp == null) return;
    await dbLocal.deleteRespostaQuestaoInconsistentes(idUsuarioApp!);
    if (!await _verificarConectividade()) return;

    final consultaNovosLocal = dbLocal.select(dbLocal.tbRespostaQuestao,
        distinct: true)
      ..where((tb) => tb.sincronizar.equals(true));

    final novosLocal = await consultaNovosLocal.map((linha) {
      return RawRespostaQuestao(
        idQuestao: linha.idQuestao,
        idUsuario: linha.idUsuario ?? idUsuarioApp,
        sequencial: linha.resposta,
      );
    }).get();

    if (novosLocal.isNotEmpty) {
      await dbRemoto.upsertRespostas(novosLocal);
    }

    if (sincronizarDependencias) {
      await Future.wait([
        _sincronizarTbQuestoes(),
        _sincronizarTbUsuarios(),
      ]);
    }
    final novosRemoto = await dbRemoto.obterTbRespostaQuestao(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.respostaQuestao),
    );
    int contagem = 0;
    // excluir os registros marcados para exclusão.
    contagem += await dbLocal.deleteSamePrimaryKey(
      dbLocal.tbRespostaQuestao,
      novosRemoto.where((e) => e.excluir).map((e) => e.toDbLocal()),
    );
    // Inserir ou atualizar os registros não marcados para exclusão.
    final resposta = await dbLocal.upsert(
      dbLocal.tbRespostaQuestao,
      novosRemoto.where((e) => !e.excluir).map((e) => e.toDbLocal()),
    );
    contagem += (resposta.dados as int?) ?? 0;
    assert(() {
      if (contagem != novosRemoto.length) debugger();
      return true;
    }());
  }

  /// {@template app.IDbServicos.sincronizarClubes}
  /// Sincroniza os registros dos dados relacionados ao banco de questões entre os bancos
  /// de dados local e remoto.
  /// {@endtemplate}
  Future<void> sincronizarBancoDeQuestoes() async {
    if (!logado) return;

    if (!await _verificarConectividade()) return;

    await Future.wait([
      _sincronizarTbQuestoes(),
      _sincronizarTbAssuntos(),
      _sincronizarTbTiposAlternativa(),
    ]);
    await Future.wait([
      _sincronizarTbQuestaoAssunto(),
      _sincronizarTbAlternativas(),
      _sincronizarTbQuestoesCaderno(),
    ]);
  }

  /// {@template app.IDbServicos.sincronizarClubes}
  /// Sincroniza os registros dos dados relacionados aos clubes entre os bancos de dados
  /// local e remoto.
  /// {@endtemplate}
  @override
  Future<void> sincronizarClubes() async {
    if (!logado) return;

    if (!await _verificarConectividade()) return;

    await Future.wait([
      _sincronizarTbUsuarios(),
      _sincronizarTbClubes(),
      _sincronizarTbTiposPermissao(),
    ]);
    await Future.wait([
      _sincronizarTbClubeUsuario(),
      _sincronizarTbAtividades(),
      _sincronizarTbQuestoesCaderno(true),
    ]);
    await _sincronizarTbQuestaoAtividade();
    await _sincronizarTbRespostaQuestaoAtividade();
  }

  @override
  Future<List<int>> filtrarAnos({
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
  }) {
    return dbLocal.filtrarAnos(niveis: niveis, assuntos: assuntos).get();
  }

  @override
  Future<List<int>> filtrarNiveis({
    Iterable<int> anos = const [],
    Iterable<int> assuntos = const [],
  }) {
    return dbLocal.filtrarNiveis(anos: anos, assuntos: assuntos).get();
  }

  @override
  Future<List<Assunto>> filtrarAssuntos({
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
  }) {
    return dbLocal
        .filtrarAssuntos(anos: anos, niveis: niveis)
        .map((e) => e.toAssunto())
        .get()
      ..catchError((e) {
        debugger();
        return <Assunto>[];
      });
  }

  @override
  Future<Assunto?> assunto(int id) async {
    final consulta = dbLocal.selectAssuntos(ids: [id])..limit(1);
    final assunto =
        consulta.map((linha) => linha.toAssunto()).getSingleOrNull();
    return assunto;
  }

  late final _streamAssuntos =
      dbLocal.selectAssuntos().map((linha) => linha.toAssunto()).watch()
        ..handleError((erro, pilha) {
          return;
        });

  @override
  Stream<List<Assunto>> obterAssuntos() => _streamAssuntos;

  @override
  Future<bool> inserirAssunto(RawAssunto dados) async {
    if (!await _verificarConectividade()) return false;
    final sucesso = await dbRemoto.insertAssunto(dados);
    if (sucesso) await _sincronizarTbAssuntos();
    return sucesso;
  }

  /// {@macro app.DriftDb.contarQuestoes}
  @override
  Future<int> contarQuestoes({
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
  }) async {
    await _inicializando;

    return dbLocal.contarQuestoes(
      anos: anos,
      niveis: niveis,
      assuntos: assuntos,
    );
  }

  @override
  Future<Questao?> obterQuestao(String id) async {
    List<LinViewQuestoes> lista;
    try {
      lista = await dbLocal.selectQuestoes(
        ids: [id],
        limit: 1,
      );
    } catch (_) {
      lista = [];
    }
    return lista.isEmpty ? null : lista[0].toQuestao();
  }

  @override
  Future<List<Questao>> obterQuestoes({
    Iterable<String> ids = const [],
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
    int? limit,
    int? offset,
  }) async {
    // Aguardar o fim da primeira sincronização.
    if (_sincronizando) await _inicializando;
    final List<LinViewQuestoes> dbQuestoes;
    try {
      dbQuestoes = await dbLocal.selectQuestoes(
        ids: ids,
        anos: anos,
        niveis: niveis,
        assuntos: assuntos,
        limit: limit,
        offset: offset,
      );
    } catch (_) {
      return [];
    }
    return dbQuestoes.map((dbQuestao) => dbQuestao.toQuestao()).toList();
  }

  @override
  Future<bool> checarPermissaoInserirQuestao() {
    return dbRemoto.checkPermissionInsertQuestao();
  }

  @override
  Future<bool> inserirQuestao(Questao data) async {
    if (!await _verificarConectividade()) return false;
    final sucesso = await dbRemoto.insertQuestao(data);
    if (sucesso) await sincronizarBancoDeQuestoes();
    return sucesso;
  }

  @override
  Future<bool> inserirReferenciaQuestao(Questao data, int idReferencia) async {
    if (!await _verificarConectividade()) return false;
    final sucesso = await dbRemoto.insertReferenceQuestao(data, idReferencia);
    if (sucesso) await sincronizarBancoDeQuestoes();
    return sucesso;
  }

  @override
  Stream<List<Clube>> obterClubes() {
    final id = idUsuarioApp;
    if (id == null) return Stream.value([]);
    final retorno =
        dbLocal.selectClubes(id).map((linha) => linha.toClube()).watch()
          ..handleError((erro, pilha) {
            return;
          });
    return retorno;
  }

  @override
  Future<Clube?> inserirClube(RawClube data) async {
    if (idUsuarioApp == null) return null;
    if (!await _verificarConectividade()) return null;
    final clube = await dbRemoto.insertClube(data);
    if (clube != null) await sincronizarClubes();
    return clube;
  }

  @override
  Future<Clube?> atualizarClube(RawClube data) async {
    if (idUsuarioApp == null) return null;
    if (!await _verificarConectividade()) return null;
    final clube = await dbRemoto.updateClube(data);
    if (clube != null) await sincronizarClubes();
    return clube;
  }

  @override
  Future<Clube?> entrarClube(String accessCode) async {
    final id = idUsuarioApp;
    if (id == null) return null;
    if (!await _verificarConectividade()) return null;
    final dataClube = await dbRemoto.enterClube(accessCode, id);
    if (dataClube.isNotEmpty) {
      await sincronizarClubes();
      return Clube.fromDataClube(dataClube);
    }
    return null;
  }

  @override
  Future<bool> removerUsuarioClube(int idClube, int idUser) async {
    if (idUsuarioApp == null) return false;
    if (!await _verificarConectividade()) return false;
    final sucesso = await dbRemoto.exitClube(idClube, idUser);
    if (sucesso) {
      if (idUser == idUsuarioApp) {
        final consultaExcluir = dbLocal.delete(dbLocal.tbClubes)
          ..where((tb) => tb.id.equals(idClube));
        await consultaExcluir.go();
      }
      await sincronizarClubes();
    }
    return sucesso;
  }

  @override
  Future<bool> atualizarPermissaoUsuarioClube(
      int idClube, int idUser, int idPermission) async {
    if (idUsuarioApp == null) return false;
    if (!await _verificarConectividade()) return false;
    final sucesso =
        await dbRemoto.updatePermissionUserClube(idClube, idUser, idPermission);
    if (sucesso) await sincronizarClubes();
    return sucesso;
  }

  @override
  Future<bool> excluirClube(Clube clube) async {
    if (idUsuarioApp == null) return false;
    if (!await _verificarConectividade()) return false;
    final sucesso = await dbRemoto.deleteClube(clube.id);
    if (sucesso) await sincronizarClubes();
    return sucesso;
  }

  @override
  Stream<List<Atividade>> obterAtividades(Clube clube) {
    if (idUsuarioApp == null) return Stream.value([]);
    final retorno = dbLocal
        .selectAtividades(clube.id)
        .map((linha) => linha.toAtividade())
        .watch()
      ..handleError((erro, pilha) {
        return;
      });
    return retorno;
  }

  @override
  Future<Atividade?> inserirAtividade(RawAtividade dados) async {
    if (idUsuarioApp == null) return null;
    if (!await _verificarConectividade()) return null;
    final atividade = await dbRemoto.insertAtividade(dados);
    if (atividade != null) await sincronizarClubes();
    return atividade;
  }

  @override
  Future<Atividade?> atualizarAtividade(RawAtividade dados) async {
    if (idUsuarioApp == null) return null;
    if (!await _verificarConectividade()) return null;
    final atividade = await dbRemoto.updateAtividade(dados);
    if (atividade != null) await sincronizarClubes();
    return atividade;
  }

  @override
  Future<bool> excluirAtividade(Atividade atividade) async {
    if (idUsuarioApp == null) return false;
    if (!await _verificarConectividade()) return false;
    final sucesso = await dbRemoto.deleteAtividade(atividade.id);
    if (sucesso) await sincronizarClubes();
    return sucesso;
  }

  @override
  Future<List<QuestaoAtividade>> obterQuestoesAtividade(
      Atividade atividade) async {
    try {
      final id = idUsuarioApp;
      if (id == null) return [];

      final linhasClube = (await dbLocal.selectClubes(id).get())
          .where((linha) => linha.id == atividade.idClube);
      if (linhasClube.isEmpty) return [];

      final clube = linhasClube.first.toClube();
      final usuario = clube.getUsuario(id);
      if (usuario == null) return [];

      final consultaAtividades = dbLocal.select(dbLocal.tbQuestaoAtividade)
        ..where((tb) => tb.idAtividade.equals(atividade.id));

      retornoAssincrono() {
        return consultaAtividades.map((linha) async {
          final consultaRespostas = dbLocal
              .select(dbLocal.tbRespostaQuestaoAtividade)
            ..where((tb) => tb.idQuestaoAtividade.equals(linha.id));

          if (usuario.membro) {
            consultaRespostas.where((tb) => tb.idUsuario.equals(usuario.id));
          }
          return QuestaoAtividade(
            questao: (await obterQuestao(linha.idQuestaoCaderno))!,
            idAtividade: linha.idAtividade,
            idQuestaoAtividade: linha.id,
            respostas: await consultaRespostas
                .map((linhaResposta) =>
                    linhaResposta.toRespostaQuestaoAtividade())
                .get(),
          );
        }).get();
      }

      final retorno = await Future.wait(await retornoAssincrono());
      return retorno;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> salvarRespostasAtividade(
      Iterable<RawRespostaQuestaoAtividade> dados) async {
    if (idUsuarioApp == null) return false;
    if (dados.isEmpty) return false;

    // Preparar os dados e inserir no banco de dados local.
    final linhas = _prepararUpsertRespostasAtividade(dados);
    final resposta =
        await dbLocal.upsert(dbLocal.tbRespostaQuestaoAtividade, linhas);
    assert(() {
      if (resposta.dados != linhas.length) debugger();
      return true;
    }());
    if (resposta.dados != linhas.length) return false;

    // Sincronizar com o banco de dados remoto.
    await sincronizarClubes();

    return true;
  }

  Iterable<LinTbRespostaQuestaoAtividade> _prepararUpsertRespostasAtividade(
      Iterable<RawRespostaQuestaoAtividade> dados) {
    inconsistente() {
      return dados
          .any((e) => [e.idQuestaoAtividade, e.idUsuario].contains(null));
    }

    if (inconsistente()) return [];

    return dados.map((e) {
      return LinTbRespostaQuestaoAtividade(
        idQuestaoAtividade: e.idQuestaoAtividade!,
        idUsuario: e.idUsuario!,
        resposta: e.sequencial,
        dataModificacao: DbLocal.codificarData(DateTime.now().toUtc()),
        sincronizar: true,
      );
    });
  }

  /// {@template app.IDbServicos.obterRespostaQuestao}
  /// Se houver uma resposta salva para [questao], retorna o [RespostaQuestao] correspondente.
  /// {@endtemplate}
  @override
  Future<RespostaQuestao?> obterRespostaQuestao(Questao questao) {
    final retorno = dbLocal
        .selectRespostaQuestao(questao.id)
        .map((linha) => linha.toRespostaQuestao())
        .getSingleOrNull();
    return retorno;
  }

  @override
  Future<bool> salvarRespostaQuestao(RawRespostaQuestao resposta) async {
    final dbResposta = await dbLocal.upsert(dbLocal.tbRespostaQuestao, [
      LinTbRespostaQuestao(
        dataModificacao: DbLocal.codificarData(DateTime.now().toUtc()),
        idQuestao: resposta.idQuestao!,
        idUsuario: resposta.idUsuario,
        resposta: resposta.sequencial,
        sincronizar: true,
      )
    ]);
    final sucesso = dbResposta.dados != null;
    if (sucesso) await _sincronizarTbRespostaQuestao();
    return sucesso;
  }

  @override
  Future<bool> atualizarUsuario(RawUserApp dados) async {
    if (idUsuarioApp == null || dados.id == null || dados.id != idUsuarioApp) {
      return false;
    }

    final modelo = TbUsuariosCompanion(
      id: Value(dados.id!),
      nome: Value(dados.name),
      sincronizar: const Value(true),
    );

    // Falhará se a tabela de usuários não tiver o registro a ser atualizado
    final sucesso = await dbLocal.updateUsuario(modelo);
    await _sincronizarTbUsuarios();
    // Caso a primeira tentativa de atualização tenha falhado.
    if (!sucesso) {
      if (await dbLocal.updateUsuario(modelo)) {
        await _sincronizarTbUsuarios();
        return true;
      }
    }
    return sucesso;
  }
}

extension _LinTbQuestoesDbRemoto on LinTbQuestoesDbRemoto {
  LinTbQuestoes toDbLocal() {
    final imagens = decodificarImagensEnunciado();
    final retorno = LinTbQuestoes(
      id: id,
      enunciado: DbLocal.codificarEnunciado(decodificarEnunciado()),
      gabarito: gabarito,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
      imagensEnunciado:
          imagens == null ? null : DbLocal.codificarImagensEnunciado(imagens),
    );
    return retorno;
  }
}

extension _LinTbAssuntosDbRemoto on LinTbAssuntosDbRemoto {
  LinTbAssuntos toDbLocal() {
    final hierarquia = decodificarHierarquia();
    final retorno = LinTbAssuntos(
      id: id,
      assunto: assunto,
      hierarquia:
          hierarquia == null ? null : DbLocal.codificarHierarquia(hierarquia),
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbQuestaoAssuntoDbRemoto on LinTbQuestaoAssuntoDbRemoto {
  LinTbQuestaoAssunto toDbLocal() {
    final retorno = LinTbQuestaoAssunto(
      idQuestao: idQuestao,
      idAssunto: idAssunto,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbTiposAlternativaDbRemoto on LinTbTiposAlternativaDbRemoto {
  LinTbTiposAlternativa toDbLocal() {
    final retorno = LinTbTiposAlternativa(
      id: id,
      tipo: tipo,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbAlternativasDbRemoto on LinTbAlternativasDbRemoto {
  LinTbAlternativas toDbLocal() {
    final retorno = LinTbAlternativas(
      idQuestao: idQuestao,
      sequencial: sequencial,
      idTipo: idTipo,
      conteudo: conteudo,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbQuestoesCadernoDbRemoto on LinTbQuestoesCadernoDbRemoto {
  LinTbQuestoesCaderno toDbLocal() {
    final retorno = LinTbQuestoesCaderno(
      id: id,
      ano: ano,
      nivel: nivel,
      indice: indice,
      idQuestao: idQuestao,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbUsuariosDbRemoto on LinTbUsuariosDbRemoto {
  LinTbUsuarios toDbLocal() {
    final retorno = LinTbUsuarios(
      id: id,
      email: email,
      nome: nome,
      foto: foto,
      softDelete: softDelete,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
      sincronizar: false,
    );
    return retorno;
  }
}

extension _LinTbClubesDbRemoto on LinTbClubesDbRemoto {
  LinTbClubes toDbLocal() {
    final retorno = LinTbClubes(
      id: id,
      nome: nome,
      descricao: descricao,
      dataCriacao: DbLocal.codificarData(decodificarDataCriacao()),
      privado: privado,
      codigo: codigo,
      capa: capa,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbTiposPermissaoDbRemoto on LinTbTiposPermissaoDbRemoto {
  LinTbTiposPermissao toDbLocal() {
    final retorno = LinTbTiposPermissao(
      id: id,
      permissao: permissao,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbClubeUsuarioDbRemoto on LinTbClubeUsuarioDbRemoto {
  LinTbClubeUsuario toDbLocal() {
    final retorno = LinTbClubeUsuario(
      idClube: idClube,
      idUsuario: idUsuario,
      idPermissao: idPermissao,
      dataAdmissao: DbLocal.codificarData(decodificarDataAdmissao()),
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbAtividadesDbRemoto on LinTbAtividadesDbRemoto {
  LinTbAtividades toDbLocal() {
    final retorno = LinTbAtividades(
      id: id,
      idClube: idClube,
      titulo: titulo,
      descricao: descricao,
      idAutor: idAutor,
      dataCriacao: DbLocal.codificarData(decodificarDataCriacao()),
      dataLiberacao: dataLiberacao == null
          ? null
          : DbLocal.codificarData(decodificarDataLiberacao()!),
      dataEncerramento: dataEncerramento == null
          ? null
          : DbLocal.codificarData(decodificarDataEncerramento()!),
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbQuestaoAtividadeDbRemoto on LinTbQuestaoAtividadeDbRemoto {
  LinTbQuestaoAtividade toDbLocal() {
    final retorno = LinTbQuestaoAtividade(
      id: id,
      idQuestaoCaderno: idQuestaoCaderno,
      idAtividade: idAtividade,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbRespostaQuestaoAtividadeDbRemoto
    on LinTbRespostaQuestaoAtividadeDbRemoto {
  LinTbRespostaQuestaoAtividade toDbLocal() {
    final retorno = LinTbRespostaQuestaoAtividade(
      idQuestaoAtividade: idQuestaoAtividade,
      idUsuario: idUsuario,
      resposta: resposta,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
      sincronizar: false,
    );
    return retorno;
  }
}

extension _LinTbRespostaQuestaoDbRemoto on LinTbRespostaQuestaoDbRemoto {
  LinTbRespostaQuestao toDbLocal() {
    final retorno = LinTbRespostaQuestao(
      idQuestao: idQuestao,
      idUsuario: idUsuario,
      resposta: resposta,
      sincronizar: false,
      dataModificacao: DbLocal.codificarData(decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbAssuntos on LinTbAssuntos {
  Assunto toAssunto() {
    return Assunto(
      hierarquia: hierarquia == null
          ? []
          : DbLocal.decodificarHierarquia(hierarquia!) ?? [],
      id: id,
      titulo: assunto,
    );
  }
}

extension _LinTbAlternativas on LinTbAlternativas {
  Alternativa toAlternativa() {
    return Alternativa.fromJson({
      Sql.tbAlternativas.idQuestao: idQuestao,
      Sql.tbAlternativas.sequencial: sequencial,
      Sql.tbAlternativas.idTipo: idTipo,
      Sql.tbAlternativas.conteudo: conteudo,
    });
  }
}

extension _LinTbAtividades on LinTbAtividades {
  Atividade toAtividade() {
    return Atividade(
      id: id,
      idAutor: idAutor,
      idClube: idClube,
      titulo: titulo,
      descricao: descricao,
      criacao: DbLocal.decodificarData(dataCriacao),
      liberacao: dataLiberacao != null
          ? DbLocal.decodificarData(dataLiberacao!)
          : null,
      encerramento: dataEncerramento != null
          ? DbLocal.decodificarData(dataEncerramento!)
          : null,
    );
  }
}

extension _LinTbRespostaQuestaoAtividade on LinTbRespostaQuestaoAtividade {
  RespostaQuestaoAtividade toRespostaQuestaoAtividade() {
    return RespostaQuestaoAtividade(
      idQuestaoAtividade: idQuestaoAtividade,
      idUsuario: idUsuario,
      sequencial: resposta,
    );
  }
}

extension _LinTbRespostaQuestao on LinTbRespostaQuestao {
  RespostaQuestao toRespostaQuestao() {
    return RespostaQuestao(
      idQuestao: idQuestao,
      idUsuario: idUsuario,
      sequencial: resposta,
    );
  }
}

extension _LinViewQuestoes on LinViewQuestoes {
  Questao toQuestao() {
    listaImagensEnunciado() {
      final List<ImagemQuestao> imagens = [];
      if (imagensEnunciado != null) {
        final listaDados =
            DbLocal.decodificarImagensEnunciado(imagensEnunciado!) ?? [];

        for (var i = 0; i < listaDados.length; i++) {
          final dados = listaDados[i]
            ..[ImagemQuestao.kKeyName] = '${idAlfanumerico}_enunciado_$i.png';
          imagens.add(ImagemQuestao.fromMap(dados));
        }
      }
      return imagens;
    }

    return Questao(
      idAlfanumerico: idAlfanumerico,
      id: id,
      ano: ano,
      nivel: nivel,
      indice: indice,
      assuntos: assuntos.map((e) => e.toAssunto()).toList(),
      enunciado: DbLocal.decodificarEnunciado(enunciado) ?? [],
      alternativas: alternativas.map((e) => e.toAlternativa()).toList(),
      gabarito: gabarito,
      imagensEnunciado: listaImagensEnunciado(),
    );
  }
}

extension _LinViewClubes on LinViewClubes {
  Clube toClube() {
    return Clube.fromDataClube({
      DbConst.kDbDataClubeKeyId: id,
      DbConst.kDbDataClubeKeyNome: nome,
      DbConst.kDbDataClubeKeyDescricao: descricao,
      DbConst.kDbDataClubeKeyUsuarios:
          DbLocal.decodificarUsuariosClube(usuarios),
      DbConst.kDbDataClubeKeyCapa: capa,
      DbConst.kDbDataClubeKeyCodigo: codigo,
      DbConst.kDbDataClubeKeyPrivado: privado,
    });
  }
}

extension _LinViewAtividades on LinViewAtividades {
  /* Atividade toAtividade() {
    return Atividade(
      id: id,
      idClube: idClube,
      titulo: titulo,
      descricao: descricao,
      idAutor: idAutor,
      criacao: DbLocal.decodificarData(dataCriacao),
      liberacao: dataLiberacao == null
          ? null
          : DbLocal.decodificarData(dataLiberacao!),
      encerramento: dataEncerramento == null
          ? null
          : DbLocal.decodificarData(dataEncerramento!),
      questoes: questoes,
      respostas: respostas,
    );
  } */
}

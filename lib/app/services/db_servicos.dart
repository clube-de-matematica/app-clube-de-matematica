import 'dart:async';
import 'dart:developer';

import 'package:clubedematematica/app/modules/clubes/modules/atividades/models/atividade.dart';
import 'package:clubedematematica/app/modules/clubes/shared/models/clube.dart';

import '../modules/quiz/shared/models/alternativa_questao_model.dart';
import '../modules/quiz/shared/models/ano_questao_model.dart';
import '../modules/quiz/shared/models/assunto_model.dart';
import '../modules/quiz/shared/models/imagem_questao_model.dart';
import '../modules/quiz/shared/models/nivel_questao_model.dart';
import '../modules/quiz/shared/models/questao_model.dart';
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
import '../shared/repositories/supabase/supabase_db_repository.dart';
import '../shared/utils/db/codificacao.dart';
import '../shared/utils/strings_db.dart';
import '../shared/utils/strings_db_sql.dart';
import 'interface_db_servicos.dart';

class DbServicos implements IDbServicos {
  DbServicos(this.dbLocal, this._dbRemoto) {
    //debugger(); //TODO
    _inicializando.then((_) async {
      //debugger(); //TODO
      /* await getAssuntos().then((assuntos) => assuntos.forEach((element) {
            print(element);
          }));
      await getQuestoes().then((value) => value.forEach((element) {
            print(element);
          })); */
      //debugger(); //TODO
    });
  }

  final DriftDb dbLocal;
  //TODO final IRemoteDbRepository _dbRemoto;
  final SupabaseDbRepository _dbRemoto;

  late final _inicializando = _sincronizar();

  /// Se verdadeiro, indica que uma chamada de [_sincronizar] está em andamento;
  bool _sincronizando = false;

  void close() {
    dbLocal.close();
  }

  // TODO: Envolver em um isolado.
  Future<void> _sincronizar() async {
    if (!_sincronizando) {
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
    final novosRegistros = await _dbRemoto.obterTbQuestoes(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.questoes),
    );
    final contagem = await dbLocal.upsert(
      dbLocal.tbQuestoes,
      novosRegistros.map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  Future<void> _sincronizarTbAssuntos() async {
    final novosRegistros = await _dbRemoto.obterTbAssuntos(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.assuntos),
    );
    final contagem = await dbLocal.upsert(
      dbLocal.tbAssuntos,
      novosRegistros.map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbQuestoes] e
  /// [_sincronizarTbAssuntos] ser concluído.
  Future<void> _sincronizarTbQuestaoAssunto(
      [bool sincronizarDependencias = false]) async {
    if (sincronizarDependencias) {
      await Future.wait([_sincronizarTbQuestoes(), _sincronizarTbAssuntos()]);
    }
    final novosRegistros = await _dbRemoto.obterTbQuestaoAssunto(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.questaoAssunto),
    );
    final contagem = await dbLocal.upsert(
      dbLocal.tbQuestaoAssunto,
      novosRegistros.map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  Future<void> _sincronizarTbTiposAlternativa() async {
    final novosRegistros = await _dbRemoto.obterTbTiposAlternativa(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.tiposAlternativa),
    );
    final contagem = await dbLocal.upsert(
      dbLocal.tbTiposAlternativa,
      novosRegistros.map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbQuestoes] e
  /// [_sincronizarTbTiposAlternativa] ser concluído.
  Future<void> _sincronizarTbAlternativas(
      [bool sincronizarDependencias = false]) async {
    if (sincronizarDependencias) {
      await Future.wait(
          [_sincronizarTbQuestoes(), _sincronizarTbTiposAlternativa()]);
    }
    final novosRegistros = await _dbRemoto.obterTbAlternativas(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.alternativas),
    );
    final contagem = await dbLocal.upsert(
      dbLocal.tbAlternativas,
      novosRegistros.map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbQuestoes] ser concluído.
  Future<void> _sincronizarTbQuestoesCaderno(
      [bool sincronizarDependencias = false]) async {
    if (sincronizarDependencias) {
      await _sincronizarTbQuestoes();
    }
    final novosRegistros = await _dbRemoto.obterTbQuestoesCaderno(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.questoesCaderno),
    );
    final contagem = await dbLocal.upsert(
      dbLocal.tbQuestoesCaderno,
      novosRegistros.map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  Future<void> _sincronizarTbUsuarios() async {
    final novosRegistros = await _dbRemoto.obterTbUsuarios(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.usuarios),
    );
    final contagem = await dbLocal.upsert(
      dbLocal.tbUsuarios,
      novosRegistros.map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  Future<void> _sincronizarTbClubes() async {
    final novosRegistros = await _dbRemoto.obterTbClubes(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.clubes),
    );
    int contagem = 0;
    // excluir os registros marcados para exclusão.
    contagem += await dbLocal.deleteSamePrimaryKey(
      dbLocal.tbClubes,
      novosRegistros.where((e) => e.excluir).map((e) => e.toDbLocal()),
    );
    // Inserir ou atualizar os registros não marcados para exclusão.
    contagem += await dbLocal.upsert(
      dbLocal.tbClubes,
      novosRegistros.where((e) => !e.excluir).map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  Future<void> _sincronizarTbTiposPermissao() async {
    final novosRegistros = await _dbRemoto.obterTbTiposPermissao(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.tiposPermissao),
    );
    final contagem = await dbLocal.upsert(
      dbLocal.tbTiposPermissao,
      novosRegistros.map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbUsuarios],
  /// [_sincronizarTbClubes] e [_sincronizarTbTiposPermissao] ser concluído.
  Future<void> _sincronizarTbClubeUsuario(
      [bool sincronizarDependencias = false]) async {
    if (sincronizarDependencias) {
      await Future.wait([
        _sincronizarTbUsuarios(),
        _sincronizarTbClubes(),
        _sincronizarTbTiposPermissao(),
      ]);
    }
    final novosRegistros = await _dbRemoto.obterTbClubeUsuario(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.clubeUsuario),
    );
    int contagem = 0;
    // excluir os registros marcados para exclusão.
    contagem += await dbLocal.deleteSamePrimaryKey(
      dbLocal.tbClubeUsuario,
      novosRegistros.where((e) => e.excluir).map((e) => e.toDbLocal()),
    );
    // Inserir ou atualizar os registros não marcados para exclusão.
    contagem += await dbLocal.upsert(
      dbLocal.tbClubeUsuario,
      novosRegistros.where((e) => !e.excluir).map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbUsuarios] e
  /// [_sincronizarTbClubes] ser concluído.
  Future<void> _sincronizarTbAtividades(
      [bool sincronizarDependencias = false]) async {
    if (sincronizarDependencias) {
      await Future.wait([_sincronizarTbUsuarios(), _sincronizarTbClubes()]);
    }
    final novosRegistros = await _dbRemoto.obterTbAtividades(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.atividades),
    );
    int contagem = 0;
    // excluir os registros marcados para exclusão.
    contagem += await dbLocal.deleteSamePrimaryKey(
      dbLocal.tbAtividades,
      novosRegistros.where((e) => e.excluir).map((e) => e.toDbLocal()),
    );
    // Inserir ou atualizar os registros não marcados para exclusão.
    contagem += await dbLocal.upsert(
      dbLocal.tbAtividades,
      novosRegistros.where((e) => !e.excluir).map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbQuestoesCaderno] e
  /// [_sincronizarTbAtividades] ser concluído.
  Future<void> _sincronizarTbQuestaoAtividade(
      [bool sincronizarDependencias = false]) async {
    if (sincronizarDependencias) {
      await Future.wait([
        _sincronizarTbQuestoesCaderno(true),
        _sincronizarTbAtividades(true),
      ]);
    }
    final novosRegistros = await _dbRemoto.obterTbQuestaoAtividade(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.questaoAtividade),
    );
    int contagem = 0;
    // excluir os registros marcados para exclusão.
    contagem += await dbLocal.deleteSamePrimaryKey(
      dbLocal.tbQuestaoAtividade,
      novosRegistros.where((e) => e.excluir).map((e) => e.toDbLocal()),
    );
    // Inserir ou atualizar os registros não marcados para exclusão.
    contagem += await dbLocal.upsert(
      dbLocal.tbQuestaoAtividade,
      novosRegistros.where((e) => !e.excluir).map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbUsuarios] e
  /// [_sincronizarTbQuestaoAtividade] ser concluído.
  Future<void> _sincronizarTbRespostaQuestaoAtividade(
      [bool sincronizarDependencias = false]) async {
    if (sincronizarDependencias) {
      await Future.wait([
        _sincronizarTbUsuarios(),
        _sincronizarTbQuestaoAtividade(true),
      ]);
    }
    final novosRegistros = await _dbRemoto.obterTbRespostaQuestaoAtividade(
      modificadoApos:
          await dbLocal.ultimaModificacao(Tabelas.respostaQuestaoAtividade),
    );
    int contagem = 0;
    debugger();//TODO
    // excluir os registros marcados para exclusão.
    contagem += await dbLocal.deleteSamePrimaryKey(
      dbLocal.tbRespostaQuestaoAtividade,
      novosRegistros.where((e) => e.excluir).map((e) => e.toDbLocal()),
    );
    // Inserir ou atualizar os registros não marcados para exclusão.
    contagem += await dbLocal.upsert(
      dbLocal.tbRespostaQuestaoAtividade,
      novosRegistros.where((e) => !e.excluir).map((e) => e.toDbLocal()),
    );
    debugger();//TODO
    assert(contagem == novosRegistros.length);
  }

  /// Não deve ser chamado antes de um retorno de [_sincronizarTbQuestoes] e
  /// [_sincronizarTbUsuarios] ser concluído.
  Future<void> _sincronizarTbRespostaQuestao(
      [bool sincronizarDependencias = false]) async {
    if (sincronizarDependencias) {
      await Future.wait([
        _sincronizarTbQuestoes(),
        _sincronizarTbUsuarios(),
      ]);
    }
    final novosRegistros = await _dbRemoto.obterTbRespostaQuestao(
      modificadoApos: await dbLocal.ultimaModificacao(Tabelas.respostaQuestao),
    );
    int contagem = 0;
    // excluir os registros marcados para exclusão.
    contagem += await dbLocal.deleteSamePrimaryKey(
      dbLocal.tbRespostaQuestao,
      novosRegistros.where((e) => e.excluir).map((e) => e.toDbLocal()),
    );
    // Inserir ou atualizar os registros não marcados para exclusão.
    contagem += await dbLocal.upsert(
      dbLocal.tbRespostaQuestao,
      novosRegistros.where((e) => !e.excluir).map((e) => e.toDbLocal()),
    );
    assert(contagem == novosRegistros.length);
  }

  @override
  Future<Assunto?> assunto(int id) async {
    final query = dbLocal.selectAssuntos(ids: [id])..limit(1);
    final assunto = query.map((linha) => linha.toAssunto()).getSingleOrNull();
    return assunto;
  }

  late final _streamAssuntos =
      dbLocal.selectAssuntos().map((linha) => linha.toAssunto()).watch();

  @override
  Stream<List<Assunto>> getAssuntos() => _streamAssuntos;

  @override
  Future<bool> insertAssunto(RawAssunto dados) async {
    final sucesso = await _dbRemoto.insertAssunto(dados);
    if (sucesso) _sincronizarTbAssuntos();
    return sucesso;
  }

  /// {@macro app.DriftDb.contarQuestoes}
  @override
  Future<int> contarQuestoes({
    List<int> anos = const [],
    List<int> niveis = const [],
    List<int> assuntos = const [],
  }) async {
    return dbLocal.contarQuestoes(
      anos: anos,
      niveis: niveis,
      assuntos: assuntos,
    );
  }

  @override
  Future<Questao?> questao(String id) async {
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
  Future<List<Questao>> getQuestoes({
    List<String> ids = const [],
    List<int> anos = const [],
    List<int> niveis = const [],
    List<int> assuntos = const [],
    int? limit,
    int? offset,
  }) async {
    // Aguardar o fim da primeira sincronização.
    if(_sincronizando) await _inicializando;
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
      return List<Questao>.empty();
    }
    return dbQuestoes.map((dbQuestao) => dbQuestao.toQuestao()).toList();
  }

  @override
  Future<bool> insertQuestao(DataDocument data) async {
    final sucesso = await _dbRemoto.insertQuestao(data);
    if (sucesso) _sincronizarTbQuestoesCaderno(true);
    return sucesso;
  }

  @override
  Future<List<Clube>> getClubes(int idUsuario) async {
    final List<LinViewClubes> dbClubes;
    try {
      dbClubes = await dbLocal.selectClubes;
    } catch (_) {
      return List<Clube>.empty();
    }
    final clubes = dbClubes.map((dbClube) => dbClube.toClube()).toList();
    return clubes;
  }

  @override
  Future<DataClube> insertClube(DataClube data) async {
    final dataClube = await _dbRemoto.insertClube(data);
    if (dataClube.isNotEmpty) _sincronizarTbClubeUsuario(true);
    return dataClube;
  }

  @override
  Future<DataClube> updateClube(DataClube data) async {
    final dataClube = await _dbRemoto.updateClube(data);
    if (dataClube.isNotEmpty) _sincronizarTbClubeUsuario(true);
    return dataClube;
  }

  @override
  Future<DataClube> enterClube(String accessCode, int idUser) async {
    final dataClube = await _dbRemoto.enterClube(accessCode, idUser);
    if (dataClube.isNotEmpty) {
      _sincronizarTbClubeUsuario(true);
      _sincronizarTbQuestaoAtividade(true);
    }
    return dataClube;
  }

  @override
  Future<bool> exitClube(int idClube, int idUser) async {
    final sucesso = await _dbRemoto.exitClube(idClube, idUser);
    if (sucesso) _sincronizarTbClubeUsuario(true);
    return sucesso;
  }

  @override
  Future<bool> updatePermissionUserClube(
      int idClube, int idUser, int idPermission) async {
    final sucesso = await _dbRemoto.updatePermissionUserClube(
        idClube, idUser, idPermission);
    if (sucesso) _sincronizarTbClubeUsuario(true);
    return sucesso;
  }

  @override
  Future<DataCollection> getAtividades(int idClube) async {
    return _dbRemoto.getAtividades(idClube);
  }

  @override
  Future<DataAtividade> insertAtividade(DataAtividade data) async {
    return _dbRemoto.insertAtividade(data);
  }

  @override
  Future<DataAtividade> updateAtividade(DataAtividade dados) async {
    return _dbRemoto.updateAtividade(dados);
  }

  @override
  Future<List<DataRespostaQuestaoAtividade>> getRespostasAtividade(
      int idAtividade,
      [int? idUsuario]) async {
    return _dbRemoto.getRespostasAtividade(idAtividade);
  }

  @override
  Future<bool> upsertRespostasAtividade(
      List<DataRespostaQuestaoAtividade> data) async {
    return _dbRemoto.upsertRespostasAtividade(data);
  }
}

extension _LinTbQuestoesDbRemoto on LinTbQuestoesDbRemoto {
  LinTbQuestoes toDbLocal() {
    final imagens = this.decodificarImagensEnunciado();
    final retorno = LinTbQuestoes(
      id: id,
      enunciado: DbLocal.codificarEnunciado(this.decodificarEnunciado()),
      gabarito: gabarito,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
      imagensEnunciado:
          imagens == null ? null : DbLocal.codificarImagensEnunciado(imagens),
    );
    return retorno;
  }
}

extension _LinTbAssuntosDbRemoto on LinTbAssuntosDbRemoto {
  LinTbAssuntos toDbLocal() {
    final _hierarquia = this.decodificarHierarquia();
    final retorno = LinTbAssuntos(
      id: this.id,
      assunto: this.assunto,
      hierarquia:
          _hierarquia == null ? null : DbLocal.codificarHierarquia(_hierarquia),
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbQuestaoAssuntoDbRemoto on LinTbQuestaoAssuntoDbRemoto {
  LinTbQuestaoAssunto toDbLocal() {
    final retorno = LinTbQuestaoAssunto(
      idQuestao: this.idQuestao,
      idAssunto: this.idAssunto,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbTiposAlternativaDbRemoto on LinTbTiposAlternativaDbRemoto {
  LinTbTiposAlternativa toDbLocal() {
    final retorno = LinTbTiposAlternativa(
      id: this.id,
      tipo: this.tipo,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbAlternativasDbRemoto on LinTbAlternativasDbRemoto {
  LinTbAlternativas toDbLocal() {
    final retorno = LinTbAlternativas(
      idQuestao: this.idQuestao,
      sequencial: this.sequencial,
      idTipo: this.idTipo,
      conteudo: this.conteudo,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbQuestoesCadernoDbRemoto on LinTbQuestoesCadernoDbRemoto {
  LinTbQuestoesCaderno toDbLocal() {
    final retorno = LinTbQuestoesCaderno(
      id: this.id,
      ano: this.ano,
      nivel: this.nivel,
      indice: this.indice,
      idQuestao: this.idQuestao,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbUsuariosDbRemoto on LinTbUsuariosDbRemoto {
  LinTbUsuarios toDbLocal() {
    final retorno = LinTbUsuarios(
      id: this.id,
      email: this.email,
      nome: this.nome,
      foto: this.foto,
      softDelete: this.softDelete,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbClubesDbRemoto on LinTbClubesDbRemoto {
  LinTbClubes toDbLocal() {
    final retorno = LinTbClubes(
      id: this.id,
      nome: this.nome,
      descricao: this.descricao,
      dataCriacao: DbLocal.codificarData(this.decodificarDataCriacao()),
      privado: this.privado,
      codigo: this.codigo,
      capa: this.capa,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbTiposPermissaoDbRemoto on LinTbTiposPermissaoDbRemoto {
  LinTbTiposPermissao toDbLocal() {
    final retorno = LinTbTiposPermissao(
      id: this.id,
      permissao: this.permissao,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbClubeUsuarioDbRemoto on LinTbClubeUsuarioDbRemoto {
  LinTbClubeUsuario toDbLocal() {
    final retorno = LinTbClubeUsuario(
      idClube: this.idClube,
      idUsuario: this.idUsuario,
      idPermissao: this.idPermissao,
      dataAdmissao: DbLocal.codificarData(this.decodificarDataAdmissao()),
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbAtividadesDbRemoto on LinTbAtividadesDbRemoto {
  LinTbAtividades toDbLocal() {
    final retorno = LinTbAtividades(
      id: this.id,
      idClube: this.idClube,
      titulo: this.titulo,
      descricao: this.descricao,
      idAutor: this.idAutor,
      dataCriacao: DbLocal.codificarData(this.decodificarDataCriacao()),
      dataLiberacao: this.dataLiberacao == null
          ? null
          : DbLocal.codificarData(this.decodificarDataLiberacao()!),
      dataEncerramento: this.dataEncerramento == null
          ? null
          : DbLocal.codificarData(this.decodificarDataEncerramento()!),
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbQuestaoAtividadeDbRemoto on LinTbQuestaoAtividadeDbRemoto {
  LinTbQuestaoAtividade toDbLocal() {
    final retorno = LinTbQuestaoAtividade(
      id: this.id,
      idQuestaoCaderno: this.idQuestaoCaderno,
      idAtividade: this.idAtividade,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbRespostaQuestaoAtividadeDbRemoto
    on LinTbRespostaQuestaoAtividadeDbRemoto {
  LinTbRespostaQuestaoAtividade toDbLocal() {
    final retorno = LinTbRespostaQuestaoAtividade(
      idQuestaoAtividade: this.idQuestaoAtividade,
      idUsuario: this.idUsuario,
      resposta: this.resposta,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
    );
    return retorno;
  }
}

extension _LinTbRespostaQuestaoDbRemoto on LinTbRespostaQuestaoDbRemoto {
  LinTbRespostaQuestao toDbLocal() {
    final retorno = LinTbRespostaQuestao(
      idQuestao: this.idQuestao,
      idUsuario: this.idUsuario,
      resposta: this.resposta,
      dataModificacao: DbLocal.codificarData(this.decodificarDataModificacao()),
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
  /* LinTbAssuntosDbRemoto toDbRemoto() {
    final _hierarquia = (jsonDecode(this.hierarquia!) as List?)?.cast<int>();
    final _dataModificacao = DateTime.fromMillisecondsSinceEpoch(
      this.dataModificacao,
      isUtc: true,
    ).toIso8601String();
    final retorno = LinTbAssuntosDbRemoto(
      id: this.id,
      assunto: this.assunto,
      hierarquia: _hierarquia,
      dataModificacao: _dataModificacao,
    );
    return retorno;
  } */
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

extension _LinViewQuestoes on LinViewQuestoes {
  Questao toQuestao() {
    final _imagensEnunciado = imagensEnunciado == null
        ? null
        : DbLocal.decodificarImagensEnunciado(imagensEnunciado!)
            ?.map((e) => ImagemQuestao.fromMap(e))
            .toList();
    return Questao(
      id: id,
      ano: Ano(ano),
      nivel: Nivel(nivel),
      indice: indice,
      assuntos: assuntos.map((e) => e.toAssunto()).toList(),
      enunciado: DbLocal.decodificarEnunciado(enunciado) ?? [],
      alternativas: alternativas.map((e) => e.toAlternativa()).toList(),
      gabarito: gabarito,
      imagensEnunciado: _imagensEnunciado ?? [],
    );
  }
}

extension _LinViewClubes on LinViewClubes {
  Clube toClube() {
    return Clube.fromDataClube({
      DbConst.kDbDataClubeKeyId: id,
      DbConst.kDbDataClubeKeyNome: nome,
      DbConst.kDbDataClubeKeyDescricao: descricao,
      DbConst.kDbDataClubeKeyProprietario: proprietario,
      DbConst.kDbDataClubeKeyAdministradores: administradores,
      DbConst.kDbDataClubeKeyMembros: membros,
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

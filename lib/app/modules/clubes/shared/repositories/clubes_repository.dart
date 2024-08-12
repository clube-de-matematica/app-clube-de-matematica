import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../services/db_servicos_interface.dart';
import '../../../../shared/models/debug.dart';
import '../../../../shared/repositories/id_base62.dart';
import '../../../perfil/models/userapp.dart';
import '../../../quiz/shared/models/questao_model.dart';
import '../../modules/atividades/models/atividade.dart';
import '../../modules/atividades/models/questao_atividade.dart';
import '../../modules/atividades/models/resposta_questao_atividade.dart';
import '../models/clube.dart';
import '../models/usuario_clube.dart';

part 'clubes_repository.g.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere aos clubes.
class ClubesRepository = ClubesRepositoryBase with _$ClubesRepository;

abstract class ClubesRepositoryBase with Store implements Disposable {
  final IDbServicos dbServicos;
  final _disposers = <ReactionDisposer>[];

  ClubesRepositoryBase(this.dbServicos) {
    _assinaturaClubes = dbServicos.obterClubes().listen((clubes) {
      this.clubes
        ..removeAll(this.clubes.difference(clubes.toSet()))
        ..addAll(clubes);
    });
  }

  late final StreamSubscription _assinaturaClubes;

  UserApp get usuarioApp => UserApp.instance;

  /// {@macro app._ObservableSetClubes}
  final ObservableSetClubes clubes = ObservableSetClubes();

  /// {@macro app.IDbServicos.sincronizarClubes}
  Future<void> sincronizarClubes() => dbServicos.sincronizarClubes();

  /// Criar um novo clube com as informações dos parâmetros.
  /// Se o processo for bem sucedido, retorna o [Clube] criado.
  @action
  Future<Clube?> criarClube(RawClube dados) async {
    if (usuarioApp.id == null) return null;
    final proprietario = RawUsuarioClube(
      id: usuarioApp.id,
      permissao: PermissoesClube.proprietario,
    );
    final codigo = IdBase62.getIdClube();
    final clube = await dbServicos.inserirClube(
      dados.copyWith(
        codigo: codigo,
        usuarios: [proprietario, ...?dados.usuarios],
      ),
    );
    return clube;
  }

  /// Remove [usuario] de [clube].
  Future<bool> removerDoClube(Clube clube, UsuarioClube usuario) async {
    if (usuarioApp.id == null) return false;
    if (clube.id != usuario.idClube) return false;
    final sucesso = await dbServicos.removerUsuarioClube(clube.id, usuario.id);
    return sucesso;
  }

  /// Remove de [clube] o usuário atual.
  @action
  Future<bool> sairClube(Clube clube) async {
    if (usuarioApp.id == null) return false;
    final usuario = clube.getUsuario(usuarioApp.id!);
    if (usuario == null) return false;
    if (usuario.proprietario) return false;
    final sucesso = await removerDoClube(clube, usuario);
    return sucesso;
  }

  /// Inclui o usuário atual no clube correspondente a [codigo].
  /// Se o processo for bem sucedido, retorna o [Clube] correspondente.
  @action
  Future<Clube?> entrarClube(String codigo) async {
    final clube = await dbServicos.entrarClube(codigo);
    return clube;
  }

  /// Atualiza os dados do clube que foram modificados.
  @action
  Future<bool> atualizarClube({
    required Clube clube,
    required String nome,
    required String codigo,
    String? descricao,
    required Color capa,
    required bool privado,
  }) async {
    if (usuarioApp.id == null) return false;

    if (descricao?.isEmpty ?? false) descricao = null;

    final atualizarDescricao = clube.descricao != descricao;
    final atualizarCapa = clube.capa.value != capa.value;
    final atualizarNome = clube.nome != nome;
    final atualizarCodigo = clube.codigo != codigo;
    final atualizarPrivado = clube.privado != privado;

    if (!atualizarNome &&
        !atualizarCodigo &&
        !atualizarPrivado &&
        !atualizarCapa &&
        !atualizarDescricao) {
      assert(Debug.print('[ATTENTION] Não há dados para serem atualizados.'));
      return true;
    }

    final dados = RawClube(
      id: clube.id,
      nome: atualizarNome ? nome : null,
      codigo: atualizarCodigo ? codigo : null,
      privado: atualizarPrivado ? privado : null,
      // Como `null` é um valor válido para a descrição, para não ser atualizada,
      // ela deve ser envida como uma string vazia,
      descricao: atualizarDescricao ? descricao : '',
      capa: capa, // atualizarCapa ? capa : null,
    );

    final clubeAtualizado = await dbServicos.atualizarClube(dados);
    return clubeAtualizado == null ? false : true;
  }

  /// Atualiza a permissão do [usuario] para [permissao] em [clube].
  Future<bool> atualizarPermissaoClube({
    required Clube clube,
    required UsuarioClube usuario,
    required PermissoesClube permissao,
  }) async {
    if (usuarioApp.id == null) return false;
    if (clube.id != usuario.idClube) return false;
    if (usuario.permissao == permissao) return true;
    final sucesso = await dbServicos.atualizarPermissaoUsuarioClube(
        clube.id, usuario.id, permissao.id);
    return sucesso;
  }

  Future<bool> excluirClube(Clube clube) => dbServicos.excluirClube(clube);

  /// Retorna um [Stream] para a lista de atividades do [clube].
  Stream<List<Atividade>> atividades(Clube clube) {
    return dbServicos.obterAtividades(clube);
  }

  /// {@macro app.IDbRepository.insertAtividade}
  Future<bool> criarAtividade({
    required Clube clube,
    required String titulo,
    String? descricao,
    List<Questao>? questoes,
    required DateTime dataLiberacao,
    DateTime? dataEncerramento,
  }) async {
    if (usuarioApp.id == null) return false;
    assert(!dataLiberacao.isBefore(DateUtils.dateOnly(DateTime.now())));
    assert(
        dataEncerramento == null || !dataEncerramento.isBefore(dataLiberacao));
    final idAutor = usuarioApp.id!;
    if (!clube.permissaoCriarAtividade(idAutor)) return false;
    if (questoes != null && questoes.isEmpty) questoes = null;
    final atividade = await dbServicos.inserirAtividade(
      RawAtividade(
        idClube: clube.id,
        idAutor: idAutor,
        titulo: titulo,
        descricao: descricao,
        questoes: questoes
            ?.map((questao) =>
                RawQuestaoAtividade(idQuestao: questao.idAlfanumerico))
            .toList(),
        liberacao: dataLiberacao,
        encerramento: dataEncerramento,
      ),
    );

    return atividade == null ? false : true;
  }

  /// {@macro app.IDbRepository.updateAtividade}
  Future<bool> atualizarAtividade({
    required Atividade atividade,
    required String titulo,
    String? descricao,
    List<Questao>? questoes,
    required DateTime dataLiberacao,
    DateTime? dataEncerramento,
  }) async {
    if (usuarioApp.id == null) return false;
    //assert(!dataLiberacao.isBefore(DateUtils.dateOnly(DateTime.now())));
    //assert(dataEncerramento == null || !dataEncerramento.isBefore(dataLiberacao));
    final permitirUsuario = atividade.idAutor == usuarioApp.id!;
    assert(permitirUsuario);
    if (questoes != null && questoes.isEmpty) questoes = null;
    final atividadeAtualizada = await dbServicos.atualizarAtividade(
      RawAtividade(
        id: atividade.id,
        titulo: titulo,
        descricao: descricao,
        questoes: questoes
            ?.map((questao) =>
                RawQuestaoAtividade(idQuestao: questao.idAlfanumerico))
            .toList(),
        liberacao: dataLiberacao,
        encerramento: dataEncerramento,
      ),
    );

    return atividadeAtualizada == null ? false : true;
  }

  Future<bool> excluirAtividade(Atividade atividade) =>
      dbServicos.excluirAtividade(atividade);

  Future<void> carregarQuestoesAtividade(Atividade atividade) async {
    if (usuarioApp.id == null) return;
    final questoes = await dbServicos.obterQuestoesAtividade(atividade);
    atividade.questoes
      ..clear()
      ..addAll(questoes);
    return;
  }

  /// {@macro app.IDbRepository.upsertRespostasAtividade}
  Future<bool> atualizarInserirRespostaAtividade(Atividade atividade) async {
    if (usuarioApp.id == null) return false;
    final List<RawRespostaQuestaoAtividade> dados = [];
    for (var questao in atividade.questoes) {
      final resposta = questao.resposta(usuarioApp.id!);
      if (resposta != null) {
        dados.add(RawRespostaQuestaoAtividade(
          idQuestaoAtividade: resposta.idQuestaoAtividade,
          idUsuario: resposta.idUsuario,
          sequencial: resposta.sequencialTemporario,
        ));
      }
    }
    final retorno = await dbServicos.salvarRespostasAtividade(dados);
    return retorno;
  }

  /// Encerrar as reações em execução.
  @override
  void dispose() {
    _assinaturaClubes.cancel();
    _disposers
      ..forEach((element) => element())
      ..clear();
  }
}

/// {@template app._ObservableSetClubes}
/// Conjunto com os [Clube] do usuário.
/// {@endtemplate}
class ObservableSetClubes extends ObservableSet<Clube> {
  @override
  bool contains(Object? element) {
    if (element is Clube) {
      return where((e) => e.id == element.id).isNotEmpty;
    }
    return false;
  }

  @override
  bool add(Clube value) => _add(value);

  @action
  bool _add(Clube clube) {
    try {
      firstWhere((e) => e.id == clube.id).mesclar(clube);
      return true;
    } on StateError catch (_) {
      return super.add(clube);
    }
  }

  @override
  bool remove(Object? value) {
    if (value is Clube) return _remove(value);
    return false;
  }

  @action
  bool _remove(Clube clube) {
    try {
      return super.remove(firstWhere((e) => e.id == clube.id));
    } on StateError catch (_) {
      return false;
    }
  }

  @override
  Set<Clube> intersection(Set<Object?> other) {
    Set<Clube> resultado = toSet();
    resultado.removeWhere(
      (clube) => !other.any((e) => e is Clube && e.id == clube.id),
    );
    return resultado;
  }

  @override
  Set<Clube> difference(Set<Object?> other) {
    Set<Clube> resultado = toSet();
    resultado.removeWhere(
      (clube) => other.any((e) => e is Clube && e.id == clube.id),
    );
    return resultado;
  }
}

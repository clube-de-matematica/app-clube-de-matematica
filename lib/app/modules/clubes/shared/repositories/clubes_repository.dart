import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/models/debug.dart';
import '../../../../shared/repositories/id_base62.dart';
import '../../../../shared/repositories/interface_db_repository.dart';
import '../../../../shared/utils/strings_db.dart';
import '../../../perfil/models/userapp.dart';
import '../../../quiz/shared/models/questao_model.dart';
import '../../modules/atividades/models/atividade.dart';
import '../../modules/atividades/models/resposta_questao_atividade.dart';
import '../models/clube.dart';
import '../models/usuario_clube.dart';

part 'clubes_repository.g.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere aos clubes.
class ClubesRepository = _ClubesRepositoryBase with _$ClubesRepository;

abstract class _ClubesRepositoryBase with Store implements Disposable {
  final IDbRepository dbRepository;
  final UserApp usuarioApp;
  final _disposers = <ReactionDisposer>[];

  _ClubesRepositoryBase(this.dbRepository, this.usuarioApp) {
    _disposers.add(
      autorun(
        (_) {
          if (usuarioApp.id == null)
            _cleanClubes();
          else
            carregarClubes();
        },
      ),
    );
  }

  /// Lista com os clubes já carregadas.
  @observable
  ObservableList<Clube> _clubes = <Clube>[].asObservable();

  /// Lista com os clubes já carregadas.
  @computed
  List<Clube> get clubes => _clubes;

  /// Lista com os clubes já carregadas.
  /// A [Reaction] `asyncWhen` é usada para esperar uma condição em um [Observable].
  /// Ficará ativa até que a condição seja satisfeita pela primeira vez.
  /// Após isso ela executa o seu método `dispose`.
  Future<List<Clube>> get clubesAsync =>
      asyncWhen((_) => _clubes.isNotEmpty).then((_) => _clubes);

  /// Adiciona um novo [Clube] a [clubes].
  @action
  void _addInClubes(Clube clube) {
    if (!_existeClube(clube.id)) _clubes.add(clube);
  }

  /// Limpar a lista de clubes.
  @action
  void _cleanClubes() => _clubes.clear();

  /// Retorna `true` se um [Clube] com o mesmo [id] já tiver sido instanciado.
  /// O método `any()` executa um `for` nos elementos de [clubes].
  /// O loop é interrompido assim que a condição for verdadeira.
  bool _existeClube(int id) {
    if (_clubes.isEmpty)
      return false;
    else
      return _clubes.any((element) => element.id == id);
  }

  // Assim o [Observable] notificará apenas ao final da execução do método.
  /// Buscar os clubes no banco de dados e carregar na lista [clubes],
  /// atualizando os clubes quando já estiverem na lista.
  /// Retornará uma lista vazia se o usuário não estiver logado ou ocorrer algum erro ao buscar os dados.
  @action
  Future<List<Clube>> carregarClubes() async {
    if (usuarioApp.id == null) return List<Clube>.empty();
    DataCollection resultado;
    try {
      // Aguardar o retorno dos clubes.
      resultado = await dbRepository.getClubes(usuarioApp.id!);
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro a buscar os dados da coleção ${CollectionType.clubes.name}."));
      assert(Debug.print(e));
      return List<Clube>.empty();
    }
    if (resultado.isEmpty) return List<Clube>.empty();

    final temp = List<Clube>.from(
        resultado.map((dataClube) => Clube.fromDataClube(dataClube)));

    _clubes.removeWhere(
      (clube) => temp.any(
        (clubeTemp) => clubeTemp.id == clube.id,
      ),
    );

    temp.forEach((clubeTemp) {
      try {
        _clubes
            .firstWhere((clube) => clube.id == clubeTemp.id)
            .sobrescrever(clubeTemp);
      } catch (_) {
        // Não será emitido várias notificações, pois `carregarClubes` também é um `action`.
        _addInClubes(clubeTemp);
      }
    });

    return _clubes;
  }

  /// Criar um novo clube com as informações dos parâmetros.
  /// Se o processo for bem sucedido, retorna o [Clube] criado.
  @action
  Future<Clube?> criarClube(
    String nome,
    String? descricao,
    String? capa,
    bool privado, {
    List<int>? administradores,
    List<int>? membros,
  }) async {
    if (usuarioApp.id == null) return null;
    final proprietario = usuarioApp.id!;
    final codigo = IdBase62.getIdClube();
    final dataClube = await dbRepository.insertClube(
      nome: nome,
      proprietario: proprietario,
      codigo: codigo,
      descricao: descricao,
      privado: privado,
      administradores: administradores,
      membros: membros,
      capa: capa,
    );
    if (dataClube.isNotEmpty) {
      final clube = Clube.fromDataClube(dataClube);
      _addInClubes(clube);
      return clube;
    } else {
      return null;
    }
  }

  /// Remove [usuario] de [clube].
  Future<bool> removerDoClube(Clube clube, UsuarioClube usuario) async {
    if (usuarioApp.id == null) return false;
    if (clube.id != usuario.idClube) return false;
    final sucesso = await dbRepository.exitClube(clube.id, usuario.id);
    if (sucesso) {
      clube.removerUsuarios([usuario]);
      return true;
    } else {
      return false;
    }
  }

  /// Remove de [clube] o usuário atual.
  @action
  Future<bool> sairClube(Clube clube) async {
    if (usuarioApp.id == null) return false;
    final usuario = clube.getUsuario(usuarioApp.id!);
    if (usuario == null) return false;
    if (usuario.proprietario) return false;
    final sucesso = await removerDoClube(clube, usuario);
    if (sucesso) {
      _clubes.remove(clube);
      return true;
    } else {
      return false;
    }
  }

  /// Inclui o usuário atual no clube correspondente a [codigo].
  /// Se o processo for bem sucedido, retorna o [Clube] correspondente.
  @action
  Future<Clube?> entrarClube(String codigo) async {
    if (usuarioApp.id == null) return null;
    final dataClube = await dbRepository.enterClube(codigo, usuarioApp.id!);
    if (dataClube.isNotEmpty) {
      final temp = Clube.fromDataClube(dataClube);
      final indice = _clubes.indexWhere((clube) => clube.id == temp.id);
      if (indice == -1) {
        _addInClubes(temp);
        return temp;
      } else {
        final clube = _clubes[indice];
        clube.sobrescrever(temp);
        return clube;
      }
    } else {
      return null;
    }
  }

  /// Atualiza os dados do clube que foram modificados.
  @action
  Future<Clube?> atualizarClube({
    required Clube clube,
    required String nome,
    required String codigo,
    String? descricao,
    required Color capa,
    required bool privado,
  }) async {
    if (usuarioApp.id == null) return null;

    if (descricao?.isEmpty ?? false) descricao = null;
    final atualizarDescricao = clube.descricao != descricao;
    // Como `null` é um valor válido para a descrição, para não ser atualizada,
    // ela deve ser envida como uma string vazia,
    if (!atualizarDescricao) descricao = '';

    final atualizarCapa = clube.capa.value != capa.value;
    // Como `null` é um valor válido para a capa, para não ser atualizada,
    // ela deve ser envida como uma string vazia,
    final dataCapa = atualizarCapa ? '${capa.value}' : '';

    final DataClube dados = {
      if (clube.nome != nome) DbConst.kDbDataClubeKeyNome: nome,
      if (clube.codigo != codigo) DbConst.kDbDataClubeKeyCodigo: codigo,
      if (clube.privado != privado) DbConst.kDbDataClubeKeyPrivado: privado,
    };
    if (dados.isEmpty && !atualizarCapa && !atualizarDescricao) {
      assert(Debug.print('[ATTENTION] Não há dados para serem atualizados.'));
      return clube;
    }
    dados[DbConst.kDbDataClubeKeyId] = clube.id;
    dados[DbConst.kDbDataClubeKeyDescricao] = descricao;
    dados[DbConst.kDbDataClubeKeyCapa] = dataCapa;

    final dataResult = await dbRepository.updateClube(dados);
    if (dataResult.isNotEmpty) {
      final temp = Clube.fromDataClube(dataResult);
      final indice = _clubes.indexWhere((clube) => clube.id == temp.id);
      if (indice == -1) {
        return null;
      } else {
        final clube = _clubes[indice];
        clube.sobrescrever(temp);
        return clube;
      }
    } else {
      return null;
    }
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
    final sucesso = await dbRepository.updatePermissionUserClube(
        clube.id, usuario.id, permissao.id);
    if (sucesso) {
      usuario.permissao = permissao;
      return true;
    } else {
      return false;
    }
  }

  Future<List<Atividade>> carregarAtividades(Clube clube) async {
    if (usuarioApp.id == null) return List<Atividade>.empty();
    DataCollection resultado;
    try {
      resultado = await dbRepository.getAtividades(clube.id);
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro ao buscar os dados da coleção ${CollectionType.atividades.name}."));
      assert(Debug.print(e));
      return List<Atividade>.empty();
    }
    if (resultado.isEmpty) return List<Atividade>.empty();

    final temp = List<Atividade>.from(resultado
        .map((dataAtividade) => Atividade.fromDataAtividade(dataAtividade)));

    clube.sobrescrever(clube.copyWith(atividades: temp));

    return clube.atividades;
  }

  /// {@macro app.IDbRepository.insertAtividade}
  Future<Atividade?> criarAtividade({
    required Clube clube,
    required String titulo,
    String? descricao,
    List<Questao>? questoes,
    required DateTime dataLiberacao,
    DateTime? dataEncerramento,
  }) async {
    if (usuarioApp.id == null) return null;
    assert(!dataLiberacao.isBefore(DateUtils.dateOnly(DateTime.now())));
    assert(
        dataEncerramento == null || !dataEncerramento.isBefore(dataLiberacao));
    final idAutor = usuarioApp.id!;
    if (!clube.permissaoCriarAtividade(idAutor)) return null;
    if (questoes != null && questoes.isEmpty) questoes = null;
    final dataAtividade = await dbRepository.insertAtividade(
      idClube: clube.id,
      idAutor: idAutor,
      titulo: titulo,
      descricao: descricao,
      questoes: questoes?.map((questao) => questao.id).toList(),
      dataLiberacao: dataLiberacao,
      dataEncerramento: dataEncerramento,
    );
    if (dataAtividade.isNotEmpty) {
      final atividade = Atividade.fromDataAtividade(dataAtividade);
      clube.addAtividade(atividade);
      return atividade;
    } else {
      return null;
    }
  }

  /// {@macro app.IDbRepository.updateAtividade}
  Future<Atividade?> atualizarAtividade({
    required Atividade atividade,
    required String titulo,
    String? descricao,
    List<Questao>? questoes,
    required DateTime dataLiberacao,
    DateTime? dataEncerramento,
  }) async {
    if (usuarioApp.id == null) return null;
    assert(!dataLiberacao.isBefore(DateUtils.dateOnly(DateTime.now())));
    assert(
        dataEncerramento == null || !dataEncerramento.isBefore(dataLiberacao));
    final permitirUsuario = atividade.idAutor == usuarioApp.id!;
    assert(permitirUsuario);
    if (questoes != null && questoes.isEmpty) questoes = null;
    final dataAtividade = await dbRepository.updateAtividade(
      id: atividade.id,
      titulo: titulo,
      descricao: descricao,
      questoes: questoes?.map((questao) => questao.id).toList(),
      dataLiberacao: dataLiberacao,
      dataEncerramento: dataEncerramento,
    );
    if (dataAtividade.isNotEmpty) {
      atividade.sobrescrever(Atividade.fromDataAtividade(dataAtividade));
      return atividade;
    } else {
      return null;
    }
  }

  Future<Atividade?> carregarRespostasAtividade(Atividade atividade) async {
    if (usuarioApp.id == null) return null;
    List<DataRespostaQuestaoAtividade> dataRespostas;
    try {
      dataRespostas = await dbRepository.getRespostasAtividade(
        atividade.id,
        atividade.idAutor == usuarioApp.id ? null : usuarioApp.id!,
      );
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro ao buscar os dados da coleção ${CollectionType.respostasQuestaoAtividade.name}."));
      assert(Debug.print(e));
      return null;
    }
    if (dataRespostas.isNotEmpty) {
      // Carregar as respostas.
      atividade.respostas
        ..clear()
        ..addAll(
          dataRespostas.map((dados) =>
              RespostaQuestaoAtividade.fromDataRespostaQuestaoAtividade(dados)),
        );
    }
    return atividade;
  }

  /// {@macro app.IDbRepository.upsertRespostasAtividade}
  Future<bool> atualizarInserirRespostaAtividade(Atividade atividade) async {
    if (usuarioApp.id == null) return false;
    debugger(); //TODO
    final List<Map<String, int?>> dados = [];
    atividade.questoes.forEach((questao) {
      final resposta = questao.resposta(usuarioApp.id!);
      if (resposta != null) {
        dados.add(
          resposta
              .copyWith(sequencial: resposta.sequencialTemporario)
              .toDataRespostaQuestaoAtividade(),
        );
      }
    });
    bool retorno;
    try {
      retorno = await dbRepository.upsertRespostasAtividade(dados);
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro ao inserir os dados na coleção ${CollectionType.respostasQuestaoAtividade.name}."));
      assert(Debug.print(e));
      return false;
    }
    return retorno;
  }

  /// Encerrar as reações em execução.
  @override
  void dispose() {
    _disposers
      ..forEach((element) => element())
      ..clear();
  }
}

import 'dart:developer';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../modules/filtros/shared/models/filtros_model.dart';
import '../../modules/quiz/shared/models/ano_questao_model.dart';
import '../../modules/quiz/shared/models/assunto_model.dart';
import '../../modules/quiz/shared/models/nivel_questao_model.dart';
import '../../modules/quiz/shared/models/questao_model.dart';
import '../../navigation.dart';
import '../repositories/questoes/questoes_repository.dart';
import 'debug.dart';
import 'exibir_questao_controller.dart';

part 'exibir_questao_com_filtro_controller.g.dart';

/// Base do controle de páginas que exibem questões e têm a opção de filtrar.
/// * Para páginas sem a opção de filtrar, veja [ExibirQuestaoController].
class ExibirQuestaoComFiltroController = _ExibirQuestaoComFiltroControllerBase
    with _$ExibirQuestaoComFiltroController;

abstract class _ExibirQuestaoComFiltroControllerBase
    extends ExibirQuestaoController with Store implements Disposable {
  final Filtros filtros;
  final QuestoesRepository _questoesRepository;
  final _disposers = <ReactionDisposer>[];

  _ExibirQuestaoComFiltroControllerBase({
    required this.filtros,
    required QuestoesRepository questoesRepository,
  }) : _questoesRepository = questoesRepository {
    _disposers.addAll([
      autorun((_) {
        debugger(); //TODO
        questaoAtual.then((value) {
          debugger(); //TODO
          if (value == null && indice != -1)
            definirIndice(-1, forcar: true);
          else if (value != null && indice == -1)
            definirIndice(0, forcar: true);
        });
      }),
      autorun((_) {
        debugger(); //TODO
        _questoesRepository
            .nunQuestoes(
          anos: filtros.anos.map((e) => (e.opcao as Ano).valor).toList(),
          niveis: filtros.anos.map((e) => (e.opcao as Nivel).valor).toList(),
          assuntos: filtros.anos.map((e) => (e.opcao as Assunto).id).toList(),
        )
            .then((valor) {
          if (numQuestoes != valor) numQuestoes = valor;
        }).catchError((erro) {
          assert(Debug.printBetweenLine(erro.toString()));
        });
      }),
    ]);
  }

  /// Encerrar as [Reaction] em execução.
  @override
  void dispose() {
    _disposers
      ..forEach((element) => element())
      ..clear();
  }

  /// Ação executada para abrir a página de filtro.
  /// Retornará o objeto [Filtros] resultante.
  Future<Filtros> abrirPaginaFiltros(BuildContext context) async {
    final Filtros? retorno = await Navegacao.abrirPagina<Filtros>(
      context,
      RotaPagina.filtrosTipos,
      argumentos: filtros,
    );
    return retorno ?? filtros;
  }

  /// Limpa os filtros selecionados.
  void limparFiltros() => filtros.limpar();

  /// [Questao] anterior a [questaoAtual].
  late ObservableFuture<Questao?> _questaoAnterior = _questao(-1);

  @observable
  late ObservableFuture<Questao?> _questaoAtual = _questao(0);

  @override
  @computed
  ObservableFuture<Questao?> get questaoAtual => _questaoAtual;

  /// [Questao] seguinte a [questaoAtual].
  late ObservableFuture<Questao?> _questaoSeguinte = _questao(1);

  ObservableFuture<Questao?> _questao(int indice) {
    if (indice < 0) return Future.value(null).asObservable();
    return _questoesRepository
        .questoes(
          anos: filtros.anos.map((e) => (e.opcao as Ano).valor).toList(),
          niveis: filtros.anos.map((e) => (e.opcao as Nivel).valor).toList(),
          assuntos: filtros.anos.map((e) => (e.opcao as Assunto).id).toList(),
          limit: 1,
          offset: indice,
        )
        .then((value) => value.isEmpty ? null : value[0])
        .catchError((erro) {
      assert(Debug.printBetweenLine(erro.toString()));
      return null;
    }).asObservable();
  }

  @override
  @action
  void voltar() {
    if (podeVoltar) {
      final novoIndice = indice - 1;
      _questaoSeguinte = _questaoAtual;
      _questaoAtual = _questaoAnterior;
      _questaoAnterior = _questao(novoIndice - 1);
      definirIndice(novoIndice);
    }
  }

  @override
  @action
  void avancar() {
    if (podeAvancar) {
      final novoIndice = indice + 1;
      _questaoAnterior = _questaoAtual;
      _questaoAtual = _questaoSeguinte;
      _questaoSeguinte = _questao(novoIndice + 1);
      definirIndice(novoIndice);
    }
  }

  @override
  @action
  void definirIndice(int valor, {bool forcar = false}) {
    if (indice != valor || forcar) {
      debugger(); //TODO
      if (pow(valor - indice, 2) > 1) {
        _questaoAnterior = _questao(valor - 1);
        _questaoAtual = _questao(valor);
        _questaoSeguinte = _questao(valor + 1);
      }
      super.definirIndice(valor, forcar: forcar);
    }
  }
}

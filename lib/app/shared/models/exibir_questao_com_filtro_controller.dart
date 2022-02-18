import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../modules/filtros/shared/models/filtros_model.dart';
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
  final QuestoesRepository repositorio;
  final _disposers = <ReactionDisposer>[];

  _ExibirQuestaoComFiltroControllerBase({
    required this.filtros,
    required this.repositorio,
  }) {
    _disposers.addAll([
      autorun((_) {
        if (_numQuestoesAssinc.status != FutureStatus.pending) {
          numQuestoes = _numQuestoesAssinc.value ?? 0;
        }
      }),
    ]);
  }

  @computed
  ObservableFuture<int> get _numQuestoesAssinc {
    return repositorio.nunQuestoes(
      // Se os filtros forem passados por referência a reação não é disparada, pois o
      // observável não estará sendo lido.
      anos: [...filtros.anos],
      niveis: [...filtros.niveis],
      assuntos: [...filtros.assuntos],
    )
        //.then((value) => numQuestoes = value)
        .catchError((erro) {
      assert(Debug.printBetweenLine(erro.toString()));
      return numQuestoes = 0;
    }).asObservable();
  }

  @override
  @computed
  int get numQuestoes {
    final numAssinc = _numQuestoesAssinc;
    if (numAssinc.status != FutureStatus.pending) {
      return numAssinc.value ?? 0;
    }
    return super.numQuestoes;
  }

  /// Encerrar as [Reaction] em execução.
  @override
  void dispose() {
    _disposers
      ..forEach((element) => element())
      ..clear();
    super.dispose();
  }

  /// Ação executada para abrir a página de filtro.
  /// Retornará o objeto [Filtros] resultante.
  @action
  Future<Filtros> abrirPaginaFiltros(BuildContext context) async {
    final Filtros? retorno = await Navegacao.abrirPagina<Filtros>(
      context,
      RotaPagina.filtros,
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
  ObservableFuture<Questao?> get questaoAtual {
    if (_numQuestoesAssinc.status != FutureStatus.pending) return _questaoAtual;
    // Garantir que o retorno será concluído após [_numQuestoesAssinc].
    return Future.wait([
      _numQuestoesAssinc,
      _questao(0),
    ]).then((value) => value[1] as Questao?).asObservable();
  }

  /// [Questao] seguinte a [questaoAtual].
  late ObservableFuture<Questao?> _questaoSeguinte = _questao(1);

  ObservableFuture<Questao?> _questao(int indice) {
    if (indice < 0) return Future.value(null).asObservable();
    return repositorio
        .questoes(
          anos: filtros.anos,
          niveis: filtros.niveis,
          assuntos: filtros.assuntos,
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
      if (pow(valor - indice, 2) > 1 || forcar) {
        _questaoAnterior = _questao(valor - 1);
        _questaoAtual = _questao(valor);
        _questaoSeguinte = _questao(valor + 1);
      }
      super.definirIndice(valor, forcar: forcar);
    }
  }

  /// {@macro app.ExibirQuestaoController.indice}
  @override
  @computed
  int get indice => super.indice;
}

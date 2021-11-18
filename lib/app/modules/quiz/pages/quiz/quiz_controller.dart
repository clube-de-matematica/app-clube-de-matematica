import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/repositories/questoes/imagem_questao_repository.dart';
import '../../../../shared/models/exibir_questao_controller.dart';
import '../../../filtros/shared/models/filtros_model.dart';
import '../../shared/models/opcoesQuestao.dart';
import '../../shared/models/questao_model.dart';

part 'quiz_controller.g.dart';

class QuizController = _QuizControllerBase with _$QuizController;

abstract class _QuizControllerBase extends ExibirQuestaoController with Store {
  _QuizControllerBase(
      ImagemQuestaoRepository imagemQuestaoRepository, Filtros filtros)
      : super(
          imagemQuestaoRepository: imagemQuestaoRepository,
          filtros: filtros,
        );

  /// O sequencial da altenativa selecionada em [questao].
  @observable
  int? alternativaSelecionada; //TODO

  /// Questões disponíveis para exibição.
  @computed
  List<Questao> get questoesFiltradas => filtros.itensFiltrados;

//TODO
  /* /// Atribui um novo valor para [_indice].
  /// Se [force] for `true`, [valor] será aplicado independentemente do valor atual de [_indice].
  @action
  void _setIndice(int valor, {bool force = false}) {
    if (_indice != valor || force) {
      _indice = valor;
      alternativaSelecionada = null;
      _carregarImagens();
    }
  } */

  /// Retorna um `bool` que define se há uma resposta a ser confirmada.
  @computed
  bool get podeConfirmar => alternativaSelecionada != null;

  /// Ações a serem executada ao confirmar uma resposta.
  void confirmar() {
    avancar();
  }

  /// Retorna a opção escolhida pelo usuário dentre as opções disponíveis para a questão.
  Future<void> setOpcaoItem(BuildContext context, OpcoesQuestao opcao) async {
    switch (opcao) {
      case OpcoesQuestao.none:
      case OpcoesQuestao.filter:
        await abrirPaginaFiltros(context);
    }
  }
}

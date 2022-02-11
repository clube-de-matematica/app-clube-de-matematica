import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/models/exibir_questao_com_filtro_controller.dart';
import '../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../../filtros/shared/models/filtros_model.dart';
import '../../../perfil/models/userapp.dart';
import '../../shared/models/alternativa_questao_model.dart';
import '../../shared/models/opcoesQuestao.dart';
import '../../shared/models/questao_model.dart';
import '../../shared/models/resposta_questao.dart';

part 'quiz_controller.g.dart';

class QuizController = _QuizControllerBase with _$QuizController;

abstract class _QuizControllerBase extends ExibirQuestaoComFiltroController
    with Store {
  _QuizControllerBase({
    required Filtros filtros,
    required QuestoesRepository repositorio,
  }) : super(
          filtros: filtros,
          repositorio: repositorio,
        );

  @override
  @computed
  ObservableFuture<Questao?> get questaoAtual {
    if (super.questaoAtual.status != FutureStatus.fulfilled) {
      _definirResposta(null);
    }
    final retorno = super.questaoAtual.then((questao) async {
      if (questao != null) {
        var resposta = await repositorio.obterResposta(questao);
        resposta ??= RespostaQuestao(
          idQuestao: questao.id,
          idUsuario: UserApp.instance.id,
          sequencial: null,
        );
        _definirResposta(resposta);
      }
      return questao;
    });
    return retorno;
  }

  @readonly
  RespostaQuestao? _resposta;

  /// Definir [_resposta] como [valor].
  @action
  void _definirResposta(RespostaQuestao? valor) {
    if (_resposta != valor) {
      _resposta = valor;
    }
  }

  /// O sequencial da altenativa selecionada em [questaoAtual].
  @computed
  int? get alternativaSelecionada => _resposta?.sequencialTemporario;

  /// Salvar no banco de dados a resposta dada à questão em exibição.
  void _salvarResposta() async {
    final salvo = _resposta?.sequencial;
    final temp = _resposta?.sequencialTemporario;
    if (salvo != temp) {
      repositorio.inserirRespostaQuestao(RawRespostaQuestao(
        idQuestao: _resposta?.idQuestao,
        idUsuario: _resposta?.idUsuario,
        sequencial: temp,
      ));
    }
  }

  /// Modifica [_resposta] para corresponder a [alternativa] e salva as alterações no
  /// banco de dados.
  void definirAlternativaSelecionada(Alternativa? alternativa) {
    _resposta?.sequencialTemporario = alternativa?.sequencial;
    _salvarResposta();
  }

  /// Verificar os erros e acertos na lista de questões filtradas.
  void concluir() {}

  /// Retorna a opção escolhida pelo usuário dentre as opções disponíveis para a questão.
  Future<void> setOpcaoItem(BuildContext context, OpcoesQuestao opcao) async {
    switch (opcao) {
      case OpcoesQuestao.none:
      /* case OpcoesQuestao.filter:
        await abrirPaginaFiltros(context); */
    }
  }
}

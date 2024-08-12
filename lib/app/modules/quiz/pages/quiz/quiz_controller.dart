import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../services/preferencias_servicos.dart';
import '../../../../shared/models/exibir_questao_com_filtro_controller.dart';
import '../../../filtros/shared/models/filtros_model.dart';
import '../../../perfil/models/userapp.dart';
import '../../shared/models/alternativa_questao_model.dart';
import '../../shared/models/opcoesQuestao.dart';
import '../../shared/models/questao_model.dart';
import '../../shared/models/resposta_questao.dart';
import '../resultado/resultado_quiz_page.dart';

part 'quiz_controller.g.dart';

class QuizController = QuizControllerBase with _$QuizController;

abstract class QuizControllerBase extends ExibirQuestaoComFiltroController
    with Store {
  QuizControllerBase({
    required super.filtros,
    required super.repositorio,
  });

  Preferencias get _preferencias => Preferencias.instancia;

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
  Future<void> _salvarResposta() async {
    final salvo = _resposta?.sequencial;
    final temp = _resposta?.sequencialTemporario;
    if (salvo != temp) {
      final sucesso = await repositorio.inserirRespostaQuestao(
        RawRespostaQuestao(
          idQuestao: _resposta?.idQuestao,
          idUsuario: _resposta?.idUsuario,
          sequencial: temp,
        ),
      );
      final idAlfanumerico = questaoAtual.value?.idAlfanumerico;
      if (sucesso && idAlfanumerico != null) {
        _resposta?.sequencial = temp;
        if (temp == null) {
          _preferencias.cacheQuiz.remove(idAlfanumerico);
        } else {
          _preferencias.cacheQuiz.add(idAlfanumerico);
        }
      }
    }
  }

  /// Modifica [_resposta] para corresponder a [alternativa] e salva as alterações no
  /// banco de dados.
  void definirAlternativaSelecionada(Alternativa? alternativa) {
    _resposta?.sequencialTemporario = alternativa?.sequencial;
    _salvarResposta();
  }

  /// Verificar os erros e acertos na lista de questões filtradas.
  void concluir() async {
    await abrirPaginaResultado();
    _preferencias.cacheQuiz.clear();
  }

  /// Retorna a opção escolhida pelo usuário dentre as opções disponíveis para a questão.
  Future<void> setOpcaoItem(BuildContext context, OpcoesQuestao opcao) async {
    switch (opcao) {
      case OpcoesQuestao.none:
      /* case OpcoesQuestao.filter:
        await abrirPaginaFiltros(context); */
    }
  }

  @override
  Future<Filtros> abrirPaginaFiltros(BuildContext context) async {
    final filtros = await super.abrirPaginaFiltros(context);
    _preferencias.filtrosQuiz = filtros;
    return filtros;
  }

  Future<void> abrirPaginaResultado() async {
    await Modular.to.push(
      MaterialPageRoute(builder: (context) {
        return ResultadoQuizPage(
          repositorio: repositorio,
        );
      }),
    );
  }
}

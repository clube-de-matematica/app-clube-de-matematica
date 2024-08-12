import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../modules/quiz/shared/models/questao_model.dart';
import 'exibir_questao_com_filtro_controller.dart';

part 'exibir_questao_controller.g.dart';

/// Base do controle de páginas ques exibem questões.
/// * Para páginas com a opção de filtrar, veja [ExibirQuestaoComFiltroController].
abstract class ExibirQuestaoController = ExibirQuestaoControllerBase
    with _$ExibirQuestaoController;

abstract class ExibirQuestaoControllerBase with Store implements Disposable {
  final _disposers = <ReactionDisposer>[];
  ExibirQuestaoControllerBase() {
    _disposers.addAll([
      reaction(
        (_) => numQuestoes,
        (int numQuestoes) {
          definirIndice(numQuestoes > 0 ? 0 : -1, forcar: true);
        },
      ),
      reaction((_) => _questaoAtual, _concluindoQuestaoAtual),
    ]);
  }

  void _concluindoQuestaoAtual(ObservableFuture<Questao?> questaoAtual) {
    questaoAtual.then((valor) {
      if (valor != null && _indice == -1) {
        definirIndice(0);
      }
    });
  }

  /// Encerrar as [Reaction] em execução.
  @override
  void dispose() {
    _disposers
      ..forEach((element) => element())
      ..clear();
  }

  /// {@template app.ExibirQuestaoController.indice}
  /// Índice de [questaoAtual].
  ///
  /// Será `-1` se [numQuestoes] for 0 (zero).
  ///
  /// Será redefinido automaticamente pela reação no construtor desta classe quando
  /// [numQuestoes] for alterado.
  ///
  /// Será definido automaticamente para 0 (zero) pela reação no construtor desta classe
  /// quando for -1 e [questaoAtual] for concluído com um valor diferente de `null`.
  /// {@endtemplate}
  @readonly
  late int _indice = numQuestoes > 0 ? 0 : -1;

  /// Número de questões disponíveis para exibição.
  @observable
  int numQuestoes = 0;

  /// [Questao] a ser exibida.
  @readonly
  ObservableFuture<Questao?> _questaoAtual = ObservableFuture.value(null);

  /// Atribui um novo valor para [_indice].
  /// Se [forcar] for `true`, [valor] será aplicado independentemente do valor atual de [_indice].
  @action
  @protected
  void definirIndice(int valor, {bool forcar = false}) {
    if (_indice != valor || forcar) {
      _indice = valor;
    }
  }

  /// Retorna um `bool` que define se há uma próxima questão para ser exibida.
  @computed
  bool get podeAvancar => _indice >= 0 && _indice < numQuestoes - 1;

  /// Retorna um `bool` que define se há uma questão anterior para ser exibida.
  @computed
  bool get podeVoltar => _indice > 0;

  /// Avança para a próxima questão.
  void avancar() {
    if (podeAvancar) {
      definirIndice(_indice + 1);
    }
  }

  /// Voltar para a questão anterior.
  void voltar() {
    if (podeVoltar) {
      definirIndice(_indice - 1);
    }
  }
}

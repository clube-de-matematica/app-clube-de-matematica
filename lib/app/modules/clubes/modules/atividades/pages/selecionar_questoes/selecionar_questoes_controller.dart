import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../shared/models/exibir_questao_com_filtro_controller.dart';
import '../../../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../../../../filtros/shared/models/filtros_model.dart';
import '../../../../../quiz/shared/models/questao_model.dart';

part 'selecionar_questoes_controller.g.dart';

class SelecionarQuestoesController = SelecionarQuestoesControllerBase
    with _$SelecionarQuestoesController;

abstract class SelecionarQuestoesControllerBase
    extends ExibirQuestaoComFiltroController with Store {
  SelecionarQuestoesControllerBase(Iterable<Questao> questoesSelecionadas)
      : _selecaoInicial = questoesSelecionadas.toList(growable: false),
        questoesSelecionadas = ObservableList.of(questoesSelecionadas),
        super(
          filtros: Filtros(),
          repositorio: Modular.get<QuestoesRepository>(),
        );

  final List<Questao> _selecaoInicial;
  final ObservableList<Questao> questoesSelecionadas;

  /// Retorna verdadeiro se a lista de questões selecionadas tiver sido alterada.
  @computed
  bool get alterada {
    return !listEquals(_selecaoInicial.toList(), questoesSelecionadas.toList());
  }

  @observable
  bool mostrarSomenteQuestoesSelecionadas = false;

  @computed
  @override
  int get numQuestoes {
    if (mostrarSomenteQuestoesSelecionadas) {
      return numQuestoesSelecionadas;
    }
    return super.numQuestoes;
  }

  @computed
  int get numQuestoesSelecionadas => questoesSelecionadas.length;

  @computed
  bool get selecionada =>
      questaoAtual.value == null ? false : _selecionada(questaoAtual.value!);

  /// Alterna a [questaoAtual] entre selecionada e não selecionada.
  void alterarSelecao() {
    if (questaoAtual.value != null) {
      final questao = questaoAtual.value!;
      final selecionada = _selecionada(questao);
      if (selecionada) {
        questoesSelecionadas.removeWhere(
            (quest) => questao.idAlfanumerico == quest.idAlfanumerico);
      } else {
        questoesSelecionadas.add(questao);
      }
    }
  }

  bool _selecionada(Questao questao) => questoesSelecionadas
      .any((quest) => questao.idAlfanumerico == quest.idAlfanumerico);

  /// Desfaz as alterações feitas na seleção inicial.
  List<Questao> cancelar() {
    limpar();
    questoesSelecionadas.addAll(_selecaoInicial);
    return questoesSelecionadas;
  }

  void limpar() {
    questoesSelecionadas.clear();
  }

  /// Retorna a lista de questões selecionadas.
  List<Questao> aplicar() => questoesSelecionadas;
}

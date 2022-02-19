import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../shared/models/exibir_questao_com_filtro_controller.dart';
import '../../../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../../../../filtros/shared/models/filtros_model.dart';
import '../../../../../quiz/shared/models/questao_model.dart';

part 'selecionar_questoes_controller.g.dart';

class SelecionarQuestoesController = _SelecionarQuestoesControllerBase
    with _$SelecionarQuestoesController;

abstract class _SelecionarQuestoesControllerBase
    extends ExibirQuestaoComFiltroController with Store {
  _SelecionarQuestoesControllerBase(Iterable<Questao> questoesSelecionadas)
      : this.questoesSelecionadas = ObservableList.of(questoesSelecionadas),
        super(
          filtros: Filtros(),
          repositorio: Modular.get<QuestoesRepository>(),
        );

  final ObservableList<Questao> questoesSelecionadas;

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

  /// Retorna a lista de questões selecionadas.
  List<Questao> aplicar() => questoesSelecionadas;
}
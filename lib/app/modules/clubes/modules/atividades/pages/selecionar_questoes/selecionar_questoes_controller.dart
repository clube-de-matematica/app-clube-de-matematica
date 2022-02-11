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
      : super(
          filtros: _Filtros(
            Modular.get<QuestoesRepository>(),
            questoesSelecionadas: questoesSelecionadas,
          ),
          repositorio: Modular.get<QuestoesRepository>(),
        );

  @override
  _Filtros get filtros => super.filtros as _Filtros;

  @computed
  int get numQuestoesSelecionadas => filtros.questoesSelecionadas.length;

  @computed
  bool get selecionada => questaoAtual.value == null
      ? false
      : filtros.selecionada(questaoAtual.value!);

  /// Alterna a [questaoAtual] entre selecionada e não selecionada.
  void alterarSelecao() {
    if (questaoAtual.value != null) {
      filtros.alterarSelecao(questaoAtual.value!);
    }
  }

  bool get mostrarSomenteQuestoesSelecionadas =>
      filtros.mostrarSomenteQuestoesSelecionadas;
  set mostrarSomenteQuestoesSelecionadas(bool valor) =>
      filtros.mostrarSomenteQuestoesSelecionadas = valor;

  /// Retorna a lista de questões selecionadas.
  List<Questao> aplicar() => filtros.questoesSelecionadas;
}

class _Filtros = __FiltrosBase with _$_Filtros;

abstract class __FiltrosBase extends Filtros with Store {
  __FiltrosBase(
    QuestoesRepository questoesRepository, {
    Iterable<Questao> questoesSelecionadas = const [],
  }) : this.questoesSelecionadas = ObservableList.of(questoesSelecionadas);

  final ObservableList<Questao> questoesSelecionadas;

  @observable
  bool mostrarSomenteQuestoesSelecionadas = false;

  bool selecionada(Questao questao) =>
      questoesSelecionadas.any((quest) => questao.idAlfanumerico == quest.idAlfanumerico);

  bool alterarSelecao(Questao questao) {
    final selecionada = this.selecionada(questao);
    if (selecionada)
      questoesSelecionadas.removeWhere((quest) => questao.idAlfanumerico == quest.idAlfanumerico);
    else
      questoesSelecionadas.add(questao);

    return selecionada;
  }
}

import 'package:mobx/mobx.dart';

import '../../../../services/preferencias_servicos.dart';
import '../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../shared/models/questao_model.dart';
import '../../shared/models/resposta_questao.dart';

part 'resultado_quiz_controller.g.dart';

typedef _Dados = ObservableList<MapEntry<Questao, RespostaQuestao?>>;

class ResultadoQuizController = ResultadoQuizControllerBase
    with _$ResultadoQuizController;

abstract class ResultadoQuizControllerBase with Store {
  ResultadoQuizControllerBase({
    required this.repositorio,
  }) {
    carregar();
  }

  final QuestoesRepository repositorio;
  
  final _dados = _Dados();

  @readonly
  bool _carregando = true;

  @action
  Future<void> carregar() async {
    _carregando = true;
    final ids = Preferencias.instancia.cacheQuiz;
    if (ids.isEmpty) {
      _carregando = false;
      return;
    }
    final questoes = await repositorio.questoes(ids: ids);
    final map = <Questao, RespostaQuestao?>{};
    final respostasAssinc = questoes.map((q) async {
      final futuro = repositorio.obterResposta(q);
      map[q] = await futuro;
      return futuro;
    });
    await Future.wait(respostasAssinc);
    _dados
      ..clear()
      ..addAll(map.entries);
    _carregando = false;
    return;
  }

  /// Número de questões para exibir.
  @computed
  int get total => _dados.length;

  /// Total de acertos.
  @computed
  int get acertos {
    return _dados.where((e) => e.key.gabarito == e.value?.sequencial).length;
  }

  /// Retorna `null` se [indice] não estiver entre 0 (zero) e [total] - 1.
  Questao? questao(int indice) {
    try {
      return _dados[indice].key;
    } catch (_) {
      return null;
    }
  }

  /// Retorna `null` se [indice] não estiver entre 0 (zero) e [total] - 1.
  RespostaQuestao? resposta(int indice) {
    try {
      return _dados[indice].value;
    } catch (_) {
      return null;
    }
  }
}

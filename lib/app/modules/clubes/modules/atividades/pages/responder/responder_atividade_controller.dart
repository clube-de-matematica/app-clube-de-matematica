
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../shared/models/exibir_questao_controller.dart';
import '../../../../../../shared/repositories/questoes/imagem_questao_repository.dart';
import '../../../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../../../../quiz/shared/models/questao_model.dart';
import '../../models/atividade.dart';

part 'responder_atividade_controller.g.dart';

class ResponderAtividadeController = _ResponderAtividadeControllerBase
    with _$ResponderAtividadeController;

abstract class _ResponderAtividadeControllerBase extends ExibirQuestaoController
    with Store {
  _ResponderAtividadeControllerBase(this.atividade)
      : super(
          Modular.get<ImagemQuestaoRepository>(),
          Modular.get<QuestoesRepository>(),
        );

  final Atividade atividade;
  late final List<Questao> _questoes = atividade.obterQuestoes();

  @override
  List<Questao> get questoes => _questoes;

  /// O sequencial da altenativa selecionada em [questao].
  @observable
  int? alternativaSelecionada; 

  /// Retorna um `bool` que define se há uma resposta a ser confirmada.
  @computed
  bool get podeConfirmar => alternativaSelecionada != null;

  /// Ações a serem executada ao confirmar uma resposta.
  void confirmar() {
    avancar();
  }
}

import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../shared/models/exibir_questao_controller.dart';
import '../../../../../perfil/models/userapp.dart';
import '../../../../shared/repositories/clubes_repository.dart';
import '../../models/atividade.dart';
import '../../models/questao_atividade.dart';
import '../../models/resposta_questao_atividade.dart';

part 'responder_atividade_controller.g.dart';

class ResponderAtividadeController = _ResponderAtividadeControllerBase
    with _$ResponderAtividadeController;

abstract class _ResponderAtividadeControllerBase extends ExibirQuestaoController
    with Store
    implements Disposable {
  _ResponderAtividadeControllerBase(this.atividade) {
    _inicializar();
  }

  final Atividade atividade;
  final _disposers = <ReactionDisposer>[];
  final _repositorio = Modular.get<ClubesRepository>();

  void _inicializar() async {
    await _repositorio.carregarQuestoesAtividade(atividade);
    _disposers.add(
      autorun((_) {
        questaoAtual.then((questao) {
          if (questao == null) return;
          // Instanciar um objeto de resposta, caso não haja.
          final respostaInstanciada =
              questao.resposta(UserApp.instance.id!) != null;
          if (!respostaInstanciada) {
            questao.respostas.add(
              RespostaQuestaoAtividade(
                idQuestaoAtividade: questao.idQuestaoAtividade,
                idUsuario: UserApp.instance.id!,
                sequencial: null,
              ),
            );
          }
        });
      }),
    );
  }

  @computed
  ObservableList<QuestaoAtividade> get questoes => atividade.questoes;

  @override
  @computed
  int get numQuestoes => questoes.length;

  @computed
  QuestaoAtividade? get _questaoAtual => indice == -1 ? null : questoes[indice];

  @override
  @computed
  ObservableFuture<QuestaoAtividade?> get questaoAtual =>
      Future.value(_questaoAtual).asObservable();

  /// Mesmo código de [QuestaoAtividade].resposta().
  @computed
  RespostaQuestaoAtividade? get resposta {
    return _questaoAtual?.respostas
        .cast<RespostaQuestaoAtividade?>()
        .firstWhere(
          (resposta) => resposta?.idUsuario == UserApp.instance.id,
          orElse: () => null,
        );
  }

  /// Lista com as questões não respondidas.
  List<QuestaoAtividade> get questoesEmBranco {
    return questoes.where((questao) {
      final resposta =
          questao.respostas.cast<RespostaQuestaoAtividade?>().firstWhere(
                (resposta) => resposta?.idUsuario == UserApp.instance.id,
                orElse: () => null,
              );
      return resposta?.sequencialTemporario == null;
    }).toList();
  }

  /// Lista com as questões em que as respostas foram modificas.
  List<QuestaoAtividade> get questoesModificadas {
    return questoes.where((questao) {
      final resposta =
          questao.respostas.cast<RespostaQuestaoAtividade?>().firstWhere(
                (resposta) => resposta?.idUsuario == UserApp.instance.id,
                orElse: () => null,
              );
      return resposta?.sequencialTemporario != resposta?.sequencial;
    }).toList();
  }

  /// Retorna um `bool` que define se há uma resposta a ser confirmada.
  @computed
  bool get podeConcluir =>
      questoesModificadas.isNotEmpty && !atividadeEncerrada;

  bool get atividadeEncerrada => atividade.encerrada;

  /// Ações a serem executada ao concluir a atividade.
  Future<bool> concluir() async {
    return _repositorio.atualizarInserirRespostaAtividade(atividade);
  }

  /// Encerrar as [Reaction] em execução.
  @override
  void dispose() {
    _disposers
      ..forEach((element) => element())
      ..clear();
  }
}

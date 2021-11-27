import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../../../shared/models/exibir_questao_controller.dart';
import '../../../../../../shared/repositories/questoes/imagem_questao_repository.dart';
import '../../../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../../../../perfil/models/userapp.dart';
import '../../../../shared/repositories/clubes_repository.dart';
import '../../models/atividade.dart';
import '../../models/questao_atividade.dart';

part 'responder_atividade_controller.g.dart';

class ResponderAtividadeController = _ResponderAtividadeControllerBase
    with _$ResponderAtividadeController;

abstract class _ResponderAtividadeControllerBase extends ExibirQuestaoController
    with Store
    implements Disposable {
  _ResponderAtividadeControllerBase(this.atividade)
      : super(
          Modular.get<ImagemQuestaoRepository>(),
          Modular.get<QuestoesRepository>(),
        ) {
    _inicializar();
  }

  final Atividade atividade;
  final _disposers = <ReactionDisposer>[];
  final _clubesRepositorio = Modular.get<ClubesRepository>();

  void _inicializar() {
    _clubesRepositorio.carregarRespostasAtividade(atividade).then((atividade) {
      final filtradas = atividade?.respostas
          .where((resposta) => resposta.idUsuario == UserApp.instance.id);
      filtradas?.forEach(
        (resposta) {
          // O cast() foi usado para forçar a permissão do retorno null em orElse.
          final questao = this.questoes.cast<QuestaoAtividade?>().firstWhere(
              (questao) =>
                  questao?.idQuestaoAtividade == resposta.idQuestaoAtividade,
              orElse: () => null);
          questao?.sequencialRespostaTemporaria ??= resposta.sequencial;
          questao?.resposta = resposta;
        },
      );

      _disposers.add(
        autorun((_) {
          if (this.questao != null) {
            final questao = this.questao!;
            if (questao.resposta == null) {
              questao.resposta = RespostaQuestaoAtividade(
                idQuestaoAtividade: questao.idQuestaoAtividade,
                idUsuario: UserApp.instance.id!,
                sequencial: null,
              );
            }
          }
        }),
      );
    });
  }

  @override
  @computed
  List<QuestaoAtividade> get questoes => atividade.questoes;

  @override
  @computed
  QuestaoAtividade? get questao => super.questao as QuestaoAtividade?;

  /// Lista com as questões não respondidas.
  List<QuestaoAtividade> get questoesEmBranco => questoes
      .where((questao) => questao.sequencialRespostaTemporaria == null)
      .toList();

  /// Lista com as questões em que as respostas foram modificas.
  List<QuestaoAtividade> get questoesModificadas => questoes
      .where((questao) =>
          questao.sequencialRespostaTemporaria !=
          questao.sequencialRespostaSalva)
      .toList();

  /// Retorna um `bool` que define se há uma resposta a ser confirmada.
  @computed
  bool get podeConfirmar => questao?.sequencialRespostaTemporaria != null;

  /// Ações a serem executada ao concluir a atividade.
  Future<bool> concluir() async {
    return _clubesRepositorio.atualizarInserirRespostaAtividade(atividade);
  }

  /// Encerrar as [Reaction] em execução.
  @override
  void dispose() {
    _disposers
      ..forEach((element) => element())
      ..clear();
  }
}

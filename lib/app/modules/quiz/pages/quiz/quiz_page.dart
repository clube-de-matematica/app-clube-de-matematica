import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../services/preferencias_servicos.dart';
import '../../../../shared/theme/appTheme.dart';
import '../../../../shared/utils/ui_strings.dart' as uiStringsApp;
import '../../../../shared/widgets/appBottomSheet.dart';
import '../../../../shared/widgets/barra_inferior_anterior_proximo.dart';
import '../../../../shared/widgets/questao_widget.dart';
import '../../../../shared/widgets/scaffoldWithDrawer.dart';
import '../../../filtros/shared/widgets/feedback_filtragem_vazia.dart';
import '../../shared/models/questao_model.dart';
import '../../shared/utils/ui_strings.dart';
import 'quiz_controller.dart';
import 'widgets/feedback_questao_nao_encontrada.dart';
import 'widgets/quiz_appbar.dart';
import 'widgets/quiz_bar_opcoes_item.dart';

/// Esta é a página de exibição de cada item a ser resolvido.
class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

/// [ModularState] irá criar um [controller] a partir de um [Bind] do tipo [QuizController]
/// disponível em um dos módulos da hierarquia (quando houver mais de um). A vantagem de usar
/// [ModularState] é que automáticamente será feito o `dispose` de [controller] junto com o
/// de [_QuizPageState].
class _QuizPageState extends ModularState<QuizPage, QuizController> {
  ThemeData get tema => AppTheme.instance.temaClaro;
  TextStyle? get textStyle => tema.textTheme.bodyLarge;

  @override
  void initState() {
    super.initState();
    if (Preferencias.instancia.exibirMsgTermosCondicoesPolitica) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        () async {
          int contador = 0;
          while (!mounted) {
            if (++contador > 30) return;
            await Future.delayed(Duration(seconds: 1));
          }
          BottomSheetAvisoConsentimento().showModal(context);
        }();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithDrawer(
      page: AppDrawerPage.quiz,
      appBar: QuizAppBar(controller),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        // Falta envolver os widgets de notificação em um widget rolável.
        child: RefreshIndicator(
          onRefresh: () => controller.recarregar(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              FutureBuilder(
                future: controller.questaoAtual,
                builder: (_, snapshot) {
                  // Antes do futuro ser concluído.
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: .35 * MediaQuery.of(context).size.height,
                      ),
                      child: Center(child: const CircularProgressIndicator()),
                    );
                  }
                  // Quando o futuro for concluído com erro.
                  if (snapshot.hasError) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          uiStringsApp.UIStrings.APP_MSG_ERRO_INESPERADO,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 24.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  // Quando o futuro for concluído sem erro.
                  return Observer(builder: (_) {
                    final numQuestoes = controller.numQuestoes;
                    final totalSelecinado = controller.filtros.totalSelecinado;
                    if (numQuestoes == 0 && totalSelecinado > 0) {
                      return FeedbackFiltragemVazia(
                          onPressed: () =>
                              controller.abrirPaginaFiltros(context));
                    }
                    if (controller.questaoAtual.value == null) {
                      return FeedbackQuestaoNaoEncontrada();
                    }
                    return _questaoWidget(controller.questaoAtual.value!);
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Observer(builder: (_) {
        return BarraIferiorAteriorProximo(
          ativarVoltar: controller.podeVoltar,
          ativarProximo: controller.podeAvancar,
          acionarVoltar: controller.voltar,
          acionarProximo: controller.avancar,
        );
      }),
      floatingActionButton: Observer(builder: (_) {
        final ativo =
            controller.questaoAtual.value != null && !controller.podeAvancar;
        return !ativo
            ? const SizedBox()
            : FloatingActionButton.extended(
                icon: const Icon(Icons.done),
                label: const Text(UIStrings.QUIZ_TEXTO_BOTAO_CONFIRMAR),
                onPressed: !ativo
                    ? null
                    : () {
                        controller.concluir();
                        /* Modular.get<AuthRepository>().signInWithGoogle().then((value) => 
                        print(value)); */
                        //Modular.get<AuthRepository>().signOutGoogle();
                        //controller.avancar();
                        /* Modular.get<AssuntosRepository>().carregarAssuntos().then(
                      (value) => controller.itensRepository.carregarItens()
                    ); */
                        //Modular.get<FirestoreRepository>().corrigir();
                        //Modular.get<StorageRepository>().reconstruirDb();
                      },
              );
      }),
    );
  }

  /// Retorna o [Widget] da questão a ser exibida.
  Widget _questaoWidget(Questao questao) {
    return Observer(builder: (_) {
      return QuestaoWidget(
        padding: const EdgeInsets.all(.0),
        questao: questao,
        selecionavel: true,
        alternativaSelecionada: controller.alternativaSelecionada,
        alterandoAlternativa: controller.definirAlternativaSelecionada,
        rolavel: false,
        barraOpcoes: QuizBarOpcoesQuestao(controller),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/theme/appTheme.dart';
import '../../../../shared/utils/ui_strings.dart' as uiStringsApp;
import '../../../../shared/widgets/barra_inferior_anterior_proximo.dart';
import '../../../../shared/widgets/questao_widget.dart';
import '../../../../shared/widgets/scaffoldWithDrawer.dart';
import '../../../filtros/shared/widgets/feedback_filtragem_vazia.dart';
import '../../shared/models/questao_model.dart';
import '../../shared/utils/ui_strings.dart';
import 'quiz_controller.dart';
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
  TextStyle? get textStyle => tema.textTheme.bodyText1;

  @override
  Widget build(BuildContext context) {
    //FirebaseToSupabase.migrarAsuntos();
    //FirebaseToSupabase.migrarQuestoes();

    return ScaffoldWithDrawer(
      page: AppDrawerPage.quiz,
      appBar: QuizAppBar(controller),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: FutureBuilder(
          future: controller.inicializandoRepositorioQuestoes,
          builder: (_, snapshot) {
            // Antes do futuro ser concluído.
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: const CircularProgressIndicator());
            }
            // Quando o futuro for concluído com erro.
            if (snapshot.hasError) {
              return Expanded(
                child: Center(
                  child: Text(
                    uiStringsApp.UIStrings.APP_MSG_ERRO_INESPERADO,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 24.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            // Quando o futuro for concluído sem erro.
            return Column(
              children: <Widget>[
                // Contém um indicador do número de questões à esquerda e, à direita,
                // um botão para exibir as opções disponíveis para a questão.
                QuizBarOpcoesItem(controller),

                // Linha divisória.
                const Divider(height: double.minPositive),

                // Corpo
                Observer(builder: (_) {
                  return Expanded(
                    child: controller.questao == null
                        ? FeedbackFiltragemVazia(
                            onPressed: () => controller.abrirPaginaFiltros(context))
                        : _questaoWidget(controller.questao!),
                  );
                }),
              ],
            );
          },
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
        final ativo = controller.podeConfirmar;
        return !ativo
            ? const SizedBox()
            : FloatingActionButton.extended(
                icon: const Icon(Icons.done),
                label: const Text(UIStrings.QUIZ_TEXTO_BOTAO_CONFIRMAR),
                onPressed: !ativo
                    ? null
                    : () {
                        controller.confirmar();
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
  QuestaoWidget _questaoWidget(Questao questao) {
    return QuestaoWidget(
      questao: questao,
      selecionavel: true,
      alternativaSelecionada: controller.alternativaSelecionada,
      alterandoAlternativa: (alternativa) =>
          controller.alternativaSelecionada = alternativa?.sequencial,
      rolavel: true,
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/theme/appTheme.dart';
import '../../../../shared/utils/ui_strings.dart' as uiStringsApp;
import '../../../../shared/widgets/questao_widget.dart';
import '../../../../shared/widgets/scaffoldWithDrawer.dart';
import '../../shared/utils/ui_strings.dart';
import 'quiz_controller.dart';
import 'widgets/quiz_appbar.dart';
import 'widgets/quiz_bar_opcoes_item.dart';
import '../../../../shared/widgets/barra_inferior_anterior_proximo.dart';

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
          child: Column(
            children: <Widget>[
              // Contém um indicador do número de questões à esquerda e, à direita,
              // um botão para exibir as opções disponíveis para a questão.
              QuizBarOpcoesItem(controller),

              // Linha divisória.
              const Divider(height: double.minPositive),

              // O `FutureBuilder` aguardará até que os itens sejam carregados.
              FutureBuilder(
                  future: controller.initialized,
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          uiStringsApp.UIStrings.APP_MSG_ERRO_INESPERADO);
                    } else if (snapshot.hasData) {
                      return Observer(builder: (_) {
                        return Expanded(
                          child: controller.itensFiltrados.isEmpty
                              ? _construirSeSemQuestoes(context)
                              : _questaoWidget(),
                        );
                      });
                    } else
                      return Container(
                          padding: EdgeInsets.only(top: 100),
                          child: const CircularProgressIndicator());
                  }),
            ],
          )),
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
                icon: const Icon(Icons.check),
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
  QuestaoWidget _questaoWidget() {
    return QuestaoWidget(
      questao: controller.questao,
      selecionavel: true,
      alternativaSelecionada: controller.alternativaSelecionada,
      alterandoAlternativa: (alternativa) =>
          controller.alternativaSelecionada = alternativa?.sequencial,
      rolavel: true,
    );
  }

  /// Retorna um [Widget] com um botão para exibir a página de filtros e um texto informando
  /// que não foram encontrados itens a serem exibidos.
  Widget _construirSeSemQuestoes(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          UIStrings.QUIZ_MSG_ITENS_NAO_ENCONTRADOS,
          style: textStyle,
          textAlign: TextAlign.justify,
        ),
        TextButton(
          style: TextButton.styleFrom(
            primary: tema.colorScheme.primary,
            padding: const EdgeInsets.only(top: 40),
          ),
          child: const Text(UIStrings.QUIZ_TEXTO_BOTAO_FILTRAR),
          onPressed: () => controller.onTapFiltrar(context),
        )
      ],
    );
  }
}

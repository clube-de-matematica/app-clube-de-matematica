import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/theme/tema.dart';
import '../../../../shared/utils/string_interface.dart';
import '../../../../shared/widgets/myDrawer.dart';
import '../../shared/utils/strings_interface.dart';
import 'quiz_controller.dart';
import 'widgets/quiz_alternativas.dart';
import 'widgets/quiz_appbar.dart';
import 'widgets/quiz_bar_opcoes_item.dart';
import 'widgets/quiz_bottom_bar.dart';
import 'widgets/quiz_enunciado_item.dart';

//Esta é a página de exibição de cada item a ser resolvido.
class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

///[ModularState] irá criar um [controller] a partir de um [Bind] do tipo
///[QuizController] disponível em um dos módulos da hierarquia (quando houver mais de
///um). A vantagem de usar [ModularState] é que automáticamente será feito o `dispose` de
///[controller] junto com o de [_QuizPageState].
class _QuizPageState extends ModularState<QuizPage, QuizController> {
  ThemeData get tema => Modular.get<MeuTema>().temaClaro;
  TextStyle? get textStyle => tema.textTheme.bodyText1;

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      appBar: QuizAppBar(controller),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: <Widget>[
              ///Contém um indicador do número de questões à esquerda e, à direita,
              ///um botão para exibir as opções disponíveis para a questão.
              QuizBarOpcoesItem(controller),

              ///Linha divisória.
              const Divider(height: double.minPositive),

              ///O `FutureBuilder` aguardará até que os itens sejam carregados.
              FutureBuilder(
                  future: controller.initialized,
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(APP_MSG_ERRO_INESPERADO);
                    } else if (snapshot.hasData) {
                      return Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(top: 8, bottom: 72),
                          child: Observer(builder: (_) {
                            return Column(
                              children: controller.itensFiltrados.isEmpty
                                  ? _ifItensFiltradosIsEmpty()
                                  : _ifItensFiltradosIsNotEmpty(),
                            );
                          }),
                        ),
                      );
                    } else
                      return Container(
                          padding: EdgeInsets.only(top: 100),
                          child: const CircularProgressIndicator());
                  }),
            ],
          )),
      bottomNavigationBar: QuizBottomBar(controller),
      floatingActionButton: Observer(builder: (_) {
        final ativo = controller.podeConfirmar;
        return !ativo
            ? const SizedBox()
            : FloatingActionButton.extended(
                icon: const Icon(Icons.check),
                label: const Text(QUIZ_TEXTO_BOTAO_CONFIRMAR),
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

  ///Retorna uma lista com os componentes do item e um botão para confirmar a alternativa
  ///escolhida.
  List<Widget> _ifItensFiltradosIsNotEmpty() {
    return <Widget>[
      ///Enunciado da questão.
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: EnunciadoItem(controller),
      ),

      ///Opções de resposta.
      QuizAlternativas(controller),
    ];
  }

  ///Retorna uma lista com um botão para exibir a página de filtros e um texto informando
  ///que não foram encontrados itens a serem exibidos.
  List<Widget> _ifItensFiltradosIsEmpty() {
    return <Widget>[
      Text(
        QUIZ_MSG_ITENS_NAO_ENCONTRADOS,
        style: textStyle,
        textAlign: TextAlign.justify,
      ),
      TextButton(
        style: TextButton.styleFrom(
          primary: tema.colorScheme.primary,
          padding: const EdgeInsets.only(top: 40),
        ),
        child: const Text(QUIZ_TEXTO_BOTAO_FILTRAR),
        onPressed: () => controller.onTapFiltrar(),
      )
    ];
  }
}

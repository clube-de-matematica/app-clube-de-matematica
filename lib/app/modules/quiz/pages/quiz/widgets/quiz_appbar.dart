import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../services/preferencias_servicos.dart';
import '../../../../../shared/theme/appTheme.dart';
import '../../../../../shared/widgets/appBottomSheet.dart';
import '../../../shared/utils/ui_strings.dart';
import '../quiz_controller.dart';

/// A barra superior da página de quiz.
class QuizAppBar extends PreferredSize {
  QuizAppBar(
    this.controller, {
    Key? key,
  }) : super(
          key: key,
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Observer(builder: (_) {
            final cacheQuiz = Preferencias.instancia.cacheQuiz;
            return AppBar(
              actions: <Widget>[
                if (cacheQuiz.isNotEmpty)
                  Builder(builder: (context) {
                    return IconButton(
                      icon: IconTheme(
                        data: _tema.primaryIconTheme,
                        child: const Icon(Icons.task),
                      ),
                      onPressed: () async {
                        if (controller.numQuestoes > cacheQuiz.length) {
                          final resposta = await BottomSheetAcoes(
                            title: Text(
                                'Algumas questões ainda estão sem resposta'),
                            labelActionFirst: 'CONTINUAR RESPONDENDO',
                            resultActionFirst: 0,
                            actionFirstIsPrimary: true,
                            labelActionLast: 'VERIFICAR DESEMPENHO',
                            resultActionLast: 1,
                            actionLastIsPrimary: false,
                          ).showModal(context);
                          if (resposta != 1) return;
                        }
                        controller.concluir();
                      },
                    );
                  }),
                Builder(builder: (context) {
                  return IconButton(
                    icon: IconTheme(
                      data: _tema.primaryIconTheme,
                      child: const Icon(Icons.filter_alt),
                    ),
                    onPressed: () => controller.abrirPaginaFiltros(context),
                  );
                })
              ],
              title: const Text(UIStrings.QUIZ_TEXTO_APPBAR),
            );
          }),
        );

  final QuizController controller;

  static ThemeData get _tema => AppTheme.instance.light;

  ///Necessário para que este [Widget] possa ser usado como o `appbar` de um [Scaffold].
  //@override
  //Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

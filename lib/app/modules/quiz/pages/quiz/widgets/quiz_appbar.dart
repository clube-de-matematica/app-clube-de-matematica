import 'package:flutter/material.dart';

import '../../../../../shared/theme/appTheme.dart';
import '../../../shared/utils/ui_strings.dart';
import '../quiz_controller.dart';

///A barra superior da página de quiz.
class QuizAppBar extends AppBar {
  QuizAppBar(
    this.controller, {
    Key? key,
  }) : super(
          key: key,
          actions: <Widget>[
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

  final QuizController controller;

  static ThemeData get _tema => AppTheme.instance.temaClaro;

  ///Necessário para que este [Widget] possa ser usado como o `appbar` de um [Scaffold].
  //@override
  //Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

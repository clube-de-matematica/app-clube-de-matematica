import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../shared/theme/tema.dart';
import '../../../shared/utils/strings_interface.dart';
import '../quiz_controller.dart';

///A barra superior da página de quiz.
class QuizAppBar extends AppBar {
  QuizAppBar(
    this.controller, {
    Key? key,
  }) : super(
          key: key,
          actions: <Widget>[
            IconButton(
                icon: IconTheme(
                    data: _tema.primaryIconTheme,
                    child: const Icon(Icons.more_vert)),
                onPressed: null)
          ],
          title: const Text(QUIZ_TEXTO_APPBAR),
        );

  final QuizController controller;

  static ThemeData get _tema => Modular.get<MeuTema>().temaClaro;

  ///Necessário para que este [Widget] possa ser usado como o `appbar` de um [Scaffold].
  //@override
  //Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

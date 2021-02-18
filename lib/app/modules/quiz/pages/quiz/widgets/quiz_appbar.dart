import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../quiz_controller.dart';
import '../../../shared/utils/strings_interface.dart';
import '../../../../../shared/theme/tema.dart';

///A barra superior da página de quiz.
class QuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuizAppBar(
    this.controller,
    {Key key,
  }) : super(key: key);

  final QuizController controller;

  ThemeData get tema => Modular.get<MeuTema>().temaClaro;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: IconTheme(
            data: tema.primaryIconTheme,
            child: const Icon(Icons.more_vert)
          ),
          onPressed: null
        )
      ],
      title: const Text(QUIZ_TEXTO_APPBAR),
    );
  }

  @override
  ///Necessário para que este [Widget] possa ser usado como o `appbar` de um [Scaffold].
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

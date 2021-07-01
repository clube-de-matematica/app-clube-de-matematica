import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/login/login_module.dart';
import 'modules/quiz/quiz_module.dart';
import 'shared/repositories/firebase/auth_repository.dart';
import 'shared/theme/tema.dart';
import 'shared/utils/constantes.dart';

///O [Widget] principal do aplicativo.
class ClubeDeMatematicaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NOME,
      theme: Modular.get<MeuTema>().temaClaro,
      initialRoute:Modular.get<AuthRepository>().logged
          ? QuizModule.kAbsoluteRouteQuizPage
          : LoginModule.kAbsoluteRouteLoginPage,
    ).modular();
  }
}

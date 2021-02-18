import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import 'modules/quiz/shared/utils/rotas_quiz.dart';
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
      initialRoute: ROTA_PAGINA_QUIZ,
      ///Tranferir o gerenciamento de rotas para o `Modular`.
      ///Para chamar as rotas não será mais necessário um `BuildContext`.
      navigatorKey: Modular.navigatorKey,
      onGenerateRoute: Modular.generateRoute,
    );
  }
}
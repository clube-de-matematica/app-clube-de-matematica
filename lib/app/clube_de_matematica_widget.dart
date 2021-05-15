import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/login/utils/rotas_login.dart';
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
      initialRoute:
          /* Modular.get<AuthRepository>().logged
          ? ROTA_PAGINA_QUIZ_PATH
          : */
          ROTA_PAGINA_LOGIN_PATH,

      ///Tranferir o gerenciamento de rotas para o `Modular`.
      ///Para chamar as rotas não será mais necessário um `BuildContext`.
      //initialRoute: "/",
      //navigatorKey: Modular.navigatorKey,
      //onGenerateRoute: Modular.generateRoute,
    ).modular();
  }
}

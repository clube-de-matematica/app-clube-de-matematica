import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/repositories/interface_auth_repository.dart';
import 'pages/login_controller.dart';
import 'pages/login_page.dart';

class LoginModule extends Module {
  ///Rota relativa.
  static const kRelativeRouteModule = "/login";

  ///Rota absoluta.
  static const kAbsoluteRouteModule = kRelativeRouteModule;

  ///Rota relativa.
  static const kRelativeRouteLoginPage = "";

  ///Rota absoluta.
  static const kAbsoluteRouteLoginPage =
      kAbsoluteRouteModule + kRelativeRouteLoginPage;

  @override
  List<Bind> get binds => [
        //Controles
        Bind((i) => LoginController(i.get<IAuthRepository>())),
      ];

  @override
  List<ModularRoute> get routes => [
        //ChildRoute(Modular.initialRoute, child: (_, __) => LoginPage()),
        ChildRoute(kRelativeRouteLoginPage, child: (_, __) => LoginPage()),
      ];
}

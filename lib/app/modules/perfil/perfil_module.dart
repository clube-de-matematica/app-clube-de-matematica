import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/repositories/interface_auth_repository.dart';
import 'page/perfil_controller.dart';
import 'page/perfil_page.dart';

class PerfilModule extends Module {
  /// Rota relativa.
  static const kRelativeRouteModule = "/perfil";

  /// Rota absoluta.
  static const kAbsoluteRouteModule = kRelativeRouteModule;

  /// Rota relativa.
  static const kRelativeRoutePerfilPage = "/";

  /// Rota absoluta.
  static const kAbsoluteRoutePerfilPage =
      kAbsoluteRouteModule + kRelativeRoutePerfilPage;

  @override
  List<Bind> get binds => [
        //Controles
        Bind((i) => PerfilController(i.get<IAuthRepository>())),
      ];

  @override
  List<ModularRoute> get routes => [
        if (Modular.initialRoute != kRelativeRoutePerfilPage)
          RedirectRoute(Modular.initialRoute, to: kRelativeRoutePerfilPage),
        ChildRoute(kRelativeRoutePerfilPage,
            child: (_, __) => const PerfilPage()),
      ];
}

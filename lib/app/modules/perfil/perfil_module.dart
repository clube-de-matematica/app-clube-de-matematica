import 'package:flutter_modular/flutter_modular.dart';

import 'models/userapp.dart';
import 'page/perfil_controller.dart';
import 'page/perfil_page.dart';

class PerfilModule extends Module {
  @override
  List<Bind> get binds => [
        //Controles
        Bind((i) => PerfilController(i.get<UserApp>())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => PerfilPage()),
      ];
}

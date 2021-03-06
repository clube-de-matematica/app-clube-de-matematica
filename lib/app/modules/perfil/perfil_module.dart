import 'package:flutter_modular/flutter_modular.dart';

import 'models/userapp.dart';
import 'page/perfil_controller.dart';
import 'page/perfil_page.dart';

class PerfilModule extends ChildModule {
  @override
  List<Bind> get binds => [
    //Controles
    Bind((i) => PerfilController(i.get<UserApp>())),
  ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, __) => PerfilPage()),
  ];
}
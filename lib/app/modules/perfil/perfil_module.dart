import 'package:flutter_modular/flutter_modular.dart';

import 'page/perfil_controller.dart';
import 'page/perfil_page.dart';
import '../../shared/repositories/firebase/auth_repository.dart';

class PerfilModule extends ChildModule {
  @override
  List<Bind> get binds => [
    //Controles
    Bind((i) => PerfilController(i.get<AuthRepository>())),
  ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, __) => PerfilPage()),
  ];
}
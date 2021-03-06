import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/repositories/firebase/auth_repository.dart';
import '../perfil/models/userapp.dart';
import 'pages/login_controller.dart';
import 'pages/login_page.dart';

class LoginModule extends ChildModule {
  @override
  List<Bind> get binds => [
        //Controles
        Bind((i) => LoginController(i.get<AuthRepository>(), i.get<UserApp>())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, __) => LoginPage()),
      ];
}

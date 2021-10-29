import 'package:clubedematematica/app/navigation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'clube_de_matematica_controller.dart';
import 'deep_links.dart';
import 'modules/clubes/clubes_module.dart';
import 'modules/clubes/shared/repositories/clubes_repository.dart';
import 'modules/login/login_module.dart';
import 'modules/perfil/models/userapp.dart';
import 'modules/perfil/perfil_module.dart';
import 'modules/quiz/quiz_module.dart';
import 'shared/repositories/interface_auth_repository.dart';
import 'shared/repositories/supabase/auth_supabase_repository.dart';
import 'shared/repositories/supabase/supabase_db_repository.dart';

class ClubeDeMatematicaModule extends Module {
  /// Rota relativa.
  static const kRelativeRouteModule = '/';

  /// Rota absoluta.
  static const kAbsoluteRouteModule = kRelativeRouteModule;

  @override
  //Um Bind é uma injeção de dependência.
  //Como este é o módulo plincipal (MainModule), ela estará disponível para todo o app.
  List<Bind> get binds => [
        //Bind((_) => AppTheme()),
        Bind<UserApp>((i) => i.get<IAuthRepository>().user),
        Bind.singleton((_) => DeepAndAppLinks()),

        //Controles
        Bind((_) => ClubeDeMatematicaController()),

        //Repositórios
        //Bind<IAuthRepository>((i) => AuthFirebaseRepository(i.get<FirebaseAuth>())),
        Bind<IAuthRepository>((i) => AuthSupabaseRepository(i.get<Supabase>())),
        Bind((i) => SupabaseDbRepository(
              i.get<Supabase>(),
              i.get<IAuthRepository>(),
            )),
        Bind.lazySingleton((i) => ClubesRepository(
              i.get<SupabaseDbRepository>(),
              i.get<UserApp>(),
            )),

        //Supabase
        Bind((_) => Supabase.instance),
      ];

  @override
  //Lista de rotas.
  List<ModularRoute> get routes => [
        //ModuleRoute(Modular.initialRoute, module: LoginModule()),
        ModuleRoute(RouteModule.login.name, module: LoginModule()),
        ModuleRoute(RouteModule.perfil.name, module: PerfilModule()),
        ModuleRoute(RouteModule.quiz.name, module: QuizModule()),
        ModuleRoute(RouteModule.clubes.name, module: ClubesModule()),
        //WildcardRoute(child: (_, args) => Scaffold()),
      ];
}

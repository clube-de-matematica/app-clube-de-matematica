import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'clube_de_matematica_controller.dart';
import 'modules/clubes/clubes_module.dart';
import 'modules/clubes/shared/repositories/clubes_repository.dart';
import 'modules/inserir_questao/inserir_questao_module.dart';
import 'modules/login/login_module.dart';
import 'modules/perfil/models/userapp.dart';
import 'modules/perfil/perfil_module.dart';
import 'modules/quiz/quiz_module.dart';
import 'navigation.dart';
import 'services/conectividade.dart';
import 'services/db_servicos_interface.dart';
import 'services/db_servicos_outros.dart'
    if (dart.library.ffi) 'services/db_servicos_android.dart'
    if (dart.library.html) 'services/db_servicos_web.dart';
import 'services/preferencias_servicos.dart';
import 'shared/repositories/drift/drift_db.dart'
    if (dart.library.html) 'shared/repositories/drift/drift_db_sem_suporte.dart';
import 'shared/repositories/interface_auth_repository.dart';
import 'shared/repositories/interface_db_repository.dart';
import 'shared/repositories/questoes/assuntos_repository.dart';
import 'shared/repositories/questoes/questoes_repository.dart';
import 'shared/repositories/supabase/auth_supabase_repository.dart';
import 'shared/repositories/supabase/supabase_db_repository.dart';

class ClubeDeMatematicaModule extends Module {
  /// Rota relativa.
  static const kRelativeRouteModule = '/';

  /// Rota absoluta.
  static const kAbsoluteRouteModule = kRelativeRouteModule;

  @override

  /// Um Bind é uma injeção de dependência.
  /// Como este é o módulo plincipal (MainModule), ela estará disponível para todo o app.
  /// Classes Singleton não podem ser adcionadas usando addSingleton.
  List<Bind> get binds => [
        Bind<UserApp>((i) => i.get<IAuthRepository>().user),

        //Controles
        Bind((_) => ClubeDeMatematicaController()),

        //Serviços
        Bind((_) => Conectividade()),
        Bind<IDbServicos>((i) => DbServicos(
              i.get<SupabaseDbRepository>(),
              i.get<IAuthRepository>(),
            )),
        Bind((_) => Preferencias.instancia),

        //Repositórios
        Bind<IAuthRepository>((i) => AuthSupabaseRepository(i.get<Supabase>())),
        Bind<IRemoteDbRepository>((i) => SupabaseDbRepository(
              i.get<Supabase>(),
              i.get<IAuthRepository>(),
            )),
        Bind.lazySingleton((i) => ClubesRepository(i.get<IDbServicos>())),
        Bind.lazySingleton((i) => QuestoesRepository(i.get<IDbServicos>())),
        Bind.lazySingleton((i) => AssuntosRepository(i.get<IDbServicos>())),

        if (!kIsWeb) Bind((_) => DriftDb()),

        //Supabase
        Bind((_) => Supabase.instance),
      ];

  @override
  List<ModularRoute> get routes => [
        if (Modular.initialRoute != kRelativeRouteModule)
          RedirectRoute(Modular.initialRoute, to: kRelativeRouteModule),
        RedirectRoute(
          kRelativeRouteModule,
          to: Modular.get<IAuthRepository>().logged ||
                  Preferencias.instancia.primeiroAcesso != null
              ? RotaPagina.quiz.nome
              : RotaPagina.login.nome,
        ),
        ModuleRoute(RotaModulo.login.nome, module: LoginModule()),
        ModuleRoute(RotaModulo.perfil.nome, module: PerfilModule()),
        ModuleRoute(RotaModulo.quiz.nome, module: QuizModule()),
        ModuleRoute(RotaModulo.clubes.nome, module: ClubesModule()),
        ModuleRoute(
          InserirQuestaoModule.kAbsoluteRouteModule,
          module: InserirQuestaoModule(),
        ),
      ];
}

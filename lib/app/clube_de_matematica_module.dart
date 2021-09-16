import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'clube_de_matematica_controller.dart';
import 'modules/login/login_module.dart';
import 'modules/perfil/models/userapp.dart';
import 'modules/perfil/perfil_module.dart';
import 'modules/quiz/quiz_module.dart';
import 'shared/repositories/firebase/auth_repository.dart';
import 'shared/repositories/supabase/supabase_db_repository.dart';
import 'shared/theme/tema.dart';

const String _SUPABASE_URL = 'https://dlhhqapgjuyvzxktohck.supabase.co';
const String _SUPABASE_SECRET =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyODYxNjA5OSwiZXhwIjoxOTQ0MTkyMDk5fQ.fdCHd5Bx4fBNyo3ENvQF1cb0X0FnucGTepe5SSRL7Q0';

class ClubeDeMatematicaModule extends Module {
  @override
  //Um Bind é uma injeção de dependência.
  //Como este é o módulo plincipal (MainModule), ela estará disponível para todo o app.
  List<Bind> get binds => [
        Bind((i) => MeuTema()),
        Bind((i) => UserApp(
              name: i.get<AuthRepository>().currentUserName,
              email: i.get<AuthRepository>().currentUserEmail,
              urlAvatar: i.get<AuthRepository>().currentUserAvatarUrl,
            )),

        //Controles
        Bind((i) => ClubeDeMatematicaController()),

        //Repositórios
        Bind((i) => AuthRepository(i.get<FirebaseAuth>())),
        /* Bind(
          (i) => FirestoreRepository(
            i.get<FirebaseFirestore>(),
            i.get<AuthRepository>(),
          ),
        ), */
        Bind((i) => SupabaseDbRepository(
              i.get<Future<Supabase>>(),
              i.get<AuthRepository>(),
            )),

        //Supabase
        Bind((i) => Supabase.initialize(
              url: _SUPABASE_URL,
              anonKey: _SUPABASE_SECRET,
            )),

        //Firebase
        Bind((i) => FirebaseFirestore.instance),
        Bind((i) => FirebaseStorage.instance),
        Bind((i) => FirebaseAuth.instance),
      ];

  @override
  //Lista de rotas.
  List<ModularRoute> get routes => [
        ModuleRoute(Modular.initialRoute, module: LoginModule()),
        ModuleRoute(LoginModule.kAbsoluteRouteModule, module: LoginModule()),
        ModuleRoute(PerfilModule.kAbsoluteRouteModule, module: PerfilModule()),
        ModuleRoute(QuizModule.kAbsoluteRouteModule, module: QuizModule()),
      ];
}

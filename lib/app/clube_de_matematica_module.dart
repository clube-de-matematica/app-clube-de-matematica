import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'clube_de_matematica_controller.dart';
import 'clube_de_matematica_widget.dart';
import 'modules/quiz/quiz_module.dart';
import 'modules/quiz/shared/utils/rotas_quiz.dart';
import 'shared/repositories/firebase/auth_repository.dart';
import 'shared/repositories/firebase/firestore_repository.dart';
import 'shared/repositories/firebase/storage_repository.dart';
import 'shared/theme/tema.dart';

class ClubeDeMatematicaModule extends MainModule {
  @override
  //Um Bind é uma injeção de dependência.
  //Como este é o módulo plincipal (MainModule), ela estará disponível para todo o app.
  List<Bind> get binds => [
    Bind((i) => MeuTema()),

    //Controles
    Bind((i) => ClubeDeMatematicaController()),

    //Repositórios
    Bind((i) => AuthRepository(i.get<FirebaseAuth>())),
    Bind((i) => FirestoreRepository(i.get<FirebaseFirestore>(), i.get<AuthRepository>())),
    Bind((i) => StorageRepository(i.get<FirebaseStorage>(), i.get<AuthRepository>())),

    //Firebase
    Bind((i) => FirebaseFirestore.instance),
    Bind((i) => FirebaseStorage.instance),
    Bind((i) => FirebaseAuth.instance),
  ];

  @override
  //Lista de rotas.
  List<ModularRouter> get routers => [
    //ModularRouter(Modular.initialRoute, module: QuizModule()),
    ModularRouter(ROTA_PAGINA_QUIZ, module: QuizModule()),
  ];

  @override
  //O bootstrap é o widgwt principal.
  Widget get bootstrap => ClubeDeMatematicaWidget();

}
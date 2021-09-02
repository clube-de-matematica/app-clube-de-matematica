import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/repositories/firebase/firestore_repository.dart';
import '../../shared/repositories/firebase/storage_repository.dart';
import '../filtros/filtros_module.dart';
import '../filtros/shared/models/filtros_model.dart';
import 'pages/quiz/quiz_controller.dart';
import 'pages/quiz/quiz_page.dart';
import 'shared/repositories/assuntos_repository.dart';
import 'shared/repositories/imagem_questao_repository.dart';
import 'shared/repositories/questoes_repository.dart';

///Um submódulo do módulo principal [ClubeDeMatematicaModule].
class QuizModule extends Module {
  ///Rota relativa.
  static const kRelativeRouteModule = "/quiz";

  ///Rota absoluta.
  static const kAbsoluteRouteModule = kRelativeRouteModule;

  ///Rota relativa.
  static const kRelativeRouteQuizPage = "/";

  ///Rota absoluta.
  static const kAbsoluteRouteQuizPage =
      kAbsoluteRouteModule + kRelativeRouteQuizPage;

  @override
  //Um Bind é uma injeção de dependência.
  List<Bind> get binds => [
        Bind((i) => Filtros()),

        //Controles
        Bind((i) =>
            QuizController(i.get<ImagemQuestaoRepository>(), i.get<Filtros>())),

        //Repositórios
        Bind((i) => QuestoesRepository(
            i.get<FirestoreRepository>(), i.get<AssuntosRepository>())),
        Bind((i) => AssuntosRepository(i.get<FirestoreRepository>())),
        Bind((i) => ImagemQuestaoRepository(i.get<StorageRepository>())),
      ];

  @override
  //Lista de rotas.
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => QuizPage()),
        ModuleRoute(FiltrosModule.kRelativeRouteModule, module: FiltrosModule()),
      ];
}

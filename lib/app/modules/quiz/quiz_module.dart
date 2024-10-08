import 'package:flutter_modular/flutter_modular.dart';

import '../../services/preferencias_servicos.dart';
import '../../shared/repositories/questoes/questoes_repository.dart';
import '../filtros/filtros_module.dart';
import '../filtros/shared/models/filtros_model.dart';
import 'pages/quiz/quiz_controller.dart';
import 'pages/quiz/quiz_page.dart';

/// Um submódulo do módulo principal [ClubeDeMatematicaModule].
class QuizModule extends Module {
  /// Rota relativa.
  static const kRelativeRouteModule = "/quiz";

  /// Rota absoluta.
  static const kAbsoluteRouteModule = kRelativeRouteModule;

  /// Rota relativa.
  static const kRelativeRouteQuizPage = "/";

  /// Rota absoluta.
  static const kAbsoluteRouteQuizPage =
      kAbsoluteRouteModule + kRelativeRouteQuizPage;

  @override
  // Um Bind é uma injeção de dependência.
  List<Bind> get binds => [
        Bind<Filtros>((i) => Preferencias.instancia.filtrosQuiz),

        // Controles
        Bind((i) => QuizController(
              filtros: i.get<Filtros>(),
              repositorio: i.get<QuestoesRepository>(),
            )),
      ];

  @override
  // Lista de rotas.
  List<ModularRoute> get routes => [
        if (Modular.initialRoute != kRelativeRouteQuizPage)
          RedirectRoute(Modular.initialRoute, to: kRelativeRouteQuizPage),
        ChildRoute(kRelativeRouteQuizPage, child: (_, __) => const QuizPage()),
        ModuleRoute(FiltrosModule.kRelativeRouteModule,
            module: FiltrosModule()),
      ];
}

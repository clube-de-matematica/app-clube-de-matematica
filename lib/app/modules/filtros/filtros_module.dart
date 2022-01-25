import 'package:flutter_modular/flutter_modular.dart';

import '../quiz/quiz_module.dart';
import 'pages/home/filtro_home_page.dart';

/// Um submódulo de [QuizModule].
class FiltrosModule extends Module {
  /// Rota relativa.
  static const kRelativeRouteModule = "/filtros";

  /// Rota absoluta.
  static final kAbsoluteRouteModule =
      QuizModule.kAbsoluteRouteModule + kRelativeRouteModule;

  /// Rota relativa.
  static const kRelativeRouteFiltroHomePage = "";

  /// Rota absoluta.
  static final kAbsoluteRouteFiltroHomePage =
      kAbsoluteRouteModule + kRelativeRouteFiltroHomePage;

  @override
  // Um Bind é uma injeção de dependência.
  List<Bind> get binds => [];

  @override
  // Lista de rotas.
  List<ModularRoute> get routes => [
        ChildRoute(
          kRelativeRouteFiltroHomePage,
          child: (_, args) => FiltroHomePage(filtro: args.data),
        ),
      ];
}

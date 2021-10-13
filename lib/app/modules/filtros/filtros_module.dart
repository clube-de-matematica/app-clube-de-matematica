import 'package:flutter_modular/flutter_modular.dart';

import '../../navigation.dart';
import '../quiz/quiz_module.dart';
import 'pages/opcoes/filtro_opcoes_page.dart';
import 'pages/tipos/filtro_tipos_controller.dart';
import 'pages/tipos/filtro_tipos_page.dart';
import 'shared/models/filtros_model.dart';

///Um submódulo de [QuizModule].
class FiltrosModule extends Module {
  ///Rota relativa.
  static const kRelativeRouteModule = "/filtros";

  ///Rota absoluta.
  static final kAbsoluteRouteModule =
      RouteModule.quiz.name + kRelativeRouteModule;

  ///Rota relativa.
  static const kRelativeRouteFiltroTiposPage = "";

  ///Rota absoluta.
  static final kAbsoluteRouteFiltroTiposPage =
      kAbsoluteRouteModule + kRelativeRouteFiltroTiposPage;

  ///Rota relativa.
  static const kRelativeRouteFiltroOpcoesPage = "/opcoes";

  ///Rota absoluta.
  static final kAbsoluteRouteFiltroOpcoesPage =
      kAbsoluteRouteModule + kRelativeRouteFiltroOpcoesPage;

  @override
  //Um Bind é uma injeção de dependência.
  List<Bind> get binds => [
        //Controles
        Bind((i) => FiltroTiposController(
            filtrosAplicados: i.get<Filtros>(),
            filtrosTemp: Filtros.from(i.get<Filtros>()))),
      ];

  @override
  //Lista de rotas.
  List<ModularRoute> get routes => [
        //ChildRoute(Modular.initialRoute, child: (_, __) => FiltroTiposPage()),
        ChildRoute(
          kRelativeRouteFiltroTiposPage,
          child: (_, __) => FiltroTiposPage(),
        ),
        ChildRoute(
          kRelativeRouteFiltroOpcoesPage,
          child: (_, args) => FiltroOpcoesPage(args.data),
          transition: TransitionType.noTransition,
        ),
      ];
}

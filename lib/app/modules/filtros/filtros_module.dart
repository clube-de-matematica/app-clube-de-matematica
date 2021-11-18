import 'package:flutter_modular/flutter_modular.dart';

import '../../navigation.dart';
import '../quiz/quiz_module.dart';
import 'pages/opcoes/filtro_opcoes_page.dart';
import 'pages/tipos/filtro_tipos_page.dart';

///Um submódulo de [QuizModule].
class FiltrosModule extends Module {
  ///Rota relativa.
  static const kRelativeRouteModule = "/filtros";

  ///Rota absoluta.
  static final kAbsoluteRouteModule =
      RotaModulo.quiz.nome + kRelativeRouteModule;

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
  List<Bind> get binds => [];

  @override
  //Lista de rotas.
  List<ModularRoute> get routes => [
        //ChildRoute(Modular.initialRoute, child: (_, __) => FiltroTiposPage()),
        ChildRoute(
          kRelativeRouteFiltroTiposPage,
          child: (_, args) => FiltroTiposPage(filtro: args.data),
        ),
        ChildRoute(
          kRelativeRouteFiltroOpcoesPage,
          child: (_, args) => FiltroOpcoesPage(args.data),
          transition: TransitionType.noTransition,
        ),
      ];
}

import 'package:clubedematematica/app/modules/clubes/pages/clube_controller.dart';
import 'package:clubedematematica/app/modules/clubes/pages/clube_page.dart';
import 'package:clubedematematica/app/modules/clubes/pages/home/home_clubes_page.dart';
import 'package:clubedematematica/app/modules/quiz/quiz_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ClubesModule extends Module {
  ///Rota relativa.
  static const kRelativeRouteModule = "/clubes";

  ///Rota absoluta.
  static const kAbsoluteRouteModule =
      QuizModule.kAbsoluteRouteModule + kRelativeRouteModule;

  @override
  //Um Bind é uma injeção de dependência.
  List<Bind> get binds => [
        //Controles
        Bind((i) => ClubeController()),
      ];

  @override
  //Lista de rotas.
  List<ModularRoute> get routes => [
        ChildRoute(kRelativeRouteModule, child: (_, __) => HomeClubesPage()),
        /* ChildRoute(
          '$kRelativeRouteModule/:id',
          child: (_, args) => ClubePage(id: args.params['id']),
        ),
        ChildRoute(
          kRelativeRouteFiltroOpcoesPage,
          child: (_, args) => FiltroOpcoesPage(args.data),
          transition: TransitionType.noTransition,
        ), */
      ];
}

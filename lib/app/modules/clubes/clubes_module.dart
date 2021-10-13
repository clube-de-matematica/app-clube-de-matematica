import 'package:flutter_modular/flutter_modular.dart';

import 'pages/clube_controller.dart';
import 'pages/clube_page.dart';
import 'pages/home/home_clubes_controller.dart';
import 'pages/home/home_clubes_page.dart';

class ClubesModule extends Module {
  ///Rota relativa.
  static const kRelativeRouteModule = "/clubes";

  ///Rota absoluta.
  static const kAbsoluteRouteModule = kRelativeRouteModule;

  ///Rota relativa.
  static const kRelativeRouteHomePage = '';

  ///Rota absoluta.
  static const kAbsoluteRouteHomePage =
      kAbsoluteRouteModule + kRelativeRouteHomePage;

  @override
  //Um Bind é uma injeção de dependência.
  List<Bind> get binds => [
        //Controles
        Bind((i) => ClubeController()),
        Bind((i) => HomeClubesController()),
      ];

  @override
  //Lista de rotas.
  List<ModularRoute> get routes => [
        ChildRoute(kRelativeRouteHomePage, child: (_, __) => HomeClubesPage()),
        ChildRoute(
          '/:id',
          child: (_, args) => ClubePage(args.data),
        ),
        // Redirecionar para a página inicial quando uma rota não for encontrada.
        //WildcardRoute(child: (_, __) => HomeClubesPage()),
      ];
}

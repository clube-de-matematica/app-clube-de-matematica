import 'package:flutter_modular/flutter_modular.dart';

import 'modules/atividades/atividades_module.dart';
import 'pages/clube/clube_controller.dart';
import 'pages/clube/clube_page.dart';
import 'pages/criar/criar_clube_page.dart';
import 'pages/editar/editar_clube_page.dart';
import 'pages/home/home_clubes_controller.dart';
import 'pages/home/home_clubes_page.dart';
import 'shared/utils/tema_clube.dart';

class ClubesModule extends Module {
  ///Rota relativa.
  static const kRelativeRouteModule = "/clubes";

  ///Rota absoluta.
  static const kAbsoluteRouteModule = kRelativeRouteModule;

  ///Rota relativa.
  static const kRelativeRouteHomePage = '/';

  ///Rota absoluta.
  static const kAbsoluteRouteHomePage =
      kAbsoluteRouteModule + kRelativeRouteHomePage;

  ///Rota relativa.
  static const kRelativeRouteCriarPage = '/novo';

  ///Rota absoluta.
  static const kAbsoluteRouteCriarPage =
      kAbsoluteRouteModule + kRelativeRouteCriarPage;

  ///Rota relativa.
  static const kRelativeRouteEditarPage = '/editar';

  ///Rota absoluta.
  static const kAbsoluteRouteEditarPage =
      kAbsoluteRouteModule + kRelativeRouteEditarPage;

  Bind<TemaClube>? _bindTemaClube;

  Bind<ClubeController>? _bindClubeController;

  List<Bind> _binds = [
    //Controles
    Bind((i) => HomeClubesController()),
  ];

  @override
  //Um Bind é uma injeção de dependência.
  List<Bind> get binds => _binds;

  @override
  List<ModularRoute> get routes => [
        if (Modular.initialRoute != kRelativeRouteHomePage)
          RedirectRoute(Modular.initialRoute, to: kRelativeRouteHomePage),

        ChildRoute(kRelativeRouteHomePage,
            child: (_, __) => const HomeClubesPage()),
        ChildRoute(kRelativeRouteCriarPage,
            child: (_, __) => const CriarClubePage()),
        ChildRoute(kRelativeRouteEditarPage,
            child: (_, args) => EditarClubePage(args.data)),
        ChildRoute('/:id', child: (_, args) {
          final clube = args.data;
          Modular.dispose<TemaClube>();
          Modular.dispose<ClubeController>();
          /* _injector?.addSingleton((_) => TemaClube(clube));
          _injector?.addSingleton((_) => ClubeController(clube)); */
          _binds = [
            ..._binds
                .where((b) => b != _bindTemaClube && b != _bindClubeController),
            _bindTemaClube = Bind((_) => TemaClube(clube)),
            _bindClubeController = Bind((_) => ClubeController(clube)),
          ];
          changeBinds(_binds);

          return ClubePage(clube);
        }),
        ModuleRoute(AtividadesModule.kRelativeRouteModule,
            module: AtividadesModule()),
        // Redirecionar para a página inicial quando uma rota não for encontrada.
        //r.wildcard(child: (_) => HomeClubesPage()),
      ];
}

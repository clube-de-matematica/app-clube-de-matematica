import 'package:flutter_modular/flutter_modular.dart';

import '../../clubes_module.dart';
import 'pages/criar/criar_atividade_page.dart';
import 'pages/editar/editar_atividade_page.dart';
import 'pages/responder/reponder_atividade_page.dart';

class AtividadesModule extends Module {
  ///Rota relativa.
  static const kRelativeRouteModule = "/atividades";

  ///Rota absoluta.
  static const kAbsoluteRouteModule =
      ClubesModule.kAbsoluteRouteModule + kRelativeRouteModule;

  ///Rota relativa.
  static const kRelativeRouteAtividadePage = '';

  ///Rota absoluta.
  static const kAbsoluteRouteAtividadePage =
      kAbsoluteRouteModule + kRelativeRouteAtividadePage;

  ///Rota relativa.
  static const kRelativeRouteCriarPage = '/nova';

  ///Rota absoluta.
  static const kAbsoluteRouteCriarPage =
      kAbsoluteRouteModule + kRelativeRouteCriarPage;

  ///Rota relativa.
  static const kRelativeRouteEditarPage = '/editar';

  ///Rota absoluta.
  static const kAbsoluteRouteEditarPage =
      kAbsoluteRouteModule + kRelativeRouteEditarPage;

  @override
  //Um Bind é uma injeção de dependência.
  List<Bind> get binds => [
        //Controles
        //Bind((i) => HomeClubesController()),
      ];

  @override
  //Lista de rotas.
  List<ModularRoute> get routes => [
        ChildRoute(kAbsoluteRouteAtividadePage,
            child: (_, args) => ResponderAtividadePage(args.data)),
        ChildRoute(kRelativeRouteCriarPage,
            child: (_, args) => CriarAtividadePage(args.data)),
        ChildRoute(kRelativeRouteEditarPage,
            child: (_, args) => EditarAtividadePage(args.data)),
      ];
}

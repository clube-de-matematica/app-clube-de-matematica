import 'package:flutter_modular/flutter_modular.dart';

import 'inserir_questao_page.dart';

class InserirQuestaoModule extends Module {
  ///Rota relativa.
  static const kRelativeRouteModule = "/inserir_questao";

  ///Rota absoluta.
  static const kAbsoluteRouteModule = kRelativeRouteModule;

  ///Rota relativa.
  static const kRelativeRouteInserirQuestaoPage = "/";

  ///Rota absoluta.
  static const kAbsoluteRouteInserirQuestaoPage =
      kAbsoluteRouteModule + kRelativeRouteInserirQuestaoPage;

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        if (Modular.initialRoute != kRelativeRouteInserirQuestaoPage)
          RedirectRoute(Modular.initialRoute,
              to: kRelativeRouteInserirQuestaoPage),
        ChildRoute(kRelativeRouteInserirQuestaoPage,
            child: (_, __) => const InserirQuestaoPage()),
      ];
}

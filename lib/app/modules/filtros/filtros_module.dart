import 'package:flutter_modular/flutter_modular.dart';

import 'pages/opcoes/filtro_opcoes_page.dart';
import 'pages/tipos/filtro_tipos_controller.dart';
import 'pages/tipos/filtro_tipos_page.dart';
import 'shared/models/filtros_model.dart';
import 'shared/utils/rotas_filtros.dart';

///Um submódulo de [QuizModule].
class FiltrosModule extends Module {
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
        ChildRoute(Modular.initialRoute, child: (_, __) => FiltroTiposPage()),
        ChildRoute(ROTA_PAGINA_FILTROS_TIPOS,
            child: (_, __) => FiltroTiposPage()),
        ChildRoute(ROTA_PAGINA_FILTROS_OPCOES,
            child: (_, args) => FiltroOpcoesPage(args.data),
            transition: TransitionType.noTransition),
      ];
}

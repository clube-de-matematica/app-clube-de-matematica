import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/repositories/firebase/firestore_repository.dart';
import '../../shared/repositories/firebase/storage_repository.dart';
import '../filtros/filtros_module.dart';
import '../filtros/shared/models/filtros_model.dart';
import '../filtros/shared/utils/rotas_filtros.dart';
import 'pages/quiz/quiz_controller.dart';
import 'pages/quiz/quiz_page.dart';
import 'shared/repositories/assuntos_repository.dart';
import 'shared/repositories/imagem_item_repository.dart';
import 'shared/repositories/itens_repository.dart';

///Um submódulo do módulo principal [ClubeDeMatematicaModule].
class QuizModule extends ChildModule {
  @override
  //Um Bind é uma injeção de dependência.
  List<Bind> get binds => [
    Bind((i) => Filtros()),
    
    //Controles
    Bind((i) => QuizController(i.get<ImagemItemRepository>(), i.get<Filtros>())),

    //Repositórios
    Bind((i) => ItensRepository(i.get<FirestoreRepository>(), i.get<AssuntosRepository>())),
    Bind((i) => AssuntosRepository(i.get<FirestoreRepository>())),
    Bind((i) => ImagemItemRepository(i.get<StorageRepository>())),
  ];

  @override
  //Lista de rotas.
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, __) => QuizPage()),
    ModularRouter(ROTA_MODULO_FILTROS, module: FiltrosModule()),
  ];
  
}
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'navigation.dart';
import 'services/db_servicos_interface.dart';
import 'services/preferencias_servicos.dart';
import 'shared/repositories/interface_auth_repository.dart';
import 'shared/theme/appTheme.dart';
import 'shared/utils/constantes.dart';

/// O [Widget] principal do aplicativo.
class ClubeDeMatematicaWidget extends StatefulWidget {
  @override
  State<ClubeDeMatematicaWidget> createState() =>
      _ClubeDeMatematicaWidgetState();
}

class _ClubeDeMatematicaWidgetState extends State<ClubeDeMatematicaWidget> {
  @override
  void dispose() {
    Modular.get<IDbServicos>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute(
      Modular.get<IAuthRepository>().logged ||
              Preferencias.instancia.primeiroAcesso != null
          ? RotaPagina.quiz.nome
          : RotaPagina.login.nome,
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: APP_NOME,
      theme: AppTheme.instance.temaClaro,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('pt', 'BR'),
        const Locale('pt', ''),
      ],
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      /* builder: (context, child) {
        return child ?? SizedBox();
        /* /// Isso criará um [Scaffold] abaixo do [Navigator], mas acima de todas as rotas.
        return Scaffold(
          key: rootScaffoldKey,
          drawer: AppDrawer(key: rootDrawerKey),
          body: child,
        ); */
      }, */
    );
  }
}
/* 
openRootDrawer(BuildContext context) {
  // Esta é uma operação que deve ser evitada em uma arvore de widgets muito extensa.
  // Alternativamente, pode-se usar uma [GlobalKey] no [Scaffold] desejado e expô-la.
  // context.findRootAncestorStateOfType<ScaffoldState>()?.openDrawer();
  rootScaffoldKey.currentState?.openDrawer();
}

bool get isRootDrawerOpen =>
    rootScaffoldKey.currentState?.isDrawerOpen ?? false;

/// Alternativa ao uso de [BuildContext.findRootAncestorStateOfType] em [openRootDrawer].
final GlobalKey<ScaffoldState> rootScaffoldKey = GlobalKey<ScaffoldState>();

final GlobalKey<State<AppDrawer>> rootDrawerKey = GlobalKey<State<AppDrawer>>();
 */
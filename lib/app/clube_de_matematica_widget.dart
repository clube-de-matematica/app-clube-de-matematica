import 'package:clubedematematica/app/services/db_servicos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'navigation.dart';
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
    Modular.get<DbServicos>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NOME,
      theme: AppTheme.instance.temaClaro,
      initialRoute: Modular.get<IAuthRepository>().logged
          ? RotaPagina.quiz.nome
          : RotaPagina.login.nome,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('pt', 'BR'),
        const Locale('pt', ''),
      ],
      /* builder: (context, child) {
        /// Isso criará um [Scaffold] abaixo do [Navigator], mas acima de todas as rotas.
        return Scaffold(
          key: rootScaffoldKey,
          drawer: AppDrawer(key: rootDrawerKey),
          body: child,
        );
      }, */
    ).modular();
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
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'services/db_servicos_interface.dart';
import 'shared/theme/appTheme.dart';
import 'shared/utils/constantes.dart';

/// O [Widget] principal do aplicativo.
class ClubeDeMatematicaWidget extends StatefulWidget {
  const ClubeDeMatematicaWidget({super.key});

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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: APP_NOME,
      theme: AppTheme.instance.light,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('pt', ''),
      ],
      //routerConfig: Modular.routerConfig,
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

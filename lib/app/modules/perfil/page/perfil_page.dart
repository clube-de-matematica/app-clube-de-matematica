import 'package:clubedematematica/app/shared/theme/tema.dart';
import 'package:clubedematematica/app/shared/widgets/scrollViewWithChildExpandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'perfil_controller.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends ModularState<PerfilPage, PerfilController> {
  double get escala => MeuTema.escala;

  ThemeData get tema => Theme.of(context);

  ///Tom mais escuro. Usado no "bem cindo" e no texto do botão de login com o Google.
  Color get textColor1 => tema.colorScheme.onSurface.withOpacity(0.6);

  ///Tom mais claro. Usado na mensagem e no texto do botão de login anônimo.
  Color get textColor2 => textColor1.withOpacity(0.5);

  ///Estilo do texto do "bem vindo".
  TextStyle get textStyleH1 => tema.textTheme.bodyText1.copyWith(
        fontSize: 24 * escala,
        color: textColor1,
      );

  ///Estilo do texto da mensagem.
  TextStyle get textStyleH2 => textStyleH1.copyWith(color: textColor2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //padding: EdgeInsetsDirectional.only(bottom: MediaQuery.of(context).size.height * 0.2),
        color: tema.colorScheme.primary.withOpacity(0.02),
        child: Column(
          children: [
            ///`Container` com a altura da barra de status.
            Container(
              height: MediaQuery.of(context).padding.top,
              color: tema.colorScheme.primary,
            ),

            ///Corpo da página.
            ScrollViewWithChildExpandable(
              child: Column(
                children: [
                  ///"Bem vindo" e mensagem.
                  /* Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: ,
                    ),
                  ), */

                  ///Botão de login com o Google.
                  /* Align(
                    alignment: Alignment.bottomCenter,
                    child: ,
                  ), */

                  ///Botão de autenticação anônima.
                  /* Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ,
                    ),
                  ), */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
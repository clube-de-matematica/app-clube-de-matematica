import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'login_controller.dart';
import '../utils/strings_interface.dart';
import '../../../shared/theme/tema.dart';
import '../../../shared/widgets/scrollViewWithChildExpandable.dart';

import 'dart:developer' as dev;

///Página de login.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
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
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LOGIN_MSG_BEM_VINDO + "\n",
                              style: textStyleH1,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              LOGIN_MSG_SOB_BEM_VINDO,
                              style: textStyleH2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ///Botão de login com o Google.
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buttonLoginWithGoogle(),
                  ),

                  ///Botão de autenticação anônima.
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _buttonLoginAnonymously(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Retorna o botão de autenticação anônima.
  Widget _buttonLoginAnonymously() {
    return Observer(
      builder: (_) {
        final clicked =
            controller.loading && controller.selectedMethod == Login.anonymous;
        return TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: clicked ? 0.0 : 1.0,
                onEnd: () {},
                child: Text(
                  LOGIN_TEXT_BUTTON_USER_ANONYMOUS,
                  style: tema.textTheme.bodyText1.copyWith(
                    decoration: TextDecoration.underline,
                    decorationThickness: 0.75,
                    color: textColor2,
                  ),
                ),
              ),
              !clicked
                  ? const SizedBox()
                  : const SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: Center(
                        child:
                            const CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                    ),
            ],
          ),
          onPressed: controller.loading
              //Desativar.
              ? null
              //Ativar
              : () async {
                  if (await _gerarDialogoConfirmarLoginAnonymously()) {
                    final autenticado =
                        await controller.onTapLoginAnonymously();
                    if (!autenticado) _gerarDialogoErroLogin();
                  }
                },
        );
      },
    );
  }

  ///Retorna o botão de login com o Google.
  Widget _buttonLoginWithGoogle() {
    return Observer(
      builder: (_) {
        final clicked =
            controller.loading && controller.selectedMethod == Login.google;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: tema.colorScheme.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: clicked ? 0.0 : 1.0,
                onEnd: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 10.0,
                      child: Image(
                        image: AssetImage(controller.assetPathIconGoogle),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        LOGIN_TEXT_BUTTON_USER_GOOGLE,
                        style: tema.textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w500,
                          color: textColor1,
                          fontSize: escala * 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              !clicked
                  ? const SizedBox()
                  : const SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: Center(
                        child:
                            const CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                    ),
            ],
          ),
          onPressed: controller.loading
              //Desativar.
              ? () {}
              //Ativar
              : () async {
                  final autenticado = await controller.onTapLoginWithGoogle();
                  if (!autenticado) _gerarDialogoErroLogin();
                },
        );
      },
    );
  }

  ///Abre um popup informando os recursos que não estarão disponíveis enquanto o usuário
  ///estiver conectado anonimamente.
  ///Retorna `true` se o usuário confirmar que deseja continuar conectado anonimamente.
  Future<bool> _gerarDialogoConfirmarLoginAnonymously() async {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: tema.textTheme.bodyText1.copyWith(
            fontSize: 18 * escala,
            color: textColor1,
            fontWeight: FontWeight.w500,
          ),
          contentTextStyle: tema.textTheme.bodyText1.copyWith(
            fontSize: 16 * escala,
            color: textColor2,
          ),
          title: const Text(
            LOGIN_DIALOG_CONFIRM_USER_ANONYMOUS_TITLE,
            textAlign: TextAlign.justify,
          ),
          content: SingleChildScrollView(
            child: const Text(
              LOGIN_DIALOG_CONFIRM_USER_ANONYMOUS_MSG,
              textAlign: TextAlign.justify,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                  LOGIN_DIALOG_CONFIRM_USER_ANONYMOUS_TEXT_BUTTON_CANCEL),
              onPressed: () => Navigator.pop<bool>(context, false),
            ),
            TextButton(
              child: const Text(
                  LOGIN_DIALOG_CONFIRM_USER_ANONYMOUS_TEXT_BUTTON_CONFIRM),
              onPressed: () => Navigator.pop<bool>(context, true),
            ),
          ],
        );
      },
    );
  }

  ///Abre um popup informando que houve um erro durante a autenticação.
  Future<void> _gerarDialogoErroLogin() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: tema.textTheme.bodyText1.copyWith(
            fontSize: 18 * escala,
            color: textColor1,
            fontWeight: FontWeight.w500,
          ),
          contentTextStyle: tema.textTheme.bodyText1.copyWith(
            fontSize: 16 * escala,
            color: textColor2,
          ),
          title: const Text(
            LOGIN_DIALOG_CONFIRM_ERRO_LOGIN_TITLE,
            textAlign: TextAlign.justify,
          ),
          content: SingleChildScrollView(
            child: const Text(
              LOGIN_DIALOG_CONFIRM_ERRO_LOGIN_MSG,
              textAlign: TextAlign.justify,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(LOGIN_DIALOG_ERRO_LOGIN_TEXT_BUTTON_CLOSE),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}

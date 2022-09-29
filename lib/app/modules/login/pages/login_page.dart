import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../services/preferencias_servicos.dart';
import '../../../shared/repositories/interface_auth_repository.dart';
import '../../../shared/theme/appTheme.dart';
import '../../../shared/widgets/appBottomSheet.dart';
import '../../../shared/widgets/appWillPopScope.dart';
import '../../../shared/widgets/botoes.dart';
import '../../../shared/widgets/scrollViewWithChildExpandable.dart';
import '../utils/ui_strings.dart';
import '../widgets/login_with_google_button.dart';
import 'login_controller.dart';

/// Página de login.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
  double get escala => AppTheme.escala;

  ThemeData get tema => Theme.of(context);

  /// Tom mais escuro. Usado no "bem cindo" e no texto do botão de login com o Google.
  Color get textColor1 => tema.colorScheme.onSurface.withOpacity(0.6);

  /// Tom mais claro. Usado na mensagem e no texto do botão de login anônimo.
  Color get textColor2 => textColor1.withOpacity(0.5);

  /// Estilo do texto do "bem vindo".
  TextStyle? get textStyleH1 => tema.textTheme.bodyText1?.copyWith(
        fontSize: 24 * escala,
        color: textColor1,
      );

  /// Estilo do texto da mensagem.
  TextStyle? get textStyleH2 => textStyleH1?.copyWith(color: textColor2);

  @override
  void initState() {
    super.initState();
    Preferencias.instancia.exibirMsgTermosCondicoesPolitica = true;
    Preferencias.instancia.aceiteTermosCondicoesPolitica = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      () async {
        int contador = 0;
        while (!mounted) {
          if (++contador > 30) return;
          await Future.delayed(Duration(seconds: 1));
        }
        BottomSheetAvisoConsentimento().showModal(context);
      }();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppWillPopScope(
        child: Container(
          //padding: EdgeInsetsDirectional.only(bottom: MediaQuery.of(context).size.height * 0.2),
          color: Colors.blueGrey[50],
          child: Column(
            children: [
              /// `Container` com a altura da barra de status.
              Container(
                height: MediaQuery.of(context).padding.top,
                color: tema.colorScheme.primary,
              ),

              /// Corpo da página.
              ScrollViewWithChildExpandable(
                child: Column(
                  children: [
                    /// "Bem vindo" e mensagem.
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
                                UIStrings.LOGIN_MSG_BEM_VINDO + "\n",
                                style: textStyleH1,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                UIStrings.LOGIN_MSG_SOB_BEM_VINDO,
                                style: textStyleH2,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Expanded(child: const SizedBox()),

                    /// Botão de login com o Google.
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: LoginWithGoogleButton(
                        margin: EdgeInsets.all(16.0),
                        onPressed: () async {
                          if (!controller.isLoading) {
                            if (!await controller.conectadoInternete) {
                              BottomSheetErroConexao().showModal(context);
                              return;
                            }
                            final result =
                                await controller.onTapLoginWithGoogle();
                            if (result == StatusSignIn.success) {
                              controller.showPerfilPage(context);
                            } else if (result == StatusSignIn.error) {
                              _buildBottomSheetErroLogin().showModal(context);
                            }
                          }
                        },
                      ),
                    ),

                    /// Botão de autenticação anônima.
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: _buildButtonLoginAnonymously(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Retorna o botão de autenticação anônima.
  Widget _buildButtonLoginAnonymously() {
    return Observer(
      builder: (context) {
        final clicked = controller.isLoading &&
            controller.selectedMethod == Login.anonymous;
        return TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                  UIStrings.LOGIN_TEXT_BUTTON_USER_ANONYMOUS,
                  style: tema.textTheme.bodyText1?.copyWith(
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
          onPressed: () async {
            if (!controller.isLoading) {
              if (!await controller.conectadoInternete) {
                BottomSheetErroConexao().showModal(context);
                return;
              }
              final result = await _buildBottomSheetConfirmarLoginAnonymously()
                  .showModal<bool>(context);
              if (result ?? false) {
                final autenticado =
                    await controller.onTapConnectAnonymously(context);
                if (!autenticado) {
                  _buildBottomSheetErroLogin().showModal(context);
                }
              }
            }
          },
        );
      },
    );
  }

  /// Abre uma página inferior informando os recursos que não estarão disponíveis enquanto o usuário
  /// estiver conectado anonimamente.
  /// Ao ser fechada, retorna `true` se o usuário confirmar que deseja continuar conectado anonimamente.
  AppBottomSheet _buildBottomSheetConfirmarLoginAnonymously() {
    return AppBottomSheet(
      content: const Text(
        UIStrings.LOGIN_DIALOG_CONFIRM_USER_ANONYMOUS_MSG,
        textAlign: TextAlign.justify,
      ),
      actions: [
        AppTextButton(
          primary: true,
          child: const Text(UIStrings
              .LOGIN_DIALOG_CONFIRM_USER_ANONYMOUS_TEXT_BUTTON_CONFIRM),
          onPressed: () => Navigator.pop<bool>(context, true),
        ),
        AppTextButton(
          primary: false,
          child: const Text(
              UIStrings.LOGIN_DIALOG_CONFIRM_USER_ANONYMOUS_TEXT_BUTTON_CANCEL),
          onPressed: () => Navigator.pop<bool>(context, false),
        ),
      ],
    );
  }

  /// Abre uma página inferior informando que houve um erro durante a autenticação.
  AppBottomSheet _buildBottomSheetErroLogin() {
    return AppBottomSheet(
      titleTextStyle: tema.textTheme.bodyText1?.copyWith(
        fontSize: 18 * escala,
        color: textColor1,
        fontWeight: FontWeight.w500,
      ),
      contentTextStyle: tema.textTheme.bodyText1?.copyWith(
        fontSize: 16 * escala,
        color: textColor2,
      ),
      title: const Text(
        UIStrings.LOGIN_DIALOG_ERROR_TITLE,
        textAlign: TextAlign.justify,
      ),
      content: SingleChildScrollView(
        child: const Text(
          UIStrings.LOGIN_DIALOG_ERROR_MSG,
          textAlign: TextAlign.justify,
        ),
      ),
      actions: [
        AppTextButton(
          primary: true,
          child: const Text(UIStrings.LOGIN_DIALOG_ERROR_TEXT_BUTTON_CLOSE),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

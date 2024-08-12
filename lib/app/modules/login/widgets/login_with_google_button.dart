import 'package:flutter/material.dart';

import '../../../shared/widgets/button_progress_indicator.dart';
import '../utils/assets_login.dart';
import '../utils/ui_strings.dart';

class LoginWithGoogleButton extends StatefulWidget {
  ///Quando este botão for acionado, permanecerá em progresso até que [onPressed] seja
  ///concluido.
  final Future Function()? onPressed;
  final EdgeInsetsGeometry? margin;

  const LoginWithGoogleButton({
    super.key,
    this.margin,
    required this.onPressed,
  });
  @override
  LoginWithGoogleButtonState createState() => LoginWithGoogleButtonState();
}

class LoginWithGoogleButtonState extends State<LoginWithGoogleButton> {
  ThemeData get tema => Theme.of(context);

  ///Tom mais escuro. Usado no "bem cindo" e no texto do botão de login com o Google.
  Color get textColor1 => tema.colorScheme.onSurface.withOpacity(0.6);

  @override
  Widget build(BuildContext context) {
    return ButtonProgressIndicator(
      primary: Colors.white,
      progressIndicatorColor: tema.colorScheme.primary,
      transform: false,
      elevation: 0.0,
      margin: widget.margin,
      onPressed: widget.onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 12.0,
            backgroundImage: AssetImage(LoginAssets.kGoogleLogo),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 12.0),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              UIStrings.LOGIN_TEXT_BUTTON_USER_GOOGLE,
              style: tema.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: textColor1,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/theme/appTheme.dart';
import '../../../shared/widgets/appBottomSheet.dart';
import '../../../shared/widgets/appWillPopScope.dart';
import '../../../shared/widgets/botoes.dart';
import '../../../shared/widgets/scrollViewWithChildExpandable.dart';
import '../utils/ui_strings.dart';
import '../widgets/avatar.dart';
import 'perfil_controller.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends ModularState<PerfilPage, PerfilController> {
  double get escala => AppTheme.escala;

  ThemeData get tema => Theme.of(context);

  ///Estilo do texto dos rótulos do formulário.
  TextStyle get textStyleLabel => TextStyle(fontSize: 16 * escala);

  ///Key que permitirá o acessado ao formulário.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          final formState = _formKey.currentState;
          if (formState != null) {
            controller.save(
              context,
              formState: formState,
            );
          }
        },
      ),
      body: AppWillPopScope(
        child: Container(
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
                child: Stack(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(32.0, 48.0, 32.0, 16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //Foto do perfil.
                            Center(
                              child: _avatar(),
                            ),
                            //Email do usuário.
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 48.0),
                              child: Center(
                                child: AnimatedBuilder(
                                  animation: controller.user,
                                  builder: (_, __) {
                                    return Text(
                                      controller.user.email ?? "",
                                      style: textStyleLabel,
                                    );
                                  },
                                ),
                              ),
                            ),
                            //Nome do usuário.
                            AnimatedBuilder(
                              animation: controller.user,
                              builder: (_, __) => _textName(),
                            ),
                            //Empurrar os próximos componentes para o final da tela com um espaçamento mínimo de 80 px.
                            const Expanded(child: const SizedBox(height: 80.0)),
                            GestureDetector(
                              onTap: () async {
                                final confirm = await _confirmationBottomSheet(
                                    context,
                                    UIStrings.kAccountChangeConfirmationMsg);
                                if (confirm)
                                  controller.signInWithAnotherAccount(context);
                              },
                              child: const Text(
                                  UIStrings.kChangeAccountButtonTitle),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  final confirm =
                                      await _confirmationBottomSheet(context,
                                          UIStrings.kExitConfirmationMsg);
                                  if (confirm) controller.exit(context);
                                },
                                child: const Text(UIStrings.kExitButtonTitle),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (Navigator.of(context).canPop()) const BackButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _textName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: UIStrings.kNameLabelText,
        labelStyle: textStyleLabel,
        border: const OutlineInputBorder(),
        hintText: UIStrings.kNameHintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(Icons.person),
      ),
      initialValue: controller.name ?? "",
      validator: (valor) => controller.nameValidator(valor),
      onSaved: (valor) => controller.name = valor,
    );
  }

  Widget _avatar() {
    final radius = 48.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          FormField(
            onSaved: (_) => controller.saveImage(),
            builder: (_) {
              return AnimatedBuilder(
                animation: controller.image,
                builder: (_, __) {
                  return Hero(
                    tag: 'hero-avatar',
                    child: Avatar(
                      controller.user,
                      backgroundColor: Colors.black12,
                      backgroundImage: controller.image.value,
                      radius: radius,
                    ),
                    transitionOnUserGestures: true,
                  );
                },
              );
            },
          ),
          _alterarFoto(),
        ],
      ),
    );
  }

  Widget _alterarFoto() {
    final iconTheme = tema.iconTheme;
    final icon = Icons.camera_alt;
    final iconSize = 24.0;
    return Positioned(
      bottom: -(iconSize / 2 + 2),
      right: -(iconSize / 2 + 2),
      child: IconButton(
        iconSize: iconSize,
        onPressed: controller.getImage,
        icon: IconTheme(
          data: iconTheme,
          child: Stack(
            children: <Widget>[
              Center(
                child: Icon(
                  icon,
                  color: Colors.white70,
                  size: (iconTheme.size ?? 0) + 6,
                ),
              ),
              Center(child: Icon(icon)),
            ],
          ),
        ),
      ),
    );
  }

  ///Abre uma página inferior informando uma ação solicitada.
  ///Retorna `true` se o usuário confirmar a ação.
  Future<bool> _confirmationBottomSheet(
      BuildContext context, String message) async {
    final bottomSheet = AppBottomSheet(
      content: Text(
        message,
        textAlign: TextAlign.justify,
      ),
      actions: [
        AppTextButton(
          primary: true,
          child: const Text(UIStrings.kConfirmButtonTitle),
          onPressed: () => Navigator.pop<bool>(context, true),
        ),
        AppTextButton(
          primary: false,
          child: const Text(UIStrings.kCancelButtonTitle),
          onPressed: () => Navigator.pop<bool>(context, false),
        ),
      ],
    );
    final confirm = await bottomSheet.showModal<bool>(context);
    return confirm ?? false;
  }
}

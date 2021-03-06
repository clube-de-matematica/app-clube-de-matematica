import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/theme/tema.dart';
import '../utils/strings_interface.dart';
import '../widgets/avatar.dart';
import 'perfil_controller.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends ModularState<PerfilPage, PerfilController> {
  double get escala => MeuTema.escala;

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
          //if (_formKey.currentState.validate()) _formKey.currentState.save();
          //controller.user.urlAvatar = controller.user.urlAvatar.toString();
        },
      ),
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
            Expanded(
              child: SingleChildScrollView(
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
                                child: Text(
                                  controller.user.email ?? "",
                                  style: textStyleLabel,
                                ),
                              ),
                            ),
                            //Nome do usuário.
                            _textName(),
                          ],
                        ),
                      ),
                    ),
                    const BackButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _textName() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: NOME_LABEL_TEXT,
        labelStyle: textStyleLabel,
        //icon: Icon(Icons.person),
        border: const OutlineInputBorder(),
        hintText: NOME_HINT_TEXT,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(Icons.person),
      ),
      initialValue: controller.user.name ?? "",
      validator: (valor) => controller.nameValidator(valor),
      onSaved: (valor) => controller.name = valor,
    );
  }

  Stack _avatar() {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Avatar(
            controller.user,
            backgroundColor: Colors.black12,
            radius: 48.0,
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: controller.setAvatar,
        )
      ],
    );
  }
}
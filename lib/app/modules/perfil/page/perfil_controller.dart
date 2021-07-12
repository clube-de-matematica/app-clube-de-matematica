import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/repositories/firebase/auth_repository.dart';
import '../../login/login_module.dart';
import '../../quiz/quiz_module.dart';
import '../models/userapp.dart';
import '../utils/strings_interface.dart';

class PerfilController {
  final UserApp user;
  PerfilController(this.user);

  ///Imágem do avatar.
  final image = ValueNotifier<ImageProvider<Object>?>(null);

  ///Caminho temporário da imagem selecionada para o avatar, caso tenha sido alterada.
  String? _pathImageTemp;

  ///Rota absoluta para a página do quiz.
  String get quizRoute => QuizModule.kAbsoluteRouteQuizPage;

  ///Retorna uma `String` com uma mensagem correspondente a um erro de validação para o nome digitado pelo usuário.
  ///Retorna `null` se o nome for válido.
  String? nameValidator(valor) {
    if (valor.isEmpty) return VALIDACAO_NOME_MSG_CAMPO_OBRIGATORIO;
    if (valor.trim().length < 3) return VALIDACAO_NOME_MSG_MIN_CARACTER;
    return null;
  }

  ///Nome do usuário.
  String? get name => user.name;

  ///Nome do usuário.
  set name(String? valor) => user.name = valor;

  Future<ImageProvider?> getImage() async {
    final picker = ImagePicker();

    ///Observe que na plataforma da web `(kIsWeb == true)`, `File` não está disponível,
    ///portanto, o `path` do `PickedFile` apontará para um recurso de rede.
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pathImageTemp = pickedFile.path;
      if (kIsWeb)
        image.value = NetworkImage(_pathImageTemp!);
      else
        image.value = FileImage(File(_pathImageTemp!));
      return image.value;
    }
    return null;
  }

  void saveImage() {
    if (_pathImageTemp != null) user.pathAvatar = _pathImageTemp;
  }

  Future<void> exit() async {
    await user.signOut();
    Modular.to.pushNamedAndRemoveUntil(
        LoginModule.kAbsoluteRouteLoginPage, (_) => false);
  }

  ///Entrar com outra conta do Google.
  Future<StatusSignIn> signInWithAnotherAccount() async {
    return user.signInWithGoogle(true);
  }

  void save({
    required FormState formState,
    required NavigatorState navigatorState,
  }) {
    formState.save();
    //Chamar uma nova rota e fechar todas as demais.
    if (user.connected) {
      //Para que pushNamedAndRemoveUntil funcione foi necessário comentar um trecho
      //de código no método _onPopPage de ModularRouterDelegate, a saber:
      /* 
        if (route.isFirst) {
          rebuildPages();
          return false;
        } 
      */
      final pages = navigatorState.widget.pages;
      final previousPage = pages[pages.length > 1 ? pages.length - 2 : 0].name;
      if (previousPage == quizRoute) {
        navigatorState.popUntil(ModalRoute.withName(quizRoute));
      } else {
        navigatorState.pushNamedAndRemoveUntil(quizRoute, (route) => false);
      }
      //navigatorState.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Teste()), (route) => false);
    }
  }
}

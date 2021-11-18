import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../../navigation.dart';
import '../../../shared/repositories/interface_auth_repository.dart';
import '../models/userapp.dart';
import '../utils/ui_strings.dart';

class PerfilController {
  final IAuthRepository auth;
  PerfilController(this.auth);

  /// Imágem do avatar.
  final image = ValueNotifier<ImageProvider<Object>?>(null);

  /// Caminho temporário da imagem selecionada para o avatar, caso tenha sido alterada.
  String? _pathImageTemp;

  /// Retorna uma `String` com uma mensagem correspondente a um erro de validação para o nome digitado pelo usuário.
  /// Retorna `null` se o nome for válido.
  String? nameValidator(valor) {
    if (valor.isEmpty) return UIStrings.kNameValidationMsgCampoObrigatotio;
    if (valor.trim().length < 3) return UIStrings.kNameValidationMsgMinCaracter;
    return null;
  }

  /// Usuário do aplicativo.
  UserApp get user => auth.user;

  /// Nome do usuário.
  String? get name => user.name;

  /// Nome do usuário.
  set name(String? valor) => user.name = valor?.trim();

  Future<ImageProvider?> getImage() async {
    final picker = ImagePicker();

    /// Observe que na plataforma da web `(kIsWeb == true)`, `File` não está disponível,
    /// portanto, o `path` do `pickedFile` apontará para um recurso de rede.
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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

  Future<void> exit(BuildContext context) async {
    await auth.signOut();
    /* Modular.to.pushNamedAndRemoveUntil(
        LoginModule.kAbsoluteRouteLoginPage, (_) => false); */
    Navegacao.abrirPagina(context, RotaPagina.login);
  }

  /// Entrar com outra conta do Google.
  Future<StatusSignIn> signInWithAnotherAccount(BuildContext context) async {
    final result = await auth.signInWithGoogle(true);
    if (result != StatusSignIn.success) {
      /* Modular.to.pushNamedAndRemoveUntil(
          LoginModule.kAbsoluteRouteLoginPage, (_) => false); */
      Navegacao.abrirPagina(context, RotaPagina.login);
    }
    return result;
  }

  void save(
    BuildContext context, {
    required FormState formState,
    //required NavigatorState navigatorState,
  }) {
    if (formState.validate()) {
      formState.save();
      //Chamar uma nova rota e fechar todas as demais.

      // TODO: Verificar o método pushNamedAndRemoveUntil() de ModularRouterDelegate,
      // Para que pushNamedAndRemoveUntil funcione foi necessário modificar,
      // em [ModularRouterDelegate],
      /* 
        Future<T?> pushNamedAndRemoveUntil<T extends Object?>(String newRouteName, bool Function(Route) predicate, {Object? arguments, bool forRoot = false}) {
          popUntil(predicate);
          return pushNamed<T>(newRouteName, arguments: arguments, forRoot: forRoot);
        }

        para

        Future<T?> pushNamedAndRemoveUntil<T extends Object?>(String newRouteName, bool Function(Route) predicate, {Object? arguments, bool forRoot = false}) {
          final isFoundedPages = _pages.where((page) => predicate(_CustomRoute(page)));
          popUntil(predicate);
          if (isFoundedPages.isEmpty) {
            return pushReplacementNamed<T, Object?>(newRouteName, arguments: arguments, forRoot: forRoot);
          } else {
            return pushNamed<T>(newRouteName, arguments: arguments, forRoot: forRoot);
          }
        }
      */
      /* final pages = navigatorState.widget.pages;
      final previousPage = pages[pages.length > 1 ? pages.length - 2 : 0].name;
      if (previousPage == quizRoute) {
        navigatorState.popUntil(ModalRoute.withName(quizRoute));
      } else {
        navigatorState.pushNamedAndRemoveUntil(quizRoute, (route) => false);
      } */
      if (Navegacao.paginaAnterior(context) != null) {
        Navigator.of(context).pop();
      } else {
        Navegacao.abrirPagina(context, RotaPagina.quiz);
      }
      //navigatorState.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Teste()), (route) => false);
    }
  }
}

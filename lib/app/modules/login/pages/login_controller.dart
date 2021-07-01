import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../shared/repositories/firebase/auth_repository.dart';
import '../../perfil/models/userapp.dart';
import '../../perfil/perfil_module.dart';
import '../../quiz/quiz_module.dart';
import '../utils/assets_login.dart';

part 'login_controller.g.dart';

///Usado para indicar o método de login selecionado pelo usuário.
enum Login { google, anonymous, none }

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final UserApp user;

  _LoginControllerBase(this.user);

  ///Indica o método de login escolhido pelo usuário.
  @observable
  Login selectedMethod = Login.none;

  ///Atibui [metono] a [selectedMethod].
  @action
  void _setSelectedMethod(Login metodo) {
    selectedMethod = metodo;
  }

  ///Se `true`, indica que o login está em andamento.
  @observable
  bool loading = false;

  ///Atibui [valor] a [loading].
  @action
  void _setLoading(bool valor) {
    loading = valor;
  }

  ///Autenticar com a conta do Google.
  ///Retorna true se o processo for bem sucedido.
  Future<bool> onTapLoginWithGoogle() async {
    _setSelectedMethod(Login.google);
    _setLoading(true);

    final autenticado = await user.signInWithGoogle();
    if (autenticado) {
      Modular.to.pushNamedAndRemoveUntil(
          PerfilModule.kAbsoluteRoutePerfilPage, (_) => false);
    }

    _setLoading(false);
    _setSelectedMethod(Login.none);

    return autenticado;
  }

  ///Autenticar anonimamente.
  ///Retorna true se o processo for bem sucedido.
  Future<bool> onTapLoginAnonymously() async {
    _setSelectedMethod(Login.anonymous);
    _setLoading(true);

    bool autenticado;
    try {
      autenticado = await user.signInAnonymously();
    } on MyExceptionAuthRepository catch (_) {
      autenticado = false;
    }
    if (autenticado)
      Modular.to.pushReplacementNamed(QuizModule.kAbsoluteRouteQuizPage);

    _setLoading(false);
    _setSelectedMethod(Login.none);

    return autenticado;
  }

  ///Retorna o caminho relativo para o logo do botão para conectar-se com a conta Google.
  String get assetPathIconGoogle => LoginAssets.kGoogleLogo;
}

import 'package:clubedematematica/app/modules/perfil/models/userapp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../perfil/utils/rotas_perfil.dart';
import '../../quiz/shared/utils/rotas_quiz.dart';
import '../../../shared/repositories/firebase/auth_repository.dart';

part 'login_controller.g.dart';

///Usado para indicar o método de login selecionado pelo usuário.
enum Login { google, anonymous, none }

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final AuthRepository auth;
  final UserApp user;

  _LoginControllerBase(
    this.auth,
    this.user,
  );

  ///Indica o método de login escolhido pelo usuário.
  @observable
  Login selectedMethod = Login.none;

  ///Atibui [metono] a [selectedMethod].
  @action
  void _setSelectedMethod(Login metodo) {
    assert(metodo != null);
    selectedMethod = metodo;
  }

  ///Se `true`, indica que o login está em andamento.
  @observable
  bool loading = false;

  ///Atibui [valor] a [loading].
  @action
  void _setLoading(bool valor) {
    assert(valor != null);
    loading = valor;
  }

  ///Autenticar com a conta do Google.
  ///Retorna true se o processo for bem sucedido.
  Future<bool> onTapLoginWithGoogle() async {
    _setSelectedMethod(Login.google);
    _setLoading(true);

    final autenticado = await auth.signInWithGoogle();
    user
      ..name = auth.currentUserName
      ..email = auth.currentUserEmail
      ..urlAvatar = auth.currentUserAvatarUrl;
    if (autenticado) Modular.to.pushNamed(ROTA_PAGINA_PERFIL_PATH);

    _setLoading(false);
    _setSelectedMethod(Login.none);

    return autenticado;
  }

  ///Autenticar anonimamente.
  ///Retorna true se o processo for bem sucedido.
  Future<bool> onTapLoginAnonymously() async {
    _setSelectedMethod(Login.anonymous);
    _setLoading(true);

    final autenticado = await auth.signInAnonymously();
    if (autenticado) Modular.to.pushReplacementNamed(ROTA_PAGINA_QUIZ_PATH);

    _setLoading(false);
    _setSelectedMethod(Login.none);

    return autenticado;
  }

  ///Retorna o caminho relativo para o logo do botão para conectar-se com a conta Google.
  String get assetPathIconGoogle =>
      "lib/app/modules/login/assets/google_logo.png";

  ///Retorna `true` se houver um usuário amônimo conectado.
  //bool get loggedAnonymously => auth.loggedAnonymously;

  ///Retorna `true` se houver um usuário conectado.
  //bool get logged => auth.logged;
}

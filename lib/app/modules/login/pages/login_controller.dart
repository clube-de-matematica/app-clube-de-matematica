import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import '../../../navigation.dart';
import '../../../services/conectividade.dart';
import '../../../shared/repositories/interface_auth_repository.dart';
import '../utils/assets_login.dart';

part 'login_controller.g.dart';

/// Usado para indicar o método de login selecionado pelo usuário.
enum Login { google, anonymous, none }

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final IAuthRepository auth;

  _LoginControllerBase(this.auth);

  /// Indica o método de login escolhido pelo usuário.
  @observable
  Login selectedMethod = Login.none;

  /// Atibui [metodo] a [selectedMethod].
  @action
  void _setSelectedMethod(Login metodo) {
    selectedMethod = metodo;
  }

  /// Se `true`, indica que o login está em andamento.
  @observable
  bool isLoading = false;

  /// Atibui [valor] a [isLoading].
  @action
  void _setIsLoading(bool valor) {
    isLoading = valor;
  }

  /// {@macro Conectividade.verificar}
  Future<bool> get conectadoInternete => Conectividade.instancia.verificar();

  /// Autenticar com a conta do Google.
  Future<StatusSignIn> onTapLoginWithGoogle() async {
    _setSelectedMethod(Login.google);
    _setIsLoading(true);
    StatusSignIn result = await auth.signInWithGoogle();
    _setIsLoading(false);
    _setSelectedMethod(Login.none);
    return result;
  }

  /// Abrir a página de perfil;
  void showPerfilPage(BuildContext context) {
    if (auth.logged) {
      // Para evitar chamar `pop` de dentro de uma função `pop`, precisamos adiar a chamada para
      // `pop` para depois da conclusão do `pop` em execução.
      // Para isso pode-se apenas usar um `Future` com atraso zero, o que fará com que o DART
      // programe a chamada o mais rápido possível assim que a pilha de chamadas atual retornar
      // ao loop de eventos.
      /* Future.delayed(Duration.zero, () {
        Modular.to.pushNamedAndRemoveUntil(
            PerfilModule.kAbsoluteRoutePerfilPage, (_) => false);
      }); */
      Navegacao.abrirPagina(context, RotaPagina.perfil);
    }
  }

  /// Conectar anonimamente.
  /// Retorna true se o processo for bem sucedido.
  Future<bool> onTapConnectAnonymously(BuildContext context) async {
    _setSelectedMethod(Login.anonymous);
    _setIsLoading(true);
    bool result;
    try {
      result = await auth.signInAnonymously();
    } on MyExceptionAuthRepository catch (_) {
      result = false;
    }
    if (result) {
      //Modular.to.pushReplacementNamed(QuizModule.kAbsoluteRouteQuizPage);
      Navegacao.abrirPagina(context, RotaPagina.quiz);
    }
    _setIsLoading(false);
    _setSelectedMethod(Login.none);
    return result;
  }

  /// Retorna o caminho relativo para o logo do botão para conectar-se com a conta Google.
  String get assetPathIconGoogle => LoginAssets.kGoogleLogo;
}

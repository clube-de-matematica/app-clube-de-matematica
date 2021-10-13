import 'package:flutter_modular/flutter_modular.dart';

import '../../modules/perfil/models/userapp.dart';
import '../models/debug.dart';
import '../models/exceptions/my_exception.dart';

/// Estado da solicitação de login.
enum StatusSignIn {
  /// Solicitação de autenticação cancelada pelo usuário.
  canceled,

  /// Houve um erro na solicitação de autenticação.
  error,

  /// Solicitação de autenticação em andamento.
  inProgress,

  /// Nenhuma solicitação de autenticação em andamento.
  none,

  /// Solicitação de autenticação concluída com sucesso.
  success,

  /// A solicitação de autenticação ultrapassou o tempo limite.
  timeout,
}

/// Gerencia processos de autenticação com o Firebase Auth.
abstract class IAuthRepository implements Disposable {
  static const _className = 'IAuthRepository';

  /// Usuário do aplicativo.
  UserApp get user;

  /// Stream que reporna as alterações no estado de autencicação;
  Stream<StatusSignIn> get status;

  /// Retorna o nome do usuário atual.
  String? get currentUserName;

  /// Retorna o Email do usuário atual.
  String? get currentUserEmail;

  /// Retorna a URL da foto do usuário atual.
  String? get currentUserAvatarUrl;

  /// Retorna `true` se houver um usuário conectado (anônimo ou logado).
  //bool get connected;

  /// Retorna `true` se houver um usuário amônimo conectado.
  bool get isAnonymous;

  /// Retorna `true` se houver um usuário logado.
  bool get logged;

  /// Cria um usuário anônimo de forma assincrona.
  /// Se já houver um usuário anônimo conectado, nada será feito, mas retorna `true`.
  /// Se houver qualquer outro usuário conectado, esse usuário será desconectado.
  /// Retorna `true` se o processo for bem sucedido.
  Future<bool> signInAnonymously();

  /// Solicitar login.
  /// Se não for nulo, [dataSession] será usado para iniciar a sessão.
  Future<StatusSignIn> signIn([String? dataSession]);

  /// Solicitar login com uma cota Google.
  Future<StatusSignIn> signInWithGoogle([bool replaceUser = false]);

  /// Desconecta o usuário em [_googleSignIn] (definindo `_googleSignIn.currentUser` para `null`).
  /// Também desconecta o usuário em [_auth].
  Future<void> signOut();

  /// Lançará uma exceção se não houver um usuário conectado.
  void checkAuthentication(String originClass, String originField);

  @override
  void dispose();
}

/// Métodos para as classes que implementam [IAuthRepository].
mixin MixinAuthRepository on IAuthRepository {
  /// Lançará uma exceção se não houver um usuário conectado.
  @override
  void checkAuthentication(String originClass, String originField) {
    assert(Debug.print("[INFO] Verificando altenticação..."));
    if (!logged) {
      assert(Debug.print("[ERROR] Usuário não altenticado."));
      throw MyExceptionAuthRepository(
        originClass: originClass,
        originField: originField,
        type: TypeErroAuthentication.unauthenticatedUser,
      );
    }
  }
}

/// Uma enumeração para todos os tipos de erro [MyExceptionAuthRepository].
/// [unauthenticatedUser]: [_MSG_USUARIO_NAO_ALTENTICADO].
enum TypeErroAuthentication {
  unauthenticatedUser,
}

const _MSG_PADRAO_ERRO = "Erro de autenticação.";

const _MSG_USUARIO_NAO_ALTENTICADO = "Usuário não autenticado.";

class MyExceptionAuthRepository extends MyException {
  MyExceptionAuthRepository({
    String message = _MSG_PADRAO_ERRO,
    Object? error,
    String? originField,
    String? fieldDetails,
    String? causeError,
    TypeErroAuthentication? type,
    String originClass = IAuthRepository._className,
  }) : super(
          (type == null) ? _MSG_PADRAO_ERRO : _getMessage(type),
          error: error,
          originClass: originClass,
          originField: originField,
          fieldDetails: fieldDetails,
          causeError: causeError,
        );

  /// Retorna a mensagem correspondente ao tipo do erro em [type].
  static String _getMessage(TypeErroAuthentication type) {
    switch (type) {
      case TypeErroAuthentication.unauthenticatedUser:
        return _MSG_USUARIO_NAO_ALTENTICADO;
    }
  }
}

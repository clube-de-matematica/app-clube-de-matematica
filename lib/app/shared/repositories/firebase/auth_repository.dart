import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/debug.dart';
import '../../models/exceptions/my_exception.dart';

/// Estado da solicitação de login.
enum StatusSignIn {
  /// Nenhuma solicitação de autenticação em andamento.
  none,

  /// Solicitação de autenticação em andamento.
  inProgress,

  /// Solicitação de autenticação concluída com sucesso.
  success,

  /// Solicitação de autenticação cancelada pelo usuário.
  canceled,

  /// Houve um erro na solicitação de autenticação.
  error,
}

///Gerencia processos de autenticação com o Firebase Auth.
class AuthRepository {
  static const _className = "AuthRepository";
  final FirebaseAuth _auth;

  ///AINDA É PRECISO DEFINIR OS ESCOPOS DO OAUTH.
  final _googleSignIn = GoogleSignIn();

  AuthRepository(FirebaseAuth auth) : _auth = auth {
    /* try {
      getUserAnonymous();
    } on MyExceptionAuthentication catch (e) {
      print(e.toString());
    } */
    //if (!loggedAnonymously) signInAnonymously();
  }

  ///Retorna o usuário atual.
  User? get currentUser => _auth.currentUser;

  ///Retorna o nome do usuário atual.
  String? get currentUserName => currentUser?.displayName;

  ///Retorna o Email do usuário atual.
  String? get currentUserEmail => currentUser?.email;

  ///Retorna a URL da foto do usuário atual.
  String? get currentUserAvatarUrl => currentUser?.photoURL;

  ///Retorna `true` se houver um usuário conectado (anônimo ou logado).
  bool get connected => currentUser != null;

  ///Retorna `true` se houver um usuário amônimo conectado.
  bool get isAnonymous => currentUser?.isAnonymous ?? false;

  ///Retorna `true` se houver um usuário logado.
  bool get logged => !(currentUser?.isAnonymous ?? true);

  ///Cria um usuário anônimo de forma assincrona.
  ///Se já houver um usuário anônimo conectado, nada será feito, mas retorna `true`.
  ///Se houver qualquer outro usuário conectado, esse usuário será desconectado.
  ///Retorna `true` se o processo for bem sucedido.
  Future<bool> signInAnonymously() async {
    try {
      if (isAnonymous) return true;
      if (logged) _googleSignIn.signOut();
      final User? user = (await _auth.signInAnonymously()).user;

      if (user == null) return false;

      assert(user.isAnonymous);
      assert(user.uid == currentUser?.uid);

      return user.uid == currentUser?.uid;
    } on FirebaseAuthException catch (error) {
      throw MyExceptionAuthRepository(
        error: error,
        originField: "signInAnonymously()",
      );
    }
  }

  ///Solicitar login com uma cota Google.
  Future<StatusSignIn> signInWithGoogle([bool replaceUser = false]) async {
    //await Future.delayed(Duration(seconds: 20));
    late final AuthCredential credential;
    try {
      if (replaceUser && logged) signOut();

      //Abrir o pop-up da UI do sistema solicitando uma conta do Google.
      //O processo de autenticação é disparado apenas se não houver nenhum usuário conectado
      //no momento (ou seja, quando _googleSignIn.currentUser == null), caso contrário,
      //_googleSignIn.signIn() retorna um Future que resolve para a mesma instância do usuário.
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      //Se a interface de login for abortada.
      if (googleSignInAccount == null) return StatusSignIn.canceled;

      //Dados de autenticação da conta.
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //Criar uma credencial do Firebase Auth com os dados de autenticação.
      credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
    } on PlatformException catch (er) {
      switch (er.code) {
        //Quando ocorre um erro de rede.
        case GoogleSignIn.kNetworkError:
          {
            assert(Debug.printBetweenLine(
                "GoogleSignIn.kNetworkError em AuthRepository.signInWithGoogle"));
            return StatusSignIn.error;
          }

        //Quando ocorre um erro desconhecido.
        case GoogleSignIn.kSignInFailedError:
          {
            assert(Debug.printBetweenLine(
                "GoogleSignIn.kSignInFailedError em AuthRepository.signInWithGoogle"));
            return StatusSignIn.error;
          }

        //Quando a interface de login for abortada.
        //Este erro já é tratado dentro de PlatformException.signIn(), ocasião em que
        //retorna null.
        case GoogleSignIn.kSignInCanceledError:
          {
            assert(Debug.printBetweenLine(
                "GoogleSignIn.kSignInCanceledError em AuthRepository.signInWithGoogle"));
            return StatusSignIn.canceled;
          }

        //Quando não há usuário autenticado.
        //Este erro pode ocorrer em PlatformException.signInSilently().
        case GoogleSignIn.kSignInRequiredError:
          {
            assert(Debug.printBetweenLine(
                "GoogleSignIn.kSignInRequiredError em AuthRepository.signInWithGoogle"));
            return StatusSignIn.error;
          }

        default:
          rethrow;
      }
    }

    late final UserCredential authResult;
    late final User? user;
    try {
      //Solicitar a autenticação para o Firebase Auth.
      authResult = await _auth.signInWithCredential(credential);

      //Usuário autenticado.
      user = authResult.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
      } else if (e.code == 'invalid-credential') {
        // handle the error here
      } else {
        rethrow;
      }
    } catch (_) {
      rethrow;
    }
    if (user == null) return StatusSignIn.error;

    assert(!user.isAnonymous);
    assert(user.uid == currentUser?.uid);

    if (user.uid == currentUser?.uid)
      return StatusSignIn.success;
    else
      return StatusSignIn.error;
  }

  ///Desconecta o usuário em [_googleSignIn] (definindo `_googleSignIn.currentUser` para `null`).
  ///Também desconecta o usuário em [_auth].
  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _signOut(),
    ]);
  }

  ///Desconecta o usuário em [_googleSignIn] (definindo `_googleSignIn._currentUser = null`)
  ///e revoga a autenticação anterior. Também desconecta o usuário em [_auth].
  Future<void> disconnect() async {
    await Future.wait([
      _googleSignIn.disconnect(),
      _signOut(),
    ]);
  }

  ///Desconecta o usuário em [_auth].
  Future<void> _signOut() async {
    await _auth.signOut();
  }
}

///Uma enumeração para todos os tipos de erro [MyExceptionAuthRepository].
///[unauthenticatedUser]: [_MSG_USUARIO_NAO_ALTENTICADO].
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
    String originClass = AuthRepository._className,
  }) : super(
          (type == null) ? _MSG_PADRAO_ERRO : _getMessage(type),
          error: error,
          originClass: originClass,
          originField: originField,
          fieldDetails: fieldDetails,
          causeError: causeError,
        );

  ///Retorna a mensagem correspondente ao tipo do erro em [type].
  static String _getMessage(TypeErroAuthentication type) {
    switch (type) {
      case TypeErroAuthentication.unauthenticatedUser:
        return _MSG_USUARIO_NAO_ALTENTICADO;
    }
  }
}

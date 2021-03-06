import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:developer' as dev;

import '../../models/exceptions/my_exception.dart';

///Gerencia processos de autenticação com o Firebase Auth.
class AuthRepository {
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
  User get currentUser => _auth.currentUser;

  ///Retorna o nome do usuário atual.
  String get currentUserName => currentUser.displayName;

  ///Retorna o Email do usuário atual.
  String get currentUserEmail => currentUser.email;

  ///Retorna a URL da foto do usuário atual.
  String get currentUserAvatarUrl => currentUser.photoURL;

  ///Cria um usuário anônimo de forma assincrona.
  ///Se já houver um usuário anônimo conectado, esse usuário será retornado.
  ///Se houver qualquer outro usuário conectado, esse usuário será desconectado.
  ///Retorna `true` se o processo for bem sucedido.
  Future<bool> signInAnonymously() async {
    try {
      if (logged) _auth.signOut();
      final user = (await _auth.signInAnonymously()).user;

      assert(user.isAnonymous);
      assert(await user.getIdToken() != null);
      assert(user.uid == currentUser.uid);

      return user.uid == currentUser.uid;
    } on FirebaseAuthException catch (error) {
      throw MyExceptionAuthRepository(error);
    }
  }

  ///Solicitar login com uma cota Google.
  ///Se houver qualquer outro usuário conectado, esse usuário será desconectado.
  ///Retorna `true` se o processo for bem sucedido.
  Future<bool> signInWithGoogle() async {
//dev.debugger();
//await Future.delayed(Duration(seconds: 20));
    try {
      ///Abrir o pop-up da UI do sistema solicitando uma conta do Google.
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();

      ///Dados de autenticação da conta.
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      ///Criar uma credencial do Firebase Auth com os dados de autenticação.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      ///Solicitar a autenticação para o Firebase Auth.
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      ///Usuário autenticado.
      final User user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      assert(user.uid == currentUser.uid);

      return user.uid == currentUser.uid;
    } on FirebaseAuthException catch (error) {
      throw MyExceptionAuthRepository(error);
    }
  }

  ///Fazer logout da conta Google.
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  ///Retorna `true` se houver um usuário amônimo conectado.
  bool get loggedAnonymously => logged && _auth.currentUser.isAnonymous;

  ///Retorna `true` se houver um usuário conectado.
  bool get logged => _auth.currentUser != null;
}

///Uma enumeração para todos os tipos de erro [MyExceptionAuthRepository].
///[unauthenticatedUser]: [_MSG_USUARIO_NAO_ALTENTICADO].
enum TipoErroAuthentication {
  unauthenticatedUser,
}

const _MSG_USUARIO_NAO_ALTENTICADO = "Usuário não autenticado.";

class MyExceptionAuthRepository extends MyException {
  MyExceptionAuthRepository([Exception error, String detalhes])
      : super(_MSG_USUARIO_NAO_ALTENTICADO, error, detalhes);

  final TipoErroAuthentication type =
      TipoErroAuthentication.unauthenticatedUser;

  @override
  String toString() {
    return "MyExceptionAuthRepository (${super.toString()})";
  }
}

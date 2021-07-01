import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/exceptions/my_exception.dart';

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
  ///Retorna `true` se o processo for bem sucedido.
  Future<bool> signInWithGoogle([bool replaceUser = false]) async {
    //await Future.delayed(Duration(seconds: 20));
    try {
      if (replaceUser && logged) signOut();

      //Abrir o pop-up da UI do sistema solicitando uma conta do Google.
      //O processo de autenticação é disparado apenas se não houver nenhum usuário conectado
      //no momento (ou seja, quando _googleSignIn.currentUser == null), caso contrário,
      //_googleSignIn.signIn() retorna um Future que resolve para a mesma instância do usuário.
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) return false;

      //Dados de autenticação da conta.
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //Criar uma credencial do Firebase Auth com os dados de autenticação.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      //Solicitar a autenticação para o Firebase Auth.
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      //Usuário autenticado.
      final User? user = authResult.user;
      if (user == null) return false;

      assert(!user.isAnonymous);
      assert(user.uid == currentUser?.uid);

      return user.uid == currentUser?.uid;
    } on FirebaseAuthException catch (error) {
      throw MyExceptionAuthRepository(
        error: error,
        originField: "signInWithGoogle()",
      );
    }
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

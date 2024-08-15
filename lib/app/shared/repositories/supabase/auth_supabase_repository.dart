import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../modules/perfil/models/userapp.dart';
import '../../models/debug.dart';
import '../interface_auth_repository.dart';

/// Gerencia processos de autenticação com o Supabase Auth.
class AuthSupabaseRepository extends IAuthRepository with MixinAuthRepository {
  final GoTrueClient _auth;
  late final StreamSubscription _subscription;

  AuthSupabaseRepository(Supabase supabase) : _auth = supabase.client.auth {
    _subscription = supabase.client.auth.onAuthStateChange.listen(
      (data) {
        final AuthChangeEvent event = data.event;
        switch (event) {
          case AuthChangeEvent.initialSession:
            _authStateReport(AuthChangeState.initialSession);
          case AuthChangeEvent.passwordRecovery:
            _authStateReport(AuthChangeState.passwordRecovery);
            break;
          case AuthChangeEvent.signedIn:
            _authStateReport(AuthChangeState.signedIn);
            break;
          case AuthChangeEvent.signedOut:
            _authStateReport(AuthChangeState.signedOut);
            break;
          case AuthChangeEvent.tokenRefreshed:
            _authStateReport(AuthChangeState.tokenRefreshed);
            break;
          case AuthChangeEvent.userUpdated:
            _authStateReport(AuthChangeState.userUpdated);
            break;
          case AuthChangeEvent.userDeleted:
            _authStateReport(AuthChangeState.userDeleted);
            break;
          case AuthChangeEvent.mfaChallengeVerified:
            break;
        }
        setUserApp();
      },
      onError: (error, stack) {
        // TODO:
      },
    );
  }

  /// Atribui os dados do usuário do supabase para o usuário do aplicativo.
  static void setUserApp() {
    final user = Supabase.instance.client.auth.currentUser;
    final userApp = UserApp.instance;
    if (user == null || user.email == null) {
      userApp
        ..email = null
        ..id = null
        ..name = null
        ..urlAvatar = null;
    } else {
      userApp
        ..email = user.email
        ..id = user.appMetadata['id_usuario']
        ..name = user.userMetadata?['nome'] ?? user.userMetadata?['full_name']
        ..urlAvatar = user.userMetadata?['avatar_url'];
    }
  }

  SignInChangeState _currenteSignInState = SignInChangeState.none;

  /// Controle para o stream de alterações durante o processo de autenticação.
  late final StreamController<SignInChangeState> _signInStateController =
      StreamController<SignInChangeState>.broadcast()
        ..stream.listen((state) => _currenteSignInState = state);

  AuthChangeState? _currenteAuthState;

  /// Controle para o stream de alterações no estado de autenticação.
  late final StreamController<AuthChangeState> _authStateController =
      StreamController<AuthChangeState>.broadcast()
        ..stream.listen((state) => _currenteAuthState = state);

  /// Se [estado] é diferente do último evento de [signInState], adiciona-o ao fluxo.
  /// Retorna [estado].
  SignInChangeState _signInStateReport(SignInChangeState estado) {
    bool reportar;
    try {
      reportar = estado != _currenteSignInState;
    } catch (_) {
      reportar = true;
    }
    if (reportar && !_signInStateController.isClosed) {
      _signInStateController.add(estado);
    }
    return estado;
  }

  /// Se [estado] é diferente do último evento de [authState], adiciona-o ao fluxo.
  /// Retorna [estado].
  AuthChangeState _authStateReport(AuthChangeState estado) {
    bool reportar;
    try {
      reportar = estado != _currenteAuthState;
    } catch (_) {
      reportar = true;
    }
    if (reportar && !_authStateController.isClosed) {
      _authStateController.add(estado);
    }
    return estado;
  }

  @override
  Stream<SignInChangeState> get signInState => _signInStateController.stream;

  @override
  Stream<AuthChangeState> get authState => _authStateController.stream;

  /// Usuário do aplicativo.
  final _user = UserApp.instance;

  @override
  UserApp get user => _user;

  /// Retorna o usuário atual.
  User? get _currentUser => _auth.currentUser;

  @override
  String? get currentUserName => _currentUser?.userMetadata?['full_name'];

  @override
  String? get currentUserEmail => _currentUser?.email;

  @override
  String? get currentUserAvatarUrl => _currentUser?.userMetadata?['avatar_url'];

  /// Retorna `true` se não houver um usuário conectado.
  @override
  bool get isAnonymous => !logged;

  /// Retorna `true` se houver um usuário conectado.
  @override
  bool get logged => _currentUser != null;

  /// TODO: O [Supabase] já oferece suporte a usuário anônimo, esse código pode ser atualizado para não disponibilizar mais a `anon key`.
  @override
  Future<bool> signInAnonymously() async {
    if (isAnonymous) return true;
    if (logged) await signOut();
    return isAnonymous;
  }

  @override
  Future<SignInChangeState> signIn([String? dataSession]) async {
    _signInStateReport(SignInChangeState.inProgress);
    var redirectUrl = dataSession ?? '';
    Session session;

    if (kIsWeb) {
      throw UnimplementedError();
    }

    try {
      final uri = Uri.parse(redirectUrl);
      final resp = await _auth.getSessionFromUrl(uri);
      session = resp.session;
    } catch (e) {
      assert(Debug.print(e.toString()));
      return _signInStateReport(SignInChangeState.error);
    }

    assert(!session.isExpired);
    if (session.isExpired) {
      return _signInStateReport(SignInChangeState.error);
    } else {
      return _signInStateReport(SignInChangeState.success);
    }
  }

  @override
  Future<SignInChangeState> signInWithGoogle([bool replaceUser = false]) async {
    if (kIsWeb) {
      throw UnimplementedError();
    }

    try {
      if (replaceUser && logged) await signOut();
      final resp = await _googleSignIn();
      if (resp.session == null || resp.session!.isExpired) {
        return _signInStateReport(SignInChangeState.error);
      } else {
        return _signInStateReport(SignInChangeState.success);
      }
    } catch (e) {
      assert(Debug.print(e.toString()));
      return _signInStateReport(SignInChangeState.error);
    }
  }

  Future<AuthResponse> _googleSignIn() async {
    /// TODO: Apesar de serem esses os escopos indicados na documentação para a API OAuth-2, o uso deles está gerando erro no login.
    const List<String> scopes = <String>[
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'OpenID',
    ];

    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '760657363926-g7qcb8rk6inks6158a08qi5oi1pacac2.apps.googleusercontent.com';

    /// Android Client ID that you registered with Google Cloud.
    const androidClientId =
        //'760657363926-kvrkooft2qbrail3uskmh77r354b5ev4.apps.googleusercontent.com'; 
        //'760657363926-p8vkfr63chd5nv8iu7edrib43094caah.apps.googleusercontent.com';
        //'760657363926-7t0el18h5keqemvr76eju8mtkbhnki3t.apps.googleusercontent.com';
        '760657363926-1gt52lcdk9n2jp4heo7aj2evs9srldgp.apps.googleusercontent.com';

    /// iOS Client ID that you registered with Google Cloud.
    //const iosClientId = '';

    // O login do Google no Android funcionará sem fornecer o ID do cliente Android registrado no Google Cloud

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: androidClientId,
      serverClientId: webClientId,
      //scopes: scopes,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final accessToken = googleAuth?.accessToken;
    final idToken = googleAuth?.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return _auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Future<bool> updateUserName(String name) async {
    if (name == UserApp.instance.name) return true;
    UserResponse response;
    try {
      // Se bem sucedido, onAuthStateChange será chamado.
      response = await _auth.updateUser(UserAttributes(data: {'nome': name}));
    } catch (e) {
      assert(Debug.print(e.toString()));
      return false;
    }
    return response.user?.userMetadata?['nome'] == name;
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
    ]);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _signInStateController.close();
    _authStateController.close();
  }
}

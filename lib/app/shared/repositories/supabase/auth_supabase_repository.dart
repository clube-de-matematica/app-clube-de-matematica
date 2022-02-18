import 'dart:async';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../configure_supabase.dart';
import '../../../modules/perfil/models/userapp.dart';
import '../../models/debug.dart';
import '../../utils/constantes.dart';
import '../interface_auth_repository.dart';

/// Gerencia processos de autenticação com o Supabase Auth.
class AuthSupabaseRepository extends IAuthRepository with MixinAuthRepository {
  final GoTrueClient _auth;
  final GotrueSubscription _subscription;

  AuthSupabaseRepository(Supabase supabase)
      : _auth = supabase.client.auth,
        _subscription = supabase.client.auth.onAuthStateChange((_, __) {
          setUserApp();
        });

  /// Atribui os dados do usuário do supabase para o usuário do aplicativo.
  static void setUserApp() {
    final user = Supabase.instance.client.auth.currentUser;
    final userApp = UserApp.instance;
    if (user?.email == null) {
      userApp
        ..email = null
        ..id = null
        ..name = null
        ..urlAvatar = null;
    }
    userApp
      ..email = user?.email
      ..id = user?.appMetadata['id_usuario']
      ..name = user?.userMetadata['nome'] ?? user?.userMetadata['full_name']
      ..urlAvatar = user?.userMetadata['avatar_url'];
  }

  StatusSignIn _currenteStatus = StatusSignIn.none;

  /// Controle para o stream de alterações no estado de autenticação.
  late StreamController<StatusSignIn> _controller =
      StreamController<StatusSignIn>.broadcast()
        ..stream.listen((status) => _currenteStatus = status);

  /// Se [estado] é diferente do último evento de [status], adiciona-o ao fluxo.
  /// Retorna [estado].
  Future<StatusSignIn> _reportarEstado(StatusSignIn estado) async {
    bool reportar;
    try {
      reportar = estado != _currenteStatus;
    } catch (_) {
      reportar = true;
    }
    if (reportar) _controller.add(estado);
    return estado;
  }

  @override
  Stream<StatusSignIn> get status => _controller.stream;

  /// Usuário do aplicativo.
  final _user = UserApp.instance;

  @override
  UserApp get user => _user;

  /// Retorna o usuário atual.
  User? get _currentUser => _auth.currentUser;

  @override
  String? get currentUserName => _currentUser?.userMetadata['full_name'];

  @override
  String? get currentUserEmail => _currentUser?.email;

  @override
  String? get currentUserAvatarUrl => _currentUser?.userMetadata['avatar_url'];

  /// Retorna `true` se não houver um usuário conectado.
  @override
  bool get isAnonymous => !logged;

  /// Retorna `true` se houver um usuário conectado.
  @override
  bool get logged => _currentUser != null;

  /// TODO: O [Supabase] ainda não oferece suporte ao registro de usuário anônimo, em vez
  /// disso ele disponibiliza a `anon key`.
  @override
  Future<bool> signInAnonymously() async {
    if (isAnonymous) return true;
    if (logged) await signOut();
    return isAnonymous;
  }

  @override
  Future<StatusSignIn> signIn([String? dataSession]) async {
    _reportarEstado(StatusSignIn.inProgress);
    var redirectUrl = dataSession ?? '';
    GotrueSessionResponse session;
    try {
      final uri = Uri.parse(redirectUrl);
      session = await _auth.getSessionFromUrl(uri);
    } catch (e) {
      assert(Debug.print(e.toString()));
      return _reportarEstado(StatusSignIn.error);
    }

    //TODO: notificar o usuário.
    if (session.error != null) {
      if (session.error!.message.startsWith(r'<!DOCTYPE html>')) {
        return _reportarEstado(StatusSignIn.error);
      }
    }

    assert(session.user != null && session.error == null);
    if (session.user == null || session.error != null) {
      return _reportarEstado(StatusSignIn.error);
    } else {
      return _reportarEstado(StatusSignIn.success);
    }
  }

  @override
  Future<StatusSignIn> signInWithGoogle([bool replaceUser = false]) async {
    GotrueSessionResponse session;

    try {
      if (replaceUser && logged) await signOut();
      _reportarEstado(StatusSignIn.inProgress);
      session = await _auth.signIn(
        provider: Provider.google,
        options: AuthOptions(redirectTo: authRedirectUri),
      );
    } catch (e) {
      assert(Debug.print(e.toString()));
      return _reportarEstado(StatusSignIn.error);
    }

    final _url = Uri.tryParse(session.url.toString());

    assert(session.error == null && _url != null);
    if (session.error != null || _url == null) {
      return _reportarEstado(StatusSignIn.error);
    }

    agente() async {
      await FkUserAgent.init();
      try {
        // Se "wv" não for substituído o servidor emitirá o erro "disallowed_useragent"
        final _agente =
            FkUserAgent.webViewUserAgent?.replaceFirst('; wv)', ')');
        return '$_agente WebViewApp $APP_NOME/$APP_VERSION';
      } catch (_) {
        return null;
      }
    }

    final _agente = await agente();

    Future<FutureOr<StatusSignIn>?> requisitar() {
      return Modular.to
          .push<FutureOr<StatusSignIn>>(MaterialPageRoute(builder: (context) {
        onLoadStart(InAppWebViewController controle, Uri? url) async {
          if (url?.host == kAuthCallbackUrlHostname) {
            await controle.stopLoading();
            Navigator.pop(context, signIn(url.toString()));
          }
        }

        onLoadError(InAppWebViewController controle, Uri? __, int ___,
            String msg) async {
          if (msg.contains('ERR_INTERNET_DISCONNECTED')) {
            await controle.stopLoading();
            Navigator.pop(context, StatusSignIn.error);
          }
        }

        return Container(
          color: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: _url),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                clearCache: replaceUser,
                // Necessário para que o OAuth2 aceite a requisição.
                userAgent: _agente ?? '',
              ),
            ),
            onLoadStart: onLoadStart,
            onLoadError: onLoadError,
          ),
        );
      }));
    }

    final estado = (await requisitar()) ?? StatusSignIn.canceled;

    return _reportarEstado(await estado);
  }

  @override
  Future<bool> updateUserName(String name) async {
    if (name == UserApp.instance.name) return true;
    GotrueUserResponse response;
    try {
      // Se bem sucedido, onAuthStateChange será chamado.
      response = await _auth.update(UserAttributes(data: {'nome': name}));
      if (response.error != null) throw response.error!;
    } catch (e) {
      assert(Debug.print(e.toString()));
      return false;
    }
    return true;
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
    ]);
  }

  @override
  void dispose() {
    _subscription.data?.unsubscribe();
    _controller.close();
  }
}

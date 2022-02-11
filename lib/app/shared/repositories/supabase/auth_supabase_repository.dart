import 'dart:async';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
        ..urlAvatar = null
        ..isAnonymous = true;
    }
    userApp
      ..email = user?.email
      ..id = user?.appMetadata['id_usuario']
      ..name = user?.userMetadata['full_name']
      ..urlAvatar = user?.userMetadata['avatar_url']
      ..isAnonymous = false;
  }

  /// Controle para o stream de alterações no estado de autenticação.
  StreamController<StatusSignIn> _controller =
      StreamController<StatusSignIn>.broadcast();

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
    _controller.add(StatusSignIn.inProgress);
    var redirectUrl = dataSession ?? '';
    var uri = Uri.parse(redirectUrl);
    GotrueSessionResponse session;
    try {
      session = await _auth.getSessionFromUrl(uri);
    } catch (e) {
      assert(Debug.print(e.toString()));
      rethrow;
    }

    //TODO: notificar o usuário.
    if (session.error != null) {
      if (session.error!.message.startsWith(r'<!DOCTYPE html>')) {
        _controller.add(StatusSignIn.error);
        return StatusSignIn.error;
      }
    }

    assert(session.user != null && session.error == null);
    if (session.user == null || session.error != null) {
      _controller.add(StatusSignIn.error);
      return StatusSignIn.error;
    } else {
      _controller.add(StatusSignIn.success);
      return StatusSignIn.success;
    }
  }

  @override
  Future<StatusSignIn> signInWithGoogle([bool replaceUser = false]) async {
    final _return = _listen();
    GotrueSessionResponse session;
    try {
      if (replaceUser && logged) await signOut();
      _controller.add(StatusSignIn.inProgress);
      session = await _auth.signIn(
        provider: Provider.google,
        options: AuthOptions(redirectTo: authRedirectUri),
      );
    } catch (e) {
      assert(Debug.print(e.toString()));
      _controller.add(StatusSignIn.error);
      return _return;
    }

    final _url = Uri.tryParse(session.url.toString());

    assert(session.error == null && _url != null);
    if (session.error != null || _url == null) {
      _controller.add(StatusSignIn.error);
      return _return;
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

    Modular.to.push(MaterialPageRoute(builder: (context) {
      return Container(
        color: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: _url),
          onLoadStart: (controle, url) async {
            if (url?.host == kAuthCallbackUrlHostname) {
              try {
                await launch(url.toString(), webOnlyWindowName: '_self');
              } catch (error, stack) {
                assert(Debug.print(
                  'Erro ao abrir o URL em AuthSupabaseRepository.signInWithGoogle(). \n'
                  'Erro: ${error.toString()}.\n'
                  'Pilha: ${stack.toString()}.',
                ));
                _controller.add(StatusSignIn.error);
              }
              Navigator.pop(context);
            }
          },
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              clearCache: replaceUser,
              // Necessário para que o OAuth2 aceite a requisição.
              userAgent: _agente ?? '',
            ),
          ),
        ),
      );
    }));

    return _return;
  }

  /// Retorna um futuro que será concluido com a próxima emissão de [StatusSignIn.success],
  /// [StatusSignIn.canceled] ou [StatusSignIn.error] por [status], ou após o tempo limite
  /// [duration]. Neste caso, o futuro será concluído com [StatusSignIn.timeout].
  Future<StatusSignIn> _listen(
      [Duration duration = const Duration(seconds: 30)]) {
    //TODO: verificar duração
    final completer = Completer<StatusSignIn>();
    final listen = status.listen((_) {});
    listen.onData((status) {
      final cases = [
        StatusSignIn.success,
        StatusSignIn.canceled,
        StatusSignIn.error
      ];
      if (cases.contains(status)) {
        if (!completer.isCompleted) completer.complete(status);
        listen.cancel();
      }
    });
    listen.onError((error, stack) {
      assert(Debug.print(
        'Erro: ${error.toString()}.\n'
        'Pilha: ${stack.toString()}.',
      ));
      if (!completer.isCompleted) completer.complete(StatusSignIn.error);
      listen.cancel();
    });
    return completer.future.timeout(
      duration,
      onTimeout: () {
        listen.cancel();
        _controller.add(StatusSignIn.timeout);
        return StatusSignIn.timeout;
      },
    );
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

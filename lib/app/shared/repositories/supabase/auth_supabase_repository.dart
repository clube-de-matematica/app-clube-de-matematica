import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gotrue/gotrue.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../configure_supabase.dart';
import '../../../modules/perfil/models/userapp.dart';
import '../../models/debug.dart';
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
    // await Future.delayed(Duration(seconds: 20));
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
      rethrow;
    }

    assert(session.error == null && session.url != null);
    if (session.error != null || session.url == null) {
      _controller.add(StatusSignIn.error);
    }

    launch(session.url!, webOnlyWindowName: '_self').catchError((error, stack) {
      assert(Debug.print(
        'Erro ao abrir o URL em AuthSupabaseRepository.signInWithGoogle(). \n'
        'Erro: ${error.toString()}.\n'
        'Pilha: ${stack.toString()}.',
      ));
    });

    return _return;
  }

/* 
  Future<StatusSignIn> signInWithWebView([bool replaceUser = false]) async {
    // await Future.delayed(Duration(seconds: 20));
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
      rethrow;
    }

    assert(session.error == null && session.url != null);
    if (session.error != null || session.url == null) {
      _controller.add(StatusSignIn.error);
    }

    await Modular.to.push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: WebView(
            initialUrl: session.url,
            userAgent: 'random',
            javascriptMode: JavascriptMode.unrestricted,
            onWebResourceError: (erro) {
              debugger();
              var url = erro.failingUrl;
              if (url != null) {
                if (url.startsWith(authRedirectUri ?? 'tornar false')) {
                  //launch(url);
                }
              }
            },
          ),
        ),
      ),
    );

    return _return;
  }
 */

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

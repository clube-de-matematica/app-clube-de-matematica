/* import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'configure_supabase.dart';
import 'modules/perfil/perfil_module.dart';
import 'shared/models/debug.dart';
import 'shared/repositories/interface_auth_repository.dart';

/// Usado para garantir que [getInitialLink]/[getInitialUri] não seja chamado várias vezes.
bool _initialUriIsHandled = false;

class DeepAndAppLinks extends Disposable {
  DeepAndAppLinks() {
    _handleIncomingLinks();
    _handleInitialUri();
  }

  /// [Uri] inicial.
  // ignore: unused_field
  Uri? _initialUri;

  /// [Uri] mais recente.
  // ignore: unused_field
  Uri? _latestUri;

  // ignore: unused_field
  Object? _err;

  StreamSubscription? _sub;

  @override
  void dispose() {
    _sub?.cancel();
  }

  /// Atribui [uri] em [_latestUri].
  Future<void> setUri(Uri? uri) async {
    debugger(); //TODO
    if (uri != null) {
      final condicaoWeb = kIsWeb && uri.toString().contains(authRedirectUri.toString());
      final condicaoMovel = !kIsWeb && uri.host == kAuthCallbackUrlHostname;
      if (condicaoWeb || condicaoMovel) {
        var result =
            await Modular.get<IAuthRepository>().signIn(uri.toString());

        // Atualmente, na web, o código acima reinicia o App assim as instâncias são perdidas.
        // Por isso alguns erros ocorrem e o trecho a seguir não é executado.
        if (result == SignInChangeState.success) {
          // Para evitar chamar `pop` de dentro de uma função `pop`, precisamos adiar a chamada para
          // `pop` para depois da conclusão do `pop` em execução.
          // Para isso pode-se apenas usar um `Future` com atraso zero, o que fará com que o DART
          // programe a chamada o mais rápido possível assim que a pilha de chamadas atual retornar
          // ao loop de eventos.
          await Future.delayed(Duration.zero, () {
            if (kIsWeb) {
              Modular.to.navigate(PerfilModule.kAbsoluteRoutePerfilPage);
            }
          });
        }
      }
    }
    _latestUri = uri;
  }

  /// Lida com links de entrada - aqueles que o aplicativo receberá do sistema operacional
  /// enquanto já foi iniciado.
  void _handleIncomingLinks() async {
    if (kIsWeb) setUri(await getInitialUri());
    // Manipulará links de aplicativos enquanto o aplicativo já está iniciado - seja em
    // primeiro ou em segundo plano.
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) async {
        assert(Debug.print('Uri: $uri'));
        await setUri(uri);
        _err = null;
      }, onError: (Object err) async {
        assert(Debug.print('Erro: $err'));
        await setUri(null);
        if (err is FormatException) {
          _err = err;
        } else {
          _err = null;
        }
      });
    }
  }

  /// Lidar com o Uri inicial - aquele com o qual o aplicativo foi iniciado.
  ///
  /// **ATENÇÃO**: [getInitialLink]/[getInitialUri] deve ser manipulado SOMENTE UMA VEZ durante
  /// a vida do aplicativo, uma vez que não se destina a mudar ao longo da vida do aplicativo.
  ///
  /// Se chamado do `initState` do widget principal, leda com todas as exceções.
  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          assert(Debug.print('Sem URI inicial.'));
        } else {
          assert(Debug.print('URI inicial: $uri'));
        }
        _initialUri = uri;
      } on PlatformException {
        // As mensagens da plataforma podem falhar, mas ignoramos a exceção.
        assert(Debug.print('Falha ao obter URI inicial.'));
      } on FormatException catch (err) {
        assert(Debug.print('URI inicial malformado.'));
        _err = err;
      }
    }
  }
}

mixin AppDeepLinkingMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription? _sub;

  void startDeeplinkObserver() {
    _handleIncomingLinks();
    _handleInitialUri();
  }

  void stopDeeplinkObserver() {
    if (_sub != null) _sub?.cancel();
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (mounted && uri != null) {
          handleDeeplink(uri);
        }
      }, onError: (Object err) {
        if (!mounted) return;
        onErrorReceivingDeeplink(err.toString());
      });
    }
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  Future<void> _handleInitialUri() async {
    if (!SupabaseAuth.instance.shouldHandleInitialDeeplink()) return;

    try {
      final uri = await getInitialUri();
      if (mounted && uri != null) {
        handleDeeplink(uri);
      }
    } on PlatformException {
      // Platform messages may fail but we ignore the exception
    } on FormatException catch (err) {
      if (!mounted) return;
      onErrorReceivingDeeplink(err.message);
    }
  }

  /// Callback when deeplink receiving succeeds
  void handleDeeplink(Uri uri);

  /// Callback when deeplink receiving throw error
  void onErrorReceivingDeeplink(String message);
}

/// Interface for user authentication screen
/// It supports deeplink authentication
abstract class IAuthState<T extends StatefulWidget>
    extends AppState<T> with AppDeepLinkingMixin {
  @override
  void startAuthObserver() {
    startDeeplinkObserver();
  }

  @override
  void stopAuthObserver() {
    stopDeeplinkObserver();
  }

  @override
  Future<bool> handleDeeplink(Uri uri) async {
    if (!SupabaseAuth.instance.isAuthCallbackDeeplink(uri)) return false;

    // notify auth deeplink received
    onReceivedAuthDeeplink(uri);

    return recoverSessionFromUrl(uri);
  }

  @override
  void onErrorReceivingDeeplink(String message) {}

  late final StreamSubscription<AuthChangeEvent> _authStateListener;

  @override
  void initState() {
    _authStateListener = SupabaseAuth.instance.onAuthChange.listen((event) {
      if (event == AuthChangeEvent.signedOut) {
        onUnauthenticated();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _authStateListener.cancel();
    super.dispose();
  }

  Future<bool> recoverSessionFromUrl(Uri uri) async {
    final uriParameters = SupabaseAuth.instance.parseUriParameters(uri);
    final type = uriParameters['type'] ?? '';

    // recover session from deeplink
    final response = await Supabase.instance.client.auth.getSessionFromUrl(uri);
    if (response.error != null) {
      onErrorAuthenticating(response.error!.message);
    } else {
      if (type == 'recovery') {
        onPasswordRecovery(response.data!);
      } else {
        onAuthenticated(response.data!);
      }
    }
    return true;
  }

  /// Recover/refresh session if it's available
  /// e.g. called on a Splash screen when app starts.
  Future<bool> recoverSupabaseSession() async {
    final bool exist =
        await SupabaseAuth.instance.localStorage.hasAccessToken();
    if (!exist) {
      onUnauthenticated();
      return false;
    }

    final String? jsonStr =
        await SupabaseAuth.instance.localStorage.accessToken();
    if (jsonStr == null) {
      onUnauthenticated();
      return false;
    }

    final response =
        await Supabase.instance.client.auth.recoverSession(jsonStr);
    if (response.error != null) {
      SupabaseAuth.instance.localStorage.removePersistedSession();
      onUnauthenticated();
      return false;
    } else {
      onAuthenticated(response.data!);
      return true;
    }
  }

  /// Callback when deeplink received and is processing. Optional
  void onReceivedAuthDeeplink(Uri uri) {}

  /// Callback when user is unauthenticated
  void onUnauthenticated();

  /// Callback when user is authenticated
  void onAuthenticated(Session session);

  /// Callback when authentication deeplink is recovery password type
  void onPasswordRecovery(Session session);

  /// Callback when recovering session from authentication deeplink throws error
  void onErrorAuthenticating(String message);
}

/// Interface for screen that requires an authenticated user
abstract class AppState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    super.initState();
    startAuthObserver();
  }

  @override
  void dispose() {
    stopAuthObserver();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  /// enable auth observer
  /// e.g. on nested authentication flow, call this method on navigation push.then()
  ///
  /// ```dart
  /// Navigator.pushNamed(context, '/signUp').then((_) => startAuthObserver());
  /// ```
  void startAuthObserver();

  /// disable auth observer
  /// e.g. on nested authentication flow, call this method before navigation push
  ///
  /// ```dart
  /// stopAuthObserver();
  /// Navigator.pushNamed(context, '/signUp').then((_) =>{});
  /// ```
  void stopAuthObserver();
}
 */
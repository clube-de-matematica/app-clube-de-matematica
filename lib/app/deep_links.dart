import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:uni_links/uni_links.dart';

import 'configure_supabase.dart';
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
    if (uri != null) {
      if (uri.host == kAuthCallbackUrlHostname) {
        var result =
            await Modular.get<IAuthRepository>().signIn(uri.toString());
        if (result == StatusSignIn.success) {
          // Para evitar chamar `pop` de dentro de uma função `pop`, precisamos adiar a chamada para
          // `pop` para depois da conclusão do `pop` em execução.
          // Para isso pode-se apenas usar um `Future` com atraso zero, o que fará com que o DART
          // programe a chamada o mais rápido possível assim que a pilha de chamadas atual retornar
          // ao loop de eventos.
          await Future.delayed(Duration.zero, () {
            /* Modular.to.pushNamedAndRemoveUntil(
                PerfilModule.kAbsoluteRoutePerfilPage, (_) => false); */
          });
        }
      }
    }
    _latestUri = uri;
  }

  /// Lida com links de entrada - aqueles que o aplicativo receberá do sistema operacional
  /// enquanto já foi iniciado.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // Manipulará links de aplicativos enquanto o aplicativo já está iniciado - seja em
      // primeiro ou em segundo plano.
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
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../configure_supabase.dart';

class WebViewPage extends StatefulWidget {
  final Uri initialUrl;

  const WebViewPage(this.initialUrl, {Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => new _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  //late InAppWebViewController _webViewController;
  String url = '';
  double progress = 0;

  /// Indica se a página está sendo fechada.
  ///
  /// Usado para garantir que [setState] não seja chamado indevidamente.
  bool closing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(children: <Widget>[
          Container(
            child: progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : SizedBox(),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: widget.initialUrl),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    // Necessário para que o OAuth2 aceite a requisição.
                    userAgent: 'random',
                  ),
                ),
                //onWebViewCreated: (controller) => _webViewController = controller,
                onLoadStart: (_, url) {
                  setState(() {
                    this.url = url.toString();
                  });
                  if (url?.host == kAuthCallbackUrlHostname) {
                    // Para evitar chamar `pop` de dentro de uma função `pop`, precisamos adiar a chamada para
                    // `pop` para depois da conclusão do `pop` em execução.
                    // Para isso pode-se apenas usar um `Future` com atraso zero, o que fará com que o DART
                    // programe a chamada o mais rápido possível assim que a pilha de chamadas atual retornar
                    // ao loop de eventos.
                    Future.delayed(Duration.zero, () {
                      closing = true;
                      Navigator.of(context).pop(url);
                    });
                  }
                },
                onReceivedHttpAuthRequest: (controller, challenge) async {
                  return HttpAuthResponse(
                      action: HttpAuthResponseAction.PROCEED);
                },
                onProgressChanged: (_, progress) {
                  if (mounted)
                  //if (closing)
                    setState(() {
                      this.progress = progress / 100;
                    });
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

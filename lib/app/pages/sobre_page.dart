import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import '../shared/utils/constantes.dart';
import '../shared/widgets/botoes.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(APP_NOME)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'O Aplicativo Clube de Matemática é fruto de um trabalho desenvolvido para '
            'a conclusão do curso de mestrado do seu desenvolvedor.'
            '\n\n'
            'Lembre-se que ao utilizar este aplicativo você concorda com os Termos e Condições '
            'de uso e com a Política de Privacidade disponíveis em: '
            '\n\n',
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
          ),
          AppTextButton(
            primary: true,
            onPressed: () {
              mostrarTemos();
              /* Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return Scaffold(
                    appBar: AppBar(title: Text('Termos e Condições')),
                    body: InAppWebView(initialFile: AppAssets.kTermos),
                  );
                }),
              ); */
            },
            child: const Text('Termos e Condições'),
          ),
          AppTextButton(
            primary: true,
            onPressed: () {
              mostrarPolitica();
            },
            child: const Text('Política de Privacidade'),
          )
        ],
      ),
    );
  }
}

// Abre uma guia personalizada para a Política de Privacidade do aplicativo.
mostrarPolitica() {
  _launch('https://www.samylourenco.com/política-de-privacidade');
}

// Abre uma guia personalizada para os Termos e Condições de uso do aplicativo.
mostrarTemos() {
  _launch('https://www.samylourenco.com/termos-e-condições');
}

void _launch(String url) {
  launchUrl(
    Uri.parse(url),
    customTabsOptions: CustomTabsOptions(
      urlBarHidingEnabled: true,
      showTitle: false,
      animations: CustomTabsSystemAnimations.slideIn(),
      browser: const CustomTabsBrowserConfiguration(
        fallbackCustomTabs: [
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
        headers: {'key': 'value'},
      ),
    ),
    safariVCOptions: const SafariViewControllerOptions(
      //preferredBarTintColor: Theme.of(context).primaryColor,
      preferredControlTintColor: Colors.white,
      barCollapsingEnabled: true,
      entersReaderIfAvailable: false,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
    ),
  );
}

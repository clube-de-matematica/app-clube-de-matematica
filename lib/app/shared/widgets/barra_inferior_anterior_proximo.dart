import 'package:flutter/material.dart';

import '../../modules/quiz/shared/utils/ui_strings.dart';

/// Barra contendo os botões para avançar e voltar na lista de itens.
class BarraIferiorAteriorProximo extends BottomAppBar {
  BarraIferiorAteriorProximo({
    Key? key,
    required bool ativarVoltar,
    required bool ativarProximo,
    required VoidCallback acionarVoltar,
    required VoidCallback acionarProximo,
  }) : super(
          key: key,
          child: _Child(
            ativarVoltar: ativarVoltar,
            ativarProximo: ativarProximo,
            acionarVoltar: acionarVoltar,
            acionarProximo: acionarProximo,
          ),
        );
}

class _Child extends StatelessWidget {
  const _Child({
    Key? key,
    required this.ativarVoltar,
    required this.ativarProximo,
    required this.acionarVoltar,
    required this.acionarProximo,
  }) : super(key: key);

  final bool ativarVoltar;
  final bool ativarProximo;
  final VoidCallback acionarVoltar;
  final VoidCallback acionarProximo;

  @override
  Widget build(BuildContext context) {
    final estiloBotao = TextButton.styleFrom(
      primary: Theme.of(context).colorScheme.onSurface,
      padding: const EdgeInsets.only(right: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    );
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Estrutura para o botão de voltar.
          AnimatedOpacity(
            opacity: ativarVoltar ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: TextButton(
              style: estiloBotao,
              onPressed: ativarVoltar ? acionarVoltar : null,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.chevron_left),
                  const SizedBox(width: 4),
                  const Text(UIStrings.QUIZ_TEXTO_BOTAO_VOLTAR),
                ],
              ),
            ),
          ),

          // Estrutura para o botão de avançar.
          AnimatedOpacity(
            opacity: ativarProximo ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: TextButton(
              style: estiloBotao,
              onPressed: ativarProximo ? acionarProximo : null,
              child: Row(
                children: <Widget>[
                  const Text(UIStrings.QUIZ_TEXTO_BOTAO_AVANCAR),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

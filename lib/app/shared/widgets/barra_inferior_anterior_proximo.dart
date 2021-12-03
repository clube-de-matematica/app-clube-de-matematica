import 'package:flutter/material.dart';

import '../../modules/quiz/shared/utils/ui_strings.dart';

/// Barra contendo os botões para avançar e voltar na lista de itens.
class BarraIferiorAteriorProximo extends StatelessWidget {
  BarraIferiorAteriorProximo({
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
    final altura = 48.0;
    final duracao = const Duration(milliseconds: 300);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 0,
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Estrutura para o botão de voltar.
            Expanded(
              child: AnimatedOpacity(
                opacity: ativarVoltar ? 1 : 0.75,
                duration: duracao,
                child: MaterialButton(
                  height: altura,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  onPressed: ativarVoltar ? acionarVoltar : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.chevron_left),
                      const SizedBox(width: 4),
                      Text(UIStrings.QUIZ_TEXTO_BOTAO_VOLTAR),
                    ],
                  ),
                ),
              ),
            ),

            // Estrutura para o botão de avançar.
            Expanded(
              child: AnimatedOpacity(
                opacity: ativarProximo ? 1 : 0.75,
                duration: duracao,
                child: MaterialButton(
                  height: altura,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  onPressed: ativarProximo ? acionarProximo : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const Text(UIStrings.QUIZ_TEXTO_BOTAO_AVANCAR),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

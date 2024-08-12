import 'package:flutter/material.dart';

import '../../modules/quiz/shared/utils/ui_strings.dart';

/// Barra contendo os botões para avançar e voltar na lista de itens.
class BarraIferiorAteriorProximo extends StatelessWidget {
  const BarraIferiorAteriorProximo({
    super.key,
    required this.ativarVoltar,
    required this.ativarProximo,
    required this.acionarVoltar,
    required this.acionarProximo,
  });

  final bool ativarVoltar;
  final bool ativarProximo;
  final VoidCallback acionarVoltar;
  final VoidCallback acionarProximo;

  @override
  Widget build(BuildContext context) {
    const altura = 48.0;
    const duracao = Duration(milliseconds: 300);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.chevron_left),
                      SizedBox(width: 4),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(UIStrings.QUIZ_TEXTO_BOTAO_AVANCAR),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right),
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

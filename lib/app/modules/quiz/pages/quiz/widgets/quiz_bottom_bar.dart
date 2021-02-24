import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../quiz_controller.dart';
import '../../../shared/utils/strings_interface.dart';
import '../../../../../shared/theme/tema.dart';

///Barra contendo os botões para avançar e voltar na lista de itens.
class QuizBottomBar extends StatelessWidget {
  const QuizBottomBar(
    this.controller, 
    {Key key}
  ) : super(key: key);

  final QuizController controller;

  ThemeData get tema => Modular.get<MeuTema>().temaClaro;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ///Estrutura para o botão de voltar.
            Observer(builder: (_) {
              final double opacidade = controller.podeVoltar ? 1 : 0;
              return AnimatedOpacity(
                opacity: opacidade,
                duration: const Duration(milliseconds: 300),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: tema.colorScheme.onSurface,
                    padding: const EdgeInsets.only(right: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                    )
                  ),
                  onPressed: controller.podeVoltar ? controller.voltar : null,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.chevron_left),
                      const SizedBox(width: 4),
                      const Text(QUIZ_TEXTO_BOTAO_VOLTAR),
                    ],
                  )
                ),
              );
            }),
            ///Estrutura para o botão de avançar.
            Observer(builder: (_) {
              final double opacidade = controller.podeAvancar ? 1 : 0;
              return AnimatedOpacity(
                opacity: opacidade,
                duration: const Duration(milliseconds: 300),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: tema.colorScheme.onSurface,
                    padding: const EdgeInsets.only(left: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                    )
                  ),
                  onPressed: controller.podeAvancar ? controller.avancar : null,
                  child: Row(
                    children: <Widget>[
                      const Text(QUIZ_TEXTO_BOTAO_AVANCAR),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right),
                    ],
                  )
                ),
              );
            }),
          ],
        ),
      )
    );
  }
}
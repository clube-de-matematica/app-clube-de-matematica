import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../shared/theme/tema.dart';
import '../../../shared/utils/ui_strings.dart';
import '../quiz_controller.dart';

///Barra contendo os botões para avançar e voltar na lista de itens.
class QuizBottomBar extends BottomAppBar {
  QuizBottomBar(QuizController controller, {Key? key})
      : super(
          key: key,
          child: _buildChild(controller),
        );

  static ThemeData get _tema => Modular.get<MeuTema>().temaClaro;

  static Widget _buildChild(QuizController controller) {
    return Padding(
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
                      primary: _tema.colorScheme.onSurface,
                      padding: const EdgeInsets.only(right: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32))),
                  onPressed: controller.podeVoltar ? controller.voltar : null,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.chevron_left),
                      const SizedBox(width: 4),
                      const Text(UIStrings.QUIZ_TEXTO_BOTAO_VOLTAR),
                    ],
                  )),
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
                      primary: _tema.colorScheme.onSurface,
                      padding: const EdgeInsets.only(left: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32))),
                  onPressed: controller.podeAvancar ? controller.avancar : null,
                  child: Row(
                    children: <Widget>[
                      const Text(UIStrings.QUIZ_TEXTO_BOTAO_AVANCAR),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right),
                    ],
                  )),
            );
          }),
        ],
      ),
    );
  }
}

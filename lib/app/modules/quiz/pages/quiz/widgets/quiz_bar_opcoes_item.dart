import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../shared/theme/appTheme.dart';
import '../quiz_controller.dart';

/// Cria uma barra contendo, à esquerda, um indicador de andamento na lista de questões,
/// e, à direita, um botão para exibir um diálogo com as opções disponíveis para a questão.
class QuizBarOpcoesQuestao extends StatelessWidget {
  const QuizBarOpcoesQuestao(
    this.controller, {
    Key? key,
    this.padding = const EdgeInsets.symmetric(vertical: 4.0),
  }) : super(key: key);

  final QuizController controller;
  final EdgeInsetsGeometry padding;

  TextStyle? get textStyle => AppTheme.instance.temaClaro.textTheme.bodyText2;
  
  /* 
  /// As opções do popup de opções do item.
  static const _popupMenuItens = <PopupMenuItem<OpcoesQuestao>>[
    PopupMenuItem<OpcoesQuestao>(
      value: OpcoesQuestao.filter,
      child: ListTile(
        leading: const Icon(
          Icons.filter_alt,
          //color: Colors.white,
        ),
        title: const Text(UIStrings.QUIZ_OPCAO_ITEM_FILTRAR),
      ),
    )
  ];
   */
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Observer(builder: (_) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: controller.numQuestoes > 0
                  ? Text(
                      '${controller.indice + 1} de ${controller.numQuestoes}',
                      style: textStyle,
                    )
                  : const Text(""),
            );
          }),
          /* PopupMenuButton<OpcoesQuestao>(
            child: Row(
              children: <Widget>[
                Text(UIStrings.QUIZ_OPCOES_ITEM),
                const SizedBox(width: 4),
                Icon(
                  Icons.expand_more,
                  size: 20,
                ),
              ],
            ),
            onSelected: (opcao) => controller.setOpcaoItem(context, opcao),
            itemBuilder: (_) => _popupMenuItens,
          ), */
        ],
      ),
    );
  }
}

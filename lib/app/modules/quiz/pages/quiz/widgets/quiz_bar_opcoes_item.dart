import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../shared/theme/appTheme.dart';
import '../../../shared/models/opcoesQuestao.dart';
import '../../../shared/utils/ui_strings.dart';
import '../quiz_controller.dart';

///Cria uma barra contendo, à esquerda, um indicador de andamento na lista de questões,
///e, à direita, um botão para exibir um diálogo com as opções disponíveis para a questão.
class QuizBarOpcoesItem extends StatelessWidget {
  const QuizBarOpcoesItem(
    this.controller, {
    Key? key,
  }) : super(key: key);

  final QuizController controller;

  TextStyle? get textStyle =>
      AppTheme.instance.temaClaro.textTheme.bodyText2;

  ///As opções do popup de opções do item.
  static const _popupMenuItens = <PopupMenuItem<OpcoesQuestao>>[
    PopupMenuItem<OpcoesQuestao>(
      value: OpcoesQuestao.filter,
      child: ListTile(
        leading: const Icon(
          Icons.filter_list,
          //color: Colors.white,
        ),
        title: const Text(UIStrings.QUIZ_OPCAO_ITEM_FILTRAR),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Observer(builder: (_) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: controller.itensFiltrados.isNotEmpty
                ? Text(
                    controller.textoContadorBarOpcoesItem,
                    style: textStyle,
                  )
                : const Text(""),
          );
        }),
        PopupMenuButton<OpcoesQuestao>(
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
        ),
      ],
    );
  }
}

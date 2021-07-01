import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../shared/theme/tema.dart';
import '../../../shared/models/opcoesItem.dart';
import '../../../shared/utils/strings_interface.dart';
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
      Modular.get<MeuTema>().temaClaro.textTheme.bodyText2;

  ///As opções do popup de opções do item.
  static const _popupMenuItens = <PopupMenuItem<OpcoesItem>>[
    PopupMenuItem<OpcoesItem>(
      value: OpcoesItem.filter,
      child: ListTile(
        leading: const Icon(
          Icons.filter_list,
          //color: Colors.white,
        ),
        title: const Text(QUIZ_OPCAO_ITEM_FILTRAR),
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
        PopupMenuButton<OpcoesItem>(
          child: Row(
            children: <Widget>[
              Text(QUIZ_OPCOES_ITEM),
              const SizedBox(width: 4),
              Icon(
                Icons.expand_more,
                size: 20,
              ),
            ],
          ),
          onSelected: (opcao) => controller.setOpcaoItem(opcao),
          itemBuilder: (_) => _popupMenuItens,
        ),
      ],
    );
  }
}

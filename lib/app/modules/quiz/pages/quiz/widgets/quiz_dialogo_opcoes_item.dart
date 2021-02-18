import 'package:flutter/material.dart';

import '../../../shared/utils/strings_interface.dart';

///Diálogo com as opções para o item.
class QuizDialogoOpcoesItem extends StatelessWidget {
  const QuizDialogoOpcoesItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          child: ListTile(
            leading: const Icon(
              Icons.filter_list,
              //color: Colors.white,
            ),
            title: const Text(QUIZ_OPCAO_ITEM_FILTRAR),
          ),
          onPressed: () => Navigator.pop(context, 1),
        ),
      ],
    );
  }
}

import 'package:clubedematematica/app/shared/theme/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'quiz_dialogo_opcoes_item.dart';
import '../quiz_controller.dart';
import '../../../shared/utils/strings_interface.dart';

///Cria uma barra contendo, à esquerda, um indicador de andamento na lista de questões,
///e, à direita, um botão para exibir um diálogo com as opções disponíveis para a questão.
class QuizBarOpcoesItem extends StatelessWidget {
  const QuizBarOpcoesItem(
    this.controller,
    {Key key,
  }) : super(key: key);

  final QuizController controller;

  Color get textColor => Modular.get<MeuTema>().temaClaro.colorScheme.onSurface;

  TextStyle get textStyle => Modular.get<MeuTema>().temaClaro.textTheme.bodyText2;

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
        FlatButton(
          textTheme: ButtonTextTheme.normal,
          textColor: textColor, //A cor será atribuída ao texto e ao ícone.
          padding: const EdgeInsets.only(left: 16),
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)
          ),
          child: Row(
            children: <Widget>[
              Text(
                QUIZ_OPCOES_ITEM, 
                style: textStyle,
              ), 
              const SizedBox(width: 4),
              Icon(
                Icons.expand_more,
                size: 20,
              ),
            ],
          ),
          onPressed: () => _showDialogoOpcoesItem(context).then(
            (opcao) => controller.setOpcaoItem(opcao)
          ), 
        ),
      ],
    );
  }

  ///Exibe um diálogo com as opções para o item.
  Future<int> _showDialogoOpcoesItem(BuildContext context) async {
    return await showDialog<int>(
      context: context,
      builder: (context){
        return QuizDialogoOpcoesItem();
      }
    );
  }
}


import 'package:flutter/material.dart';

import '../../../../shared/widgets/botoes.dart';

/// Um [Widget] que exibe uma notificação de que a filtragem não retorna questões
/// e um botão para acessar as opções de filtro.
class FeedbackFiltragemVazia extends StatelessWidget {
  const FeedbackFiltragemVazia({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              'Nenhuma questão encontrada',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Center(
              child: AppTextButton(
                primary: true,
                child: const Text('ALTERAR FILTRO'),
                onPressed: onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
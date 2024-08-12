import 'package:flutter/material.dart';

import '../../../../shared/widgets/botoes.dart';

/// Um [Widget] que exibe uma notificação de que a filtragem não retorna questões
/// e um botão para acessar as opções de filtro.
class FeedbackFiltragemVazia extends StatelessWidget {
  const FeedbackFiltragemVazia({
    super.key,
    required this.onPressed,
  });

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
                  .bodyLarge
                  ?.copyWith(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Center(
              child: AppTextButton(
                primary: true,
                onPressed: onPressed,
                child: const Text('ALTERAR FILTRO'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

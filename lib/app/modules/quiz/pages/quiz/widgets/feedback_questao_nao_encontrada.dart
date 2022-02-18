import 'package:flutter/material.dart';

class FeedbackQuestaoNaoEncontrada extends StatelessWidget {
  const FeedbackQuestaoNaoEncontrada({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'Nenhuma questão encontrada',
          style:
              Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

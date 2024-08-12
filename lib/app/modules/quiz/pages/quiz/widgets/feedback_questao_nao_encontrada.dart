import 'package:flutter/material.dart';

class FeedbackQuestaoNaoEncontrada extends StatelessWidget {
  const FeedbackQuestaoNaoEncontrada({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          'Nenhuma questão encontrada',
          style:
              Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

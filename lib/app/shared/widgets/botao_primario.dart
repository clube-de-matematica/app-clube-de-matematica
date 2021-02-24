import 'package:flutter/material.dart';

///Botão com a cor primária do tema.
class BotaoPrimario extends StatelessWidget {
  const BotaoPrimario({
    Key key,
    @required this.label,
    @required this.onPressed,
  }) : super(key: key);

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    final tema = Theme.of(context);

    ///[ButtonTheme] é usado para pegar os padrões do [MaterialApp];
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onSurface: tema.primaryColor,
      ),
      child: Text(label),
      onPressed: onPressed,
    );
  }
}

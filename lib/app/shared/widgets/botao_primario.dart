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
    return ButtonTheme(
      child: RaisedButton(
        textTheme: ButtonTextTheme.primary,
        disabledColor: tema.primaryColor.withOpacity(0.4),
        disabledTextColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
        child: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}

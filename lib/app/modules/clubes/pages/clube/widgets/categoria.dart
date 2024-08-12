import 'package:flutter/material.dart';

class Categoria extends StatelessWidget {
  final String categoria;
  final List<Widget> itens;
  final List<Widget> Function(BuildContext context)? builder;

  Categoria({
    super.key,
    required this.categoria,
    this.itens = const [],
    this.builder,
  })  : assert(!(itens.isNotEmpty && builder != null));

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).primaryColor;
    final brightness = ThemeData.estimateBrightnessForColor(cor);
    final corTexto = brightness == Brightness.light ? Colors.black : cor;
    final listItens = builder?.call(context) ?? itens;
    
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              categoria,
              style: TextStyle(
                color: corTexto,
                fontSize: 32.0,
              ),
            ),
            subtitle: Divider(
              color: corTexto,
              height: 24.0,
              thickness: 2.0,
            ),
          ),
          for (final item in listItens) item,
        ],
      ),
    );
  }
}

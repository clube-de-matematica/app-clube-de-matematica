import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../clube_controller.dart';

class Categoria extends StatelessWidget {
  final String categoria;
  final List<Widget> itens;
  final List<Widget> Function(BuildContext context)? builder;

  Categoria({
    Key? key,
    required this.categoria,
    this.itens = const [],
    this.builder,
  })  : assert(!(itens.isNotEmpty && builder != null)),
        super(key: key);

  Color get cor => Modular.get<ClubeController>().clube.capa;

  Color get corTexto {
    final brightness = ThemeData.estimateBrightnessForColor(this.cor);
    return brightness == Brightness.light ? Colors.black : this.cor;
  }

  @override
  Widget build(BuildContext context) {
    final _itens = builder?.call(context) ?? itens;
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
          for (final item in _itens) item,
        ],
      ),
    );
  }
}

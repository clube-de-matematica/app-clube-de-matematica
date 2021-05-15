import 'package:flutter/material.dart';

///O item dos [ListView] das páginas de filtro.
class FiltroListTile extends ListTile {
  ///[titulo] é o título do elemento da lista.
  ///[selecionado] define o estado do indicador de seleção do elemento.
  ///[] é a ação a ser executada quando o elemento for clicado.
  FiltroListTile({
    Key? key,
    required String titulo,
    required bool selecionado,
    required VoidCallback onTap,
    EdgeInsetsGeometry? contentPadding,
  }) : super(
          key: key,
          dense: true,
          contentPadding: contentPadding ??
              const EdgeInsets.fromLTRB(
                  24, 0, 24, 0), //const EdgeInsets.only(left: 16),
          title: _buildTitle(titulo),
          trailing: _buildTrailing(selecionado),
          onTap: onTap,
        );

  static Widget _buildTitle(String titulo) => Builder(builder: (context) {
        return Text(
          titulo,
          style: Theme.of(context).textTheme.bodyText1,
        );
      });

  static Widget _buildTrailing(bool selecionado) => Builder(builder: (context) {
        return Icon(Icons.check,
            color: selecionado
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent);
      });
}

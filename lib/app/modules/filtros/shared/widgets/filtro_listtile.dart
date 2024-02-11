import 'package:flutter/material.dart';

/// O item dos [ListView] das páginas de filtro.
class FiltroListTile extends ListTile {
  /// [titulo] é o título do elemento da lista.
  /// [selecionado] define o estado do indicador de seleção do elemento.
  /// [onTap] é a ação a ser executada quando o elemento for clicado.
  FiltroListTile({
    Key? key,
    required String titulo,
    required bool selecionado,
    required VoidCallback onTap,
    EdgeInsetsGeometry? contentPadding,
  }) : super(
          key: key,
          contentPadding:
              contentPadding ?? const EdgeInsets.fromLTRB(24, 0, 24, 0),
          title: Builder(
            builder: (context) {
              return Text(
                titulo,
                style: Theme.of(context).textTheme.bodyLarge,
              );
            },
          ),
          trailing: Builder(
            builder: (context) {
              return Icon(Icons.check,
                  color: selecionado
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent);
            },
          ),
          onTap: onTap,
        );
}

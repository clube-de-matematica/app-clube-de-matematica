import 'package:flutter/material.dart';

///O item dos [ListView] das páginas de filtro.
class FiltroListTile extends StatelessWidget {
  const FiltroListTile({
    Key key,
    @required this.titulo,
    @required this.selecionado,
    @required this.onTap, 
    this.contentPadding,
  }) : super(key: key);

  ///Título do elemento da lista.
  final String titulo;

  ///Define o estado do indicador de seleção do elemento.
  final bool selecionado;

  ///Ação a ser executada quando o elemento for clicado.
  final VoidCallback onTap;

  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(24, 0, 24, 0),//const EdgeInsets.only(left: 16),
      title: Text(
        titulo,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: Icon(
        Icons.check,
        color: selecionado ? Theme.of(context).colorScheme.primary : Colors.transparent
      ),
      onTap: onTap
    );
  }
}

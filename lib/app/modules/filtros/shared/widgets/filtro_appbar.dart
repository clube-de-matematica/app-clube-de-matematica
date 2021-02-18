import 'package:flutter/material.dart';

///`AppBar` das páginas de filtro.
class FiltroAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FiltroAppBar(this.titulo, {Key key}) : super(key: key);

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(titulo)
    );
  }

  @override
  ///Necessário para que este [Widget] possa ser usado como o `appbar` de um [Scaffold].
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
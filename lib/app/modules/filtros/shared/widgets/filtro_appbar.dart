import 'package:flutter/material.dart';

///`AppBar` das páginas de filtro.
class FiltroAppBar extends AppBar {
  FiltroAppBar(
    String titulo, {
    Key? key,
  }) : super(
          key: key,
          elevation: 0,
          title: Text(titulo),
        );
}

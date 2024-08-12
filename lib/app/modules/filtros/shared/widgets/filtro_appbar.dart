import 'package:flutter/material.dart';

///`AppBar` das páginas de filtro.
class FiltroAppBar extends AppBar {
  FiltroAppBar(
    String titulo, {
    super.key,
  }) : super(
          elevation: 0,
          title: Text(titulo),
        );
}

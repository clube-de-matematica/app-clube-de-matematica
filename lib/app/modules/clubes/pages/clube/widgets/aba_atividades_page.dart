import 'package:flutter/material.dart';

import '../../../shared/models/clube.dart';

/// A subpágina exibida na aba "Atividades" da página do [clube].
class AtividadesPage extends StatelessWidget {
  const AtividadesPage({
    Key? key,
    required this.clube,
  }) : super(key: key);
  final Clube clube;

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}
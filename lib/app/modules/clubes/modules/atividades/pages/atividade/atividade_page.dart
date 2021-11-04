import 'package:flutter/material.dart';

import '../../models/atividade.dart';

class AtividadePage extends StatelessWidget {
  const AtividadePage(this.atividade, {Key? key}) : super(key: key);

  final Atividade atividade;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('data'),
    );
  }
}

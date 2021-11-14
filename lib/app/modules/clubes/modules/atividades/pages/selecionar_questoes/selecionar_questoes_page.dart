import 'package:flutter/material.dart';

import '../../../../../../modules/quiz/shared/models/questao_model.dart';

class SelecionarQuestoesPage extends StatefulWidget {
  const SelecionarQuestoesPage({
    Key? key,
    this.questoes,
  }) : super(key: key);

  final List<Questao>? questoes;

  @override
  _SelecionarQuestoesPageState createState() => _SelecionarQuestoesPageState();
}

class _SelecionarQuestoesPageState extends State<SelecionarQuestoesPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

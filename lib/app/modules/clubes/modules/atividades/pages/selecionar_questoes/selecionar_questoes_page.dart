import 'package:clubedematematica/app/shared/repositories/questoes/questoes_repository.dart';
import 'package:clubedematematica/app/shared/widgets/barra_inferior_anterior_proximo.dart';
import 'package:clubedematematica/app/shared/widgets/questao_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
  bool selecionada = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questões'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Chip(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              visualDensity: VisualDensity.compact,
              label: Text('23'),
            ),
          ),
          PopupMenuButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.filter_alt),
            ),
            /* IconButton(
              onPressed: () {},
              icon: Icon(Icons.filter_alt),
            ), */
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text('Mostrar somente selecionadas'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('Filtrar'),
              ),
            ],
            onSelected: (opcao) async {
              switch (opcao) {
                case 1:
                  break;
                case 2:
                  break;
              }
            },
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.check_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Checkbox(
                      visualDensity: VisualDensity.standard,
                      value: selecionada,
                      onChanged: (valor) =>
                          setState(() => selecionada = valor!),
                    ),
                    Text('2019PF1N1Q01'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text('1 de 15'),
              ),
            ],
          ),
          Divider(
            height: 0,
            indent: 16.0,
            endIndent: 16.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: Modular.get<QuestoesRepository>().questoesAsync,
              builder: (context, AsyncSnapshot<List<Questao>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return QuestaoWidget(
                  questao: snapshot.data![1],
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  selecionavel: false,
                  rolavel: true,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarraIferiorAteriorProximo(
        ativarVoltar: true,
        ativarProximo: true,
        acionarVoltar: () => null,
        acionarProximo: () => null,
        shape: const CircularNotchedRectangle(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Icon(
          selecionada ? Icons.radio_button_on : Icons.radio_button_off,
          size: 28.0,
          color: selecionada
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).disabledColor,
        ),
        onPressed: () => setState(() => selecionada = !selecionada),
      ),
    );
  }
}

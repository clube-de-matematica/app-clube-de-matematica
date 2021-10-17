import 'package:flutter/material.dart';

import 'adicionar_clube_controller.dart';
import 'widgets/form_codigo_clube.dart';
import 'widgets/form_crar_clube.dart';

class AdicionarClubePage extends StatefulWidget {
  const AdicionarClubePage({Key? key}) : super(key: key);

  @override
  _AdicionarClubePageState createState() => _AdicionarClubePageState();
}

class _AdicionarClubePageState extends State<AdicionarClubePage> {
  final controller = AdicionarClubeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          FormCodigoClube(
            onParticipar: (codigo) async {
              await controller.participar(context, codigo);
            },
          ),
          const Divider(height: 48.0),
          FormCriarClube(
            onCriar: (nome, descricao, corTema, privado) async {
              await controller.criar(
                  context, nome, descricao, corTema, privado);
            },
          )
        ],
      ),
    );
  }
}
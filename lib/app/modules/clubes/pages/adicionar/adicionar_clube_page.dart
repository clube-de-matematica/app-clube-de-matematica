import 'package:flutter/material.dart';

import '../../shared/widgets/bottom_sheet_erro.dart';
import 'adicionar_clube_controller.dart';
import 'widgets/form_codigo_clube.dart';
import 'widgets/form_criar_clube.dart';

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
              final sucesso = await controller.participar(context, codigo);
              if (!sucesso) {
                await BottomSheetErroParticiparClube().showModal(context);
              }
            },
          ),
          const Divider(height: 48.0),
          FormCriarClube(
            validarNome: (nome) => controller.validarNome(nome),
            onCriar: (nome, descricao, corTema, privado) async {
              final sucesso = await controller.criar(
                  context, nome, descricao, corTema, privado);
              if (!sucesso) {
                await BottomSheetErroCriarClube().showModal(context);
              }
            },
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../shared/widgets/appBottomSheet.dart';
import '../../shared/widgets/bottom_sheet_erro.dart';
import 'criar_clube_controller.dart';
import 'widgets/form_criar_clube.dart';

class CriarClubePage extends StatefulWidget {
  const CriarClubePage({super.key});

  @override
  CriarClubePageState createState() => CriarClubePageState();
}

class CriarClubePageState extends State<CriarClubePage> {
  final controller = AdicionarClubeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar clube')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          FormCriarClube(
            validarNome: (nome) => controller.validarNome(nome),
            onCriar: (nome, descricao, corTema, privado) =>
                _onCriar(context, nome, descricao, corTema, privado),
          )
        ],
      ),
    );
  }

  Future _onCriar(
    BuildContext context,
    String nome,
    String? descricao,
    Color corTema,
    bool privado,
  ) async {
    final future = controller.criar(nome, descricao, corTema, privado);
    await BottomSheetCarregando(future: future).showModal(context);
    final clube = await future;
    if (clube != null) {
      if (context.mounted) {
        controller.abrirPaginaClube(context, clube);
      }
    } else {
      if (context.mounted) {
        await const BottomSheetErroCriarClube().showModal(context);
      }
    }
  }
}

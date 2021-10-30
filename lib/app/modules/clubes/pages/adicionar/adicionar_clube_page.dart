import 'package:flutter/material.dart';

import '../../../../shared/widgets/appBottomSheet.dart';
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
            onParticipar: (codigo) => _onParticipar(context, codigo),
          ),
          const Divider(height: 48.0),
          FormCriarClube(
            validarNome: (nome) => controller.validarNome(nome),
            onCriar: (nome, descricao, corTema, privado) =>
                _onCriar(context, nome, descricao, corTema, privado),
          )
        ],
      ),
    );
  }

  Future _onParticipar(BuildContext context, String codigo) async {
    final future = controller.participar(codigo);
    await BottomSheetCarregando(future: future).showModal(context);
    final clube = await future;
    if (clube != null) {
      controller.abrirPaginaClube(context, clube);
    } else {
      await BottomSheetErroParticiparClube().showModal(context);
    }
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
      controller.abrirPaginaClube(context, clube);
    } else {
      await BottomSheetErroParticiparClube().showModal(context);
    }
  }
}

import 'package:flutter/material.dart';

import '../../../../shared/models/clube.dart';
import '../../shared/widgets/form_criar_editar_atividade.dart';
import 'criar_atividade_controller.dart';

class CriarAtividadePage extends StatefulWidget {
  const CriarAtividadePage(this.clube, {Key? key}) : super(key: key);

  final Clube clube;

  @override
  State<CriarAtividadePage> createState() => _CriarAtividadePageState();
}

class _CriarAtividadePageState extends State<CriarAtividadePage> {
  final controller = CriarAtividadeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar atividade'),
      ),
      body: FormCriarEditarAtividade(validarTitulo: controller.validarTitulo),
    );
  }
}

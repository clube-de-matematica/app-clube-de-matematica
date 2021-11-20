import 'package:flutter/material.dart';

import '../../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../quiz/shared/models/questao_model.dart';
import '../../../../pages/editar/editar_clube_page.dart';
import '../../../../shared/models/clube.dart';
import '../../models/atividade.dart';
import '../../shared/widgets/form_criar_editar_atividade.dart';
import 'editar_atividade_controller.dart';

/// Modelo para os argumentos do construtor de [EditarClubePage].
class ArgumentosEditarAtividadePage {
  const ArgumentosEditarAtividadePage({
    required this.clube,
    required this.atividade,
  });
  final Clube clube;
  final Atividade atividade;
}

/// Página para editar atividades.
class EditarAtividadePage extends StatefulWidget {
  EditarAtividadePage(
    ArgumentosEditarAtividadePage argumentos, {
    Key? key,
  })  : clube = argumentos.clube,
        atividade = argumentos.atividade,
        super(key: key);

  final Clube clube;
  final Atividade atividade;

  @override
  State<EditarAtividadePage> createState() => _EditarAtividadePageState();
}

class _EditarAtividadePageState extends State<EditarAtividadePage> {
  late final controller = EditarAtividadeController(widget.clube, widget.atividade);
  bool _salvando = false;
  Atividade get atividade => controller.atividade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar atividade'),
      ),
      body: FormCriarEditarAtividade(
        titulo: atividade.titulo,
        descricao: atividade.descricao,
        liberacao: atividade.liberacao,
        encerramento: atividade.encerramento,
        questoes: atividade.questoes,
        validarTitulo: controller.validarTitulo,
        salvar: ({
          String? descricao,
          DateTime? encerramento,
          required DateTime liberacao,
          List<Questao> questoes = const [],
          required String titulo,
        }) async {
          if (!_salvando) {
            _salvando = true;
            final future = controller
                .salvar(
                  descricao: descricao,
                  encerramento: encerramento,
                  liberacao: liberacao,
                  questoes: questoes,
                  titulo: titulo,
                )
                .whenComplete(() => _salvando = false);
            await BottomSheetCarregando(future: future).showModal(context);
            final atividade = await future;
            if (mounted) {
              if (atividade != null) {
                Navigator.of(context).pop();
              } else {
                await BottomSheetErro('As alterações não foram salvas')
                    .showModal(context);
              }
            }
          }
        },
      ),
    );
  }
}

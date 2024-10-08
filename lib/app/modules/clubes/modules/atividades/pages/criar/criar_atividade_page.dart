import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../quiz/shared/models/questao_model.dart';
import '../../../../shared/models/clube.dart';
import '../../../../shared/utils/tema_clube.dart';
import '../../shared/widgets/form_criar_editar_atividade.dart';
import 'criar_atividade_controller.dart';

class CriarAtividadePage extends StatefulWidget {
  const CriarAtividadePage(this.clube, {super.key});

  final Clube clube;

  @override
  State<CriarAtividadePage> createState() => _CriarAtividadePageState();
}

class _CriarAtividadePageState extends State<CriarAtividadePage> {
  late final controller = CriarAtividadeController(widget.clube);
  bool _salvando = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Modular.get<TemaClube>().tema,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Criar atividade'),
        ),
        body: FormCriarEditarAtividade(
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
              final sucesso = await future;
              if (mounted) {
                if (sucesso) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } else {
                  if (context.mounted) {
                    await const BottomSheetErro('A atividade não foi criada')
                        .showModal(context);
                  }
                }
              }
            }
          },
        ),
      ),
    );
  }
}

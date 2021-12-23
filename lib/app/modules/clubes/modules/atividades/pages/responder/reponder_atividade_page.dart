import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../../shared/widgets/barra_inferior_anterior_proximo.dart';
import '../../../../../../shared/widgets/questao_widget.dart';
import '../../models/argumentos_atividade_page.dart';
import '../../models/atividade.dart';
import 'responder_atividade_controller.dart';

/// Página destinada a responder às questões de uma atividade.
class ResponderAtividadePage extends StatefulWidget {
  ResponderAtividadePage(ArgumentosAtividadePage args, {Key? key})
      : atividade = args.atividade,
        super(key: key);

  final Atividade atividade;

  @override
  State<ResponderAtividadePage> createState() => _ResponderAtividadePageState();
}

class _ResponderAtividadePageState extends State<ResponderAtividadePage> {
  late final controle = ResponderAtividadeController(widget.atividade);

  @override
  void dispose() {
    controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.atividade.titulo),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _concluir,
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Observer(builder: (_) {
          return controle.questao == null
              ? _corpoSemQuestao()
              : _corpoComQuestao();
        }),
      ),
      bottomNavigationBar: _barraInferior(),
      /* floatingActionButton: Observer(builder: (_) {
        final ativo = controle.podeConfirmar;
        return !ativo
            ? const SizedBox()
            : FloatingActionButton.extended(
                icon: const Icon(Icons.done),
                label: const Text('CONFIRMAR'),
                onPressed: !ativo
                    ? null
                    : () {
                        controle.confirmar();
                      },
              );
      }), */
    );
  }

  /// Retorna verdadeiro se o fechamento da página não implicar a perda de dados não salvos.
  Future<bool> _onWillPop() async {
    if (controle.questoesModificadas.isEmpty) return true;

    final sair = await BottomSheetCancelarSair(
      title: const Text('A atividade não foi finalizada'),
      message: 'As respostas não serão salvas.',
    ).showModal<bool>(context);

    return sair ?? false;
  }

  void _concluir() async {
    final n = controle.questoesEmBranco.length;
    if (n > 0) {
      final entregar = await BottomSheetCancelarConfirmar(
        message: 'Há $n ${n == 1 ? "questão" : "questões"} em branco. '
            'Deseja entregar a atividade?',
      ).showModal<bool>(context);
      if (entregar == null || !entregar) return;
    }
    if (controle.questoesModificadas.isNotEmpty) {
      final futuro = controle.concluir();
      if (mounted) {
        await BottomSheetCarregando(future: futuro).showModal(context);
      }
      final entregue = await futuro;
      if (mounted) {
        if (entregue) {
          Navigator.of(context).pop();
        } else {
          BottomSheetErro(
            'Não foi possível entregar a atividade. Tente novamente.',
          ).showModal(context);
        }
      }
    }
  }

  Widget _corpoSemQuestao() {
    return Builder(builder: (context) {
      return Center(
        child: Text(
          'Nenhuma questão encontrada',
          style:
              Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  Widget _corpoComQuestao() {
    return Observer(builder: (_) {
      return QuestaoWidget(
        barraOpcoes: _construirCabecalho(),
        questao: controle.questao!,
        alternativaSelecionada: controle.resposta?.sequencialTemporario ??
            controle.resposta?.sequencial,
        alterandoAlternativa: (alternativa) {
          controle.resposta?.sequencialTemporario = alternativa?.sequencial;
        },
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        selecionavel: true,
        rolavel: true,
      );
    });
  }

  /// Uma linha com o ID da questão e um indicador de posição na lista de questões.
  Widget _construirCabecalho() {
    return Observer(builder: (_) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child:
                Text('${controle.indice + 1} de ${controle.questoes.length}'),
          ),
          Text(controle.questao?.id ?? ''),
        ],
      );
    });
  }

  Widget _barraInferior() {
    return Observer(builder: (_) {
      return BarraIferiorAteriorProximo(
        ativarVoltar: controle.podeVoltar,
        ativarProximo: controle.podeAvancar,
        acionarVoltar: controle.voltar,
        acionarProximo: controle.avancar,
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../shared/widgets/barra_inferior_anterior_proximo.dart';
import '../../../../../../shared/widgets/questao_widget.dart';
import '../../models/atividade.dart';
import 'responder_atividade_controller.dart';

class ResponderAtividadePage extends StatelessWidget {
  ResponderAtividadePage(this.atividade, {Key? key}) : super(key: key);

  final Atividade atividade;
  late final controle = ResponderAtividadeController(atividade);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(atividade.titulo),
      ),
      body: Observer(builder: (_) {
        return controle.questao == null
            ? _corpoSemQuestao()
            : _corpoComQuestao();
      }),
      bottomNavigationBar: _barraInferior(),
      floatingActionButton: Observer(builder: (_) {
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
      }),
    );
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
    return QuestaoWidget(
      barraOpcoes: _construirCabecalho(),
      questao: controle.questao!,
      alternativaSelecionada: controle.alternativaSelecionada,
      alterandoAlternativa: (alternativa) =>
          controle.alternativaSelecionada = alternativa?.sequencial,
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      selecionavel: true,
      rolavel: true,
    );
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

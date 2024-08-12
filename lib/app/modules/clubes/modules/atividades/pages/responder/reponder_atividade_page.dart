import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../shared/theme/appTheme.dart';
import '../../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../../shared/widgets/barra_inferior_anterior_proximo.dart';
import '../../../../../../shared/widgets/questao_widget.dart';
import '../../../../shared/utils/tema_clube.dart';
import '../../models/argumentos_atividade_page.dart';
import '../../models/atividade.dart';
import 'responder_atividade_controller.dart';

/// Página destinada a responder às questões de uma atividade.
class ResponderAtividadePage extends StatefulWidget {
  ResponderAtividadePage(ArgumentosAtividadePage args, {super.key})
      : atividade = args.atividade;

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
    return Theme(
      data: Modular.get<TemaClube>().tema,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.atividade.titulo),
          actions: [
            Observer(builder: (_) {
              if (!controle.atividadeEncerrada &&
                  controle.questaoAtual.value != null) {
                return IconButton(
                  icon: const Icon(Icons.task),
                  onPressed: _concluir,
                );
              }
              return const SizedBox();
            }),
          ],
        ),
        body: Observer(
          builder: (context) {
            return PopScope(
              canPop: controle.isEmpty,
              onPopInvoked: (canPop) async {
                if (!canPop) {
                  final newCanPop = await _willPop(context);
                  if (newCanPop) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                }
              },
              child: Observer(builder: (_) {
                return controle.questaoAtual.value == null
                    ? _corpoSemQuestao()
                    : _corpoComQuestao();
              }),
            );
          },
        ),
        bottomNavigationBar: _barraInferior(),
        floatingActionButton: Observer(builder: (_) {
          final ativo =
              controle.questoesEmBranco.isEmpty && controle.podeConcluir;
          return !ativo
              ? const SizedBox()
              : FloatingActionButton.extended(
                  icon: const Icon(Icons.done),
                  label: const Text('CONCLUIR'),
                  onPressed: !ativo ? null : _concluir,
                );
        }),
      ),
    );
  }

  /// Retorna verdadeiro, assincronamente, se o fechamento da página não implicar a perda de dados não salvos, caso contrário, exibe um [BottomSheetSalvarSairCancelar] e retorna um [bool] correspondente a escolha do usuário.
  Future<bool> _willPop(BuildContext context) async {
    if (controle.isEmpty) return true;

    /// Retorná:
    /// * 0 se o usuário escolher cancelar;
    /// * 1 se o usuário escolher sair; e
    /// * 2 se o usuário escolher salvar.
    final indice = await BottomSheetSalvarSairCancelar(
      title: const Text('A atividade não foi finalizada'),
      message: 'As respostas não serão salvas.',
    ).showModal<int>(context);
    if (indice == 1) return true;
    if (indice == 2) _concluir();
    return false;
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
          const BottomSheetErro(
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
          style: AppTheme.instance.light.textTheme.bodyLarge
              ?.copyWith(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
      );
    });
  }

  Widget _corpoComQuestao() {
    return Observer(builder: (_) {
      return QuestaoWidget(
        barraOpcoes: _construirCabecalho(),
        questao: controle.questaoAtual.value!,
        alternativaSelecionada: controle.resposta?.sequencialTemporario ??
            controle.resposta?.sequencial,
        alterandoAlternativa: controle.atividadeEncerrada
            ? null
            : (alternativa) {
                controle.resposta?.sequencialTemporario =
                    alternativa?.sequencial;
              },
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        selecionavel: !controle.atividadeEncerrada,
        verificar: controle.atividadeEncerrada,
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
            child: Text('${controle.indice + 1} de ${controle.numQuestoes}'),
          ),
          Text(controle.questaoAtual.value?.idAlfanumerico ?? ''),
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

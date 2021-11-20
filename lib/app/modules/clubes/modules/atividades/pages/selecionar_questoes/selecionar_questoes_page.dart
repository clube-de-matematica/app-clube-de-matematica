import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../modules/quiz/shared/models/questao_model.dart';
import '../../../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../../../../../shared/widgets/barra_inferior_anterior_proximo.dart';
import '../../../../../../shared/widgets/checkbox_popup_menu_item.dart';
import '../../../../../../shared/widgets/questao_widget.dart';
import '../../../../../filtros/shared/widgets/feedback_filtragem_vazia.dart';
import 'selecionar_questoes_controller.dart';

/// Páfina utilizada para selecionar questões.
/// Ao ser fechada usando o botão de confirmação ([Icons.done] na [AppBar]), retorna a
/// lista de questões selecionadas.
class SelecionarQuestoesPage extends StatefulWidget {
  const SelecionarQuestoesPage({
    Key? key,
    this.questoes,
  }) : super(key: key);

  final List<Questao>? questoes;

  @override
  _SelecionarQuestoesPageState createState() => _SelecionarQuestoesPageState();
}

class _SelecionarQuestoesPageState extends State<SelecionarQuestoesPage> {
  late final SelecionarQuestoesController controle =
      SelecionarQuestoesController(widget.questoes ?? []);
  ThemeData get tema => Theme.of(context);

  @override
  void dispose() {
    super.dispose();
    controle.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questões'),
        actions: [
          _construirChip(),
          _construirBotaoMenuFiltro(),
          _construirBotaoAplicar(),
        ],
      ),
      body: FutureBuilder(
          future: Modular.get<QuestoesRepository>().inicializando,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              // Carregando...
              return Center(child: const CircularProgressIndicator());
            } else {
              return Observer(builder: (_) {
                if (controle.questao == null) {
                  // Carregado sem questões a serem exibidas.
                  return _corpoSemQuestao();
                }
                // Carregado com questões a serem exibidas.
                return _corpoComQuestao();
              });
            }
          }),
      bottomNavigationBar: _barraInferior(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _botaoFlutuante(),
    );
  }

  /// Corpo da página exibido quando o filtro retorna questões.
  Column _corpoComQuestao() {
    return Column(
      children: [
        _construirCabecalho(),
        Divider(
          height: 0,
          indent: 16.0,
          endIndent: 16.0,
        ),
        Expanded(
          child: QuestaoWidget(
            questao: controle.questao!,
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            selecionavel: false,
            rolavel: true,
          ),
        ),
      ],
    );
  }

  /// Uma linha com um [Checkbox], o ID da questão e um indicador de posição na
  /// lista de questões.
  Row _construirCabecalho() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Observer(builder: (_) {
            return Row(
              children: [
                Checkbox(
                  visualDensity: VisualDensity.standard,
                  value: controle.selecionada,
                  onChanged: (valor) => controle.alterarSelecao(),
                ),
                Text(controle.questao?.id ?? ''),
              ],
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Observer(builder: (_) {
            return Text(
                '${controle.indice + 1} de ${controle.questoesFiltradas.length}');
          }),
        ),
      ],
    );
  }

  /// Corpo da página exibido quando o filtro não retorna questões.
  FeedbackFiltragemVazia _corpoSemQuestao() {
    return FeedbackFiltragemVazia(
      onPressed: () => controle.abrirPaginaFiltros(context),
    );
  }

  Widget _barraInferior() {
    return Observer(builder: (_) {
      return BarraIferiorAteriorProximo(
        ativarVoltar: controle.podeVoltar,
        ativarProximo: controle.podeAvancar,
        acionarVoltar: controle.voltar,
        acionarProximo: controle.avancar,
        shape: const CircularNotchedRectangle(),
      );
    });
  }

  FloatingActionButton _botaoFlutuante() {
    return FloatingActionButton.small(
      backgroundColor: tema.colorScheme.surface,
      child: Observer(builder: (_) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            controle.selecionada
                ? Icons.radio_button_on
                : Icons.radio_button_off,
            size: 28.0,
            color: controle.selecionada
                ? tema.colorScheme.primary
                : tema.disabledColor,
          ),
        );
      }),
      onPressed: controle.alterarSelecao,
    );
  }

  IconButton _construirBotaoAplicar() {
    return IconButton(
      icon: Icon(Icons.done_rounded),
      onPressed: () {
        Navigator.of(context).pop(controle.aplicar());
      },
    );
  }

  PopupMenuButton<int> _construirBotaoMenuFiltro() {
    return PopupMenuButton(
      icon: Icon(Icons.filter_alt),
      itemBuilder: (_) => [
        CheckboxPopupMenuItem(
          value: 1,
          child: const Text('Mostrar somente selecionadas'),
          checked: controle.mostrarSomenteQuestoesSelecionadas,
          onChanged: (checked) {
            if (checked != null) {
              controle.mostrarSomenteQuestoesSelecionadas = checked;
            }
          },
        ),
        PopupMenuItem(
          value: 2,
          child: const Text('Filtrar'),
        ),
        PopupMenuItem(
          value: 3,
          enabled: controle.filtros.totalSelecinado > 0,
          child: const Text('Limpar filtros'),
        ),
      ],
      onSelected: (opcao) async {
        switch (opcao) {
          case 1:
            controle.mostrarSomenteQuestoesSelecionadas =
                !controle.mostrarSomenteQuestoesSelecionadas;
            break;
          case 2:
            controle.abrirPaginaFiltros(context);
            break;
          case 3:
            controle.limparFiltros();
            break;
        }
      },
    );
  }

  Widget _construirChip() {
    return Observer(builder: (_) {
      final contador = controle.numQuestoesSelecionadas;
      if (contador > 0) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Chip(
            backgroundColor: tema.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            visualDensity: VisualDensity.compact,
            label: Text('$contador'),
          ),
        );
      }
      return const SizedBox();
    });
  }
}

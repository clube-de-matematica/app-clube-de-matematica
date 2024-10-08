import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../modules/quiz/shared/models/questao_model.dart';
import '../../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../../shared/widgets/barra_inferior_anterior_proximo.dart';
import '../../../../../../shared/widgets/checkbox_popup_menu_item.dart';
import '../../../../../../shared/widgets/questao_widget.dart';
import '../../../../../filtros/shared/widgets/feedback_filtragem_vazia.dart';
import 'selecionar_questoes_controller.dart';

/// Página utilizada para selecionar questões.
/// Ao ser fechada usando o botão de confirmação ([Icons.done] na [AppBar]), retorna a
/// lista de questões selecionadas.
class SelecionarQuestoesPage extends StatefulWidget {
  const SelecionarQuestoesPage({
    super.key,
    this.questoes,
  });

  final List<Questao>? questoes;

  @override
  SelecionarQuestoesPageState createState() => SelecionarQuestoesPageState();
}

class SelecionarQuestoesPageState extends State<SelecionarQuestoesPage> {
  late final SelecionarQuestoesController controle =
      SelecionarQuestoesController(widget.questoes ?? []);
  ThemeData get tema => Theme.of(context);

  @override
  void dispose() {
    controle.dispose();
    super.dispose();
  }

  Future<bool> _willPop(BuildContext context) async {
    if (!controle.alterada) {
      return true;
    }

    /// Retorná:
    /// * 0 se o usuário escolher cancelar;
    /// * 1 se o usuário escolher sair; e
    /// * 2 se o usuário escolher salvar.
    final retorno = await BottomSheetSalvarSairCancelar(
      title: const Text('As questões não foram salvas'),
      message: 'Ao sair as questões selecionadas não serão salvas.',
    ).showModal<int>(context);
    if (retorno == 2) {
      controle.aplicar();
      return true;
    } else if (retorno == 1) {
      controle.cancelar();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return PopScope(
          canPop: !controle.alterada,
          onPopInvokedWithResult: (canPop, _) async {
            if (!canPop) {
              final newCanPop = await _willPop(context);
              if (newCanPop) {
                if (context.mounted) {
                  Navigator.of(context).pop(controle.questoesSelecionadas);
                }
              }
            }
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kBottomNavigationBarHeight),
              child: Observer(builder: (_) {
                return AppBar(
                  title: const Text('Questões'),
                  actions: [
                    if (controle.numQuestoesSelecionadas > 0) _construirChip(),
                    _construirBotaoMenuFiltro(),
                    _construirBotaoAplicar(),
                  ],
                );
              }),
            ),
            body: FutureBuilder(
                future: controle.questaoAtual,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    // Carregando...
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Observer(builder: (_) {
                      if (controle.numQuestoes == 0) {
                        // Carregado sem questões a serem exibidas.
                        return _corpoSemQuestao();
                      }
                      // Carregado com questões a serem exibidas.
                      return _corpoComQuestao();
                    });
                  }
                }),
            bottomNavigationBar: _barraInferior(),
            //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            //floatingActionButton: _botaoFlutuante(),
          ),
        );
      },
    );
  }

  /// Corpo da página exibido quando o filtro retorna questões.
  Widget _corpoComQuestao() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _construirCabecalho(),
          const Divider(
            height: 0,
            indent: 16.0,
            endIndent: 16.0,
          ),
          QuestaoWidget(
            questao: controle.questaoAtual.value!,
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            selecionavel: false,
            rolavel: false,
          ),
        ],
      ),
    );
  }

  /// Uma linha com um [Checkbox], o ID da questão e um indicador de posição na
  /// lista de questões.
  Row _construirCabecalho() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Observer(builder: (_) {
            return Text('OBMEP (${controle.questaoAtual.value?.ano})');
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Observer(builder: (_) {
            return Text('${controle.indice + 1} de ${controle.numQuestoes}');
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
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          BarraIferiorAteriorProximo(
            ativarVoltar: controle.podeVoltar,
            ativarProximo: controle.podeAvancar,
            acionarVoltar: controle.voltar,
            acionarProximo: controle.avancar,
          ),
          Tooltip(
            message: 'Toque para alternar a seleção dessa questão',
            child: MaterialButton(
              onPressed: controle.alterarSelecao,
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
                        : tema.colorScheme.onSurface,
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }

  IconButton _construirBotaoAplicar() {
    return IconButton(
      icon: const Icon(Icons.save),
      onPressed: () {
        Navigator.of(context).pop(controle.aplicar());
      },
    );
  }

  Widget _construirBotaoMenuFiltro() {
    return PopupMenuButton(
      icon: const Icon(Icons.filter_alt),
      itemBuilder: (_) => [
        CheckboxPopupMenuItem(
          value: 1,
          checked: controle.mostrarSomenteQuestoesSelecionadas,
          onChanged: (checked) {
            if (checked != null) {
              controle.mostrarSomenteQuestoesSelecionadas = checked;
            }
          },
          child: const Text('Mostrar somente selecionadas'),
        ),
        _PopupMenuItemFiltrar(
          controle: controle,
          valor: 2,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Chip(
        backgroundColor: tema.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        visualDensity: VisualDensity.compact,
        label: Text('${controle.numQuestoesSelecionadas}'),
      ),
    );
  }
}

class _PopupMenuItemFiltrar extends PopupMenuEntry<int> {
  const _PopupMenuItemFiltrar({
    required this.controle,
    required this.valor,
  });

  final SelecionarQuestoesController controle;
  final int valor;

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(value) => value == valor;

  @override
  State<StatefulWidget> createState() => _PopupMenuItemFiltrarState();
}

class _PopupMenuItemFiltrarState extends State<_PopupMenuItemFiltrar> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return PopupMenuItem(
        value: widget.valor,
        enabled: !widget.controle.mostrarSomenteQuestoesSelecionadas,
        child: const Text('Filtrar'),
      );
    });
  }
}

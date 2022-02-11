import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../shared/utils/ui_strings.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/widgets/app_barra_inferior_filtro.dart';
import '../../shared/widgets/filtro_appbar.dart';
import '../../shared/widgets/filtro_chip_contador.dart';
import '../../shared/widgets/filtro_listtile.dart';
import '../../shared/widgets/filtros_selecionados.dart';
import 'filtro_anos_controller.dart';

/// Página onde são listados os anos disponíveis para filtragem.
class FiltroAnosPage extends StatelessWidget {
  FiltroAnosPage({
    Key? key,
    required Filtros filtrosSalvos,
    required Filtros filtrosTemp,
  })  : controle = FiltroAnosController(
          filtrosSalvos: filtrosSalvos,
          filtrosTemp: filtrosTemp,
        ),
        super(key: key);

  final FiltroAnosController controle;

  /// Exibe um [InputChip] para cada filtro selecionado.
  FiltrosSelecionados _construirCaixaFiltrosSelecionados() {
    return FiltrosSelecionados(
      child: Observer(builder: (_) {
        final chips = controle.selecionados.map((opcao) {
          return InputChip(
            label: Text(opcao.toString()),
            onDeleted: () => controle.remover(opcao),
          );
        }).toList();
        return Wrap(children: chips, spacing: 8);
      }),
      trailing: Observer(builder: (_) {
        return FiltroChipContador(controle.totalSelecinado.toString());
      }),
    );
  }

  Widget _construirCorpo() {
    return FutureBuilder(
      future: controle.anos,
      builder: (_, AsyncSnapshot<List<int>> snapshot) {
        if (snapshot.hasError) {
          return const Expanded(
            child: Center(
              child: Text(UIStrings.APP_MSG_ERRO_INESPERADO),
            ),
          );
        }
        if (snapshot.hasData) {
          final opcoes = snapshot.data ?? [];
          if (opcoes.isEmpty) {
            return const Expanded(
              child: Center(
                child: Text('Não há opções disponíveis'),
              ),
            );
          }
          return Expanded(
            child: ListView.separated(
              itemCount: opcoes.length,
              itemBuilder: (_, indice) {
                final opcao = opcoes[indice];
                return Observer(builder: (_) {
                  final selecionado = controle.selecionados.contains(opcao);
                  return FiltroListTile(
                    titulo: opcao.toString(),
                    selecionado: selecionado,
                    onTap: () => selecionado
                        ? controle.remover(opcao)
                        : controle.adicionar(opcao),
                  );
                });
              },
              separatorBuilder: (_, __) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: const Divider(height: double.minPositive),
              ),
            ),
          );
        }
        return Center(child: const CircularProgressIndicator());
      },
    );
  }

  Observer _construirBarraInferior() {
    return Observer(builder: (_) {
      return AppBarraInferiorFiltro(
        onPressedLimpar: controle.ativarLimpar ? controle.limpar : null,
        onPressedAplicar: controle.ativarAplicar ? controle.aplicar : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FiltroAppBar(controle.tituloAppBar),
      body: Column(children: [
        _construirCaixaFiltrosSelecionados(),
        _construirCorpo(),
      ]),
      bottomNavigationBar: _construirBarraInferior(),
    );
  }
}

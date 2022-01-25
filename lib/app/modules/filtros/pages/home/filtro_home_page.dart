import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../shared/models/filtros_model.dart';
import '../../shared/widgets/app_barra_inferior_filtro.dart';
import '../../shared/widgets/filtro_appbar.dart';
import '../../shared/widgets/filtro_chip_contador.dart';
import '../../shared/widgets/filtros_selecionados.dart';
import '../anos/filtro_anos_page.dart';
import '../assuntos/filtro_assuntos_page.dart';
import '../niveis/filtro_niveis_page.dart';
import 'filtro_home_controller.dart';

/// Esta é a página onde são listadas os tipos de filtro disponíveis: ano, assunto, 
/// nível, etc.
///
/// Ao aplicar os filtros, as devidas alterações serão feitas no [Filtros] passado 
/// no construtor.
class FiltroHomePage extends StatelessWidget {
  FiltroHomePage({
    Key? key,
    required Filtros filtro,
  })  : controle = FiltroHomeController(
          filtrosSalvos: filtro,
          filtrosTemp: Filtros.from(filtro),
        ),
        super(key: key);

  final FiltroHomeController controle;

  final tipos = [TiposFiltro.ano, TiposFiltro.assunto, TiposFiltro.nivel];

  /// Exibe um [InputChip] para cada filtro selecionado.
  FiltrosSelecionados _construirCaixaFiltrosSelecionados() {
    construirChip(String rotulo, VoidCallback aoExcluir) {
      return InputChip(label: Text(rotulo), onDeleted: aoExcluir);
    }

    return FiltrosSelecionados(
      children: [
        Observer(builder: (_) {
          final chips = [
            ...controle.filtrosTemp.anos.map((ano) => construirChip(
                  ano.toString(),
                  () => controle.removerAno(ano),
                )),
            ...controle.filtrosTemp.niveis.map((nivel) => construirChip(
                  'Nível $nivel',
                  () => controle.removerNivel(nivel),
                )),
            ...controle.filtrosTemp.assuntos.map((idAssunto) => construirChip(
                  (controle.obterAssunto(idAssunto).value?.titulo).toString(),
                  () => controle.removerAssunto(idAssunto),
                )),
          ];
          return Wrap(children: chips, spacing: 8);
        })
      ],
      trailing: Observer(builder: (_) {
        return FiltroChipContador(controle.totalSelecinado.toString());
      }),
    );
  }

  Widget _construirCorpo() {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        itemCount: tipos.length,
        itemBuilder: (context, indice) {
          final tipo = tipos[indice];
          final opcoes = controle.opcoes(tipo);
          return ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: 16),
            trailing: Observer(builder: (context) {
              return FiltroChipContador(
                opcoes.length.toString(),
                primaryColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
              );
            }),
            title: Text(
              controle.tiposFiltroToString(tipo),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () => _navegar(context, tipo),
          );
        },
        separatorBuilder: (context, indice) => const Divider(),
      ),
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

  _navegar(BuildContext context, TiposFiltro tipo) {
    navegar(Widget pagina) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => pagina))
          .then((valor) {
        // O retorno da rota será diferente de `null` se o botão "APLICAR" for acionado
        // em [pagina].
        if (valor != null) controle.aplicar();
      });
    }
    switch (tipo) {
      case TiposFiltro.ano:
        navegar(FiltroAnosPage(
          filtrosSalvos: controle.filtrosSalvos,
          filtrosTemp: controle.filtrosTemp,
        ));
        break;
      case TiposFiltro.nivel:
        navegar(FiltroNiveisPage(
          filtrosSalvos: controle.filtrosSalvos,
          filtrosTemp: controle.filtrosTemp,
        ));
        break;
      case TiposFiltro.assunto:
        navegar(FiltroAssuntosPage(
          filtrosSalvos: controle.filtrosSalvos,
          filtrosTemp: controle.filtrosTemp,
        ));
        break;
    }
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

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../shared/theme/appTheme.dart';
import '../../../../shared/utils/ui_strings.dart';
import '../../../quiz/shared/models/assunto_model.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/widgets/app_barra_inferior_filtro.dart';
import '../../shared/widgets/expansion_tile_personalizado.dart';
import '../../shared/widgets/filtro_appbar.dart';
import '../../shared/widgets/filtro_chip_contador.dart';
import '../../shared/widgets/filtro_listtile.dart';
import '../../shared/widgets/filtros_selecionados.dart';
import 'filtro_assuntos_controller.dart';

/// Página onde são listados os assuntos disponíveis para filtragem.
class FiltroAssuntosPage extends StatelessWidget {
  FiltroAssuntosPage({
    Key? key,
    required Filtros filtrosSalvos,
    required Filtros filtrosTemp,
  })  : controle = FiltroAssuntosController(
          filtrosSalvos: filtrosSalvos,
          filtrosTemp: filtrosTemp,
        ),
        super(key: key);

  final FiltroAssuntosController controle;

  ThemeData get tema => AppTheme.instance.light;

  Color get backgroundColor => tema.primaryColor.withOpacity(0.07);

  Color get textColor => Colors.black.withOpacity(0.8);

  /// Exibe um [InputChip] para cada filtro selecionado.
  FiltrosSelecionados _construirCaixaFiltrosSelecionados() {
    return FiltrosSelecionados(
      child: Observer(builder: (_) {
        final chips = controle.selecionados.map((id) {
          return InputChip(
            label: Text(controle.obterAssunto(id).value?.titulo ?? ''),
            onDeleted: () => controle.remover(id),
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
      future: controle.assuntos,
      builder: (_, AsyncSnapshot<List<Assunto>> snapshot) {
        if (snapshot.hasError) {
          return const Expanded(
            child: Center(
              child: Text(UIStrings.APP_MSG_ERRO_INESPERADO),
            ),
          );
        }
        if (snapshot.hasData) {
          final assuntos = snapshot.data ?? [];
          if (assuntos.isEmpty) {
            return const Expanded(
              child: Center(
                child: Text('Não há opções disponíveis'),
              ),
            );
          }
          return Expanded(
            child: ListView.separated(
              itemCount: controle.unidades.length,
              itemBuilder: (_, indice) {
                final unidades = controle.unidades
                  ..ordenarDesconsiderandoAcentos();
                final unidade = unidades[indice];
                return _construirOpcaoUnidade(unidade);
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

  /// Retorna um componente expansivo para a [unidade] fornecida contendo todos as
  /// opções de assunto para essa [unidade].
  /// Para cada unidade, exibe um [ExpansionTile] com os respectivos assuntos.
  /// Se a unidade não possuir subassuntos, ela será exibida em um [ListTile].
  Widget _construirOpcaoUnidade(Assunto unidade) {
    // Lista com os componentes dos subassuntos da unidade.
    final List<Widget> subItens = _construirOpcoesSubAssuntos(unidade);

    // Título para o componente da unidade.
    final titulo = Text(
      '${unidade.titulo} '
      '${subItens.isEmpty ? "" : "(" + subItens.length.toString() + ")"}',
    );

    // O ícone à esquerda.
    final leading = subItens.isEmpty
        // Garantir o afastamento.
        ? const SizedBox(width: 24.0)
        // Usar o valor padrão.
        : null;

    final selecionado = controle.selecionado(unidade.id);

    // O ícone à direita.
    final trailing = IconButton(
      icon: Observer(builder: (_) {
        return Icon(
          Icons.check,
          color:
              selecionado.value ? tema.colorScheme.primary : tema.disabledColor,
        );
      }),
      onPressed: () => selecionado.value
          ? controle.removerUnidade(unidade)
          : controle.adicionarUnidade(unidade),
    );

    final padding = null; // const EdgeInsets.fromLTRB(16, 0, 10, 0);

    if (subItens.isEmpty) {
      return ListTile(
        contentPadding: padding,
        title: titulo,
        leading: leading,
        trailing: trailing,
        onTap: () => selecionado.value
            ? controle.removerUnidade(unidade)
            : controle.adicionarUnidade(unidade),
      );
    } else {
      return ExpansionTilePersonalizado(
        tilePadding: padding,
        childrenPadding: padding,
        leading: leading,
        trailing: trailing,
        title: titulo,
        children: subItens,
        //textColor: textColor,
        collapsedTextColor: textColor,
        //iconColor: textColor,
        collapsedIconColor: textColor,
        backgroundColor: backgroundColor,
      );
    }
  }

  /// Retorna uma lista com um [ListTile] para cada assundo na hierarquia de [unidade].
  List<Widget> _construirOpcoesSubAssuntos(Assunto unidade) {
    final subAssuntos = controle.subAssuntos(unidade)
      ..ordenarDesconsiderandoAcentos();
    return subAssuntos.map((assunto) {
      final selecionado = controle.selecionado(assunto.id);
      return Observer(builder: (_) {
        return FiltroListTile(
          titulo: assunto.titulo,
          selecionado: selecionado.value,
          onTap: () => selecionado.value
              ? controle.removerAssunto(assunto.id, unidade)
              : controle.adicionarAssunto(assunto.id, unidade),
        );
      });
    }).toList();
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

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'filtro_appbar.dart';
import 'filtro_chip_contador.dart';
import 'filtros_selecionados.dart';
import '../models/filtro_controller_model.dart';
import '../models/filtros_model.dart';
import '../utils/strings_interface.dart';
import '../../../../shared/widgets/botao_primario.dart';

///O [Widget] usado como modelo nas páginas de filtro.
///Contém uma barra superior, outra inferior e o campo para exibir os filtros selecionados.
class FiltroPageModel extends StatelessWidget {
  const FiltroPageModel({
    Key key,
    @required this.controller,
    @required this.body, 
    this.tipo,
  }) : super(key: key);

  ///Se `null`, indica que este widget foi chamado pela página [FiltroTiposPage], nos demais 
  ///casos, indica que este widget foi chamado pela página [FiltroOpcoesPage].
  final TiposFiltro tipo;

  ///Pode ser um [FiltroController] ou um [FiltroOpcoesController].
  final FiltroController controller;

  ///O conteúdo da página.
  final Widget body;

  ///Valor exibido no contador de filtros selecionados.
  int get totalSelecionados => controller.totalSelecinado;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      appBar: FiltroAppBar(controller.tituloAppBar),
      body: Column(children: [
        ///Exibe um `InputChip` para cada filtro selecionado.
        FiltrosSelecionados(
          children: [
            Observer(builder: (_) {
              List<Widget> chips = [];
              controller.allFilters.forEach((_tipo, opcoes) {
                if (tipo == null || tipo == _tipo)
                  opcoes.forEach( 
                    ///O [TiposFiltro] passado no parâmetro deve ser [_tipo], pois 
                    ///[tipo] pode ser nulo.
                    (element) => chips.add(
                      InputChip(
                        label: Text(element.opcao.toString()), 
                        onDeleted: () => element.changeIsSelected(controller.filtrosTemp)
                      )
                    )
                  );
              });
              return Wrap(children: chips, spacing: 8);
            })
          ],
          trailing: Observer(builder: (_) {
            return FiltroChipContador(totalSelecionados.toString());
          }),
        ),
        body
      ]),
      bottomNavigationBar: _gerarBottomBar(tema),
    );
  }

  ///Barra de botões na parte inferior da página de filtros.
  BottomAppBar _gerarBottomBar(ThemeData tema) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(child: Observer(builder: (_) {
              return OutlinedButton(
                child: const Text(FILTRO_TEXTO_BOTAO_LIMPAR),
                onPressed: controller.ativarLimpar ? controller.limpar : null,
              );
            })),
            const SizedBox(width: 10),
            Expanded(child: Observer(builder: (_) {
              return BotaoPrimario(
                label: FILTRO_TEXTO_BOTAO_APLICAR,
                onPressed: controller.ativarAplicar ? controller.aplicar : null
              );
            }))
          ]
        ),
      ),
    );
  }
}
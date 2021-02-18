import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'filtro_tipos_controller.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/widgets/filtro_chip_contador.dart';
import '../../shared/widgets/filtro_page_model.dart';

///Esta é a página onde são listadas os tipos de filtro disponíveis: ano, assunto, nível, etc.
class FiltroTiposPage extends StatefulWidget {
  @override
  _FiltroTiposPageState createState() => _FiltroTiposPageState();
}

///[ModularState] irá criar um [controller] a partir de um [Bind] do tipo 
///[FiltroTiposController] disponível em um dos módulos da hierarquia (quando houver mais de 
///um). A vantagem de usar [ModularState] é que automáticamente será feito o `dispose` de 
///[controller] junto com o de [_FiltroTiposPageState].
class _FiltroTiposPageState extends ModularState<FiltroTiposPage, FiltroTiposController> {
  
  List<TiposFiltro> get tipos => controller.tiposFiltroInOrder;
  
  @override
  Widget build(BuildContext context) {
    return FiltroPageModel(
      controller: controller,
      body: Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          itemCount: tipos.length,
          itemBuilder: (context, indice) {
            final opcoes = controller.filtrosTemp.allFilters[tipos[indice]];
            return ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 16),
              trailing: Observer(builder: (_) {
                return FiltroChipContador(
                  opcoes.length.toString(), 
                  primaryColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
                );
              }),
              title: Text(
                controller.tiposFiltroToString(tipos[indice]),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () => controller.onTap(tipos[indice]),
            );
          },
          separatorBuilder: (context, indice) => const Divider(),
        )
      )
    );
  }
}

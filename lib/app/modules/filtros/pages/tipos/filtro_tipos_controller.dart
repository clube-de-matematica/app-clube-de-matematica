import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../navigation.dart';
import '../../shared/models/filtro_controller_model.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/utils/ui_strings.dart';
import '../opcoes/filtro_opcoes_page.dart';

part 'filtro_tipos_controller.g.dart';

class FiltroTiposController = _FiltroTiposControllerBase
    with _$FiltroTiposController;

abstract class _FiltroTiposControllerBase extends FiltroController with Store {
  final Filtros _filtrosAplicados;
  final Filtros filtrosTemp;

  _FiltroTiposControllerBase({
    required Filtros filtrosAplicados,
    required this.filtrosTemp,
  })  : _filtrosAplicados = filtrosAplicados,
        super(
          filtrosAplicados: filtrosAplicados,
          filtrosTemp: filtrosTemp,
        );

  ///Ação a ser executada quando um item da lista de tipos é pressionado.
  void onTap(BuildContext context, TiposFiltro tipo) async {
    ///Se o retorno de `pushNamed` for `true`, significa que o botão "Aplicar" da página de
    ///opções de filtro foi pressionado.
    /* final retorno = (await Modular.to.pushNamed<bool>(
            FiltrosModule.kAbsoluteRouteFiltroOpcoesPage,
            arguments: tipo)) ??
        false;
    if (retorno) Modular.to.pop(true); */
    // A nova página fará as devidas alterações nos filtros passados no parâmetro. 
    // Essa rota retornará verdadeito apenas se a ação de aplicar os filtros for acionada.
    final Filtros? retorno = (await Navegacao.abrirPagina<Filtros>(
          context,
          RotaPagina.filtrosOpcoes,
          argumentos: ArgumentosFiltroOpcoesPage(
            tipo: tipo,
            filtrosAplicados: _filtrosAplicados,
            filtrosTemp: filtrosTemp,
          ),
        ));
    if (retorno != null) Modular.to.pop(retorno);
  }

  @override

  ///Retorna o título usado na `AppBar` da página de tipos de filtro.
  String get tituloAppBar => UIStrings.FILTRO_TIPOS_TEXTO_APPBAR;

  @override
  @computed

  ///Retorna a quantidade total de opções de filtro selecionadas.
  int get totalSelecinado => filtrosTemp.totalSelecinado;

  @override
  @computed

  ///Verifica se o estado do botão "Limpar" deve ser ativo.
  ///Retorna `true` se houver filtros selecionados.
  bool get ativarLimpar => totalSelecinado > 0;

  @override
  @action

  void limpar() {
    ///`toList()` é usado para criar outro `Iterable` que não será afetado quando `opcao`
    ///for removodo de `element`, evitando que o `forEach` emita um erro de interação.
    allFilters.values.toList().forEach((element) {
      element.toList().forEach((opcao) {
        opcao.changeIsSelected(filtrosTemp, forcRemove: true);
      });
    });
  }
}

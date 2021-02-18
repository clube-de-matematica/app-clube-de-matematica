import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../shared/models/filtro_controller_model.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/utils/rotas_filtros.dart';
import '../../shared/utils/strings_interface.dart';

part 'filtro_tipos_controller.g.dart';

class FiltroTiposController = _FiltroTiposControllerBase with _$FiltroTiposController;

abstract class _FiltroTiposControllerBase extends FiltroController with Store {
  //final Filtros _filtrosAplicados;
  final Filtros filtrosTemp;

  _FiltroTiposControllerBase({
    @required Filtros filtrosAplicados, 
    @required this.filtrosTemp})
    : super(
      filtrosAplicados: filtrosAplicados, 
      filtrosTemp: filtrosTemp);

  ///Ação a ser executada quando um item da lista de tipos é pressionado.
  void onTap(TiposFiltro tipo) async {
    ///Se o retorno de `pushNamed` for `true`, significa que o botão "Aplicar" da página de 
    ///opções de filtro foi pressionado.
    final retorno = (await Modular.link.pushNamed<bool>(
      ROTA_PAGINA_FILTROS_OPCOES,
      arguments: tipo
    )) ?? false;
    if (retorno) Modular.to.pop(true);
  }

  @override
  ///Retorna o título usado na `AppBar` da página de tipos de filtro.
  String get tituloAppBar => FILTRO_TIPOS_TEXTO_APPBAR;
  
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
  ///Limpa os filtros selecionados.
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
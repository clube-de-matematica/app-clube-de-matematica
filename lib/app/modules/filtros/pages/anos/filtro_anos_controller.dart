import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../services/db_servicos_interface.dart';
import '../../shared/models/filtro_controller_model.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/utils/ui_strings.dart';

part 'filtro_anos_controller.g.dart';

class FiltroAnosController = _FiltroAnosControllerBase
    with _$FiltroAnosController;

abstract class _FiltroAnosControllerBase extends FiltroController with Store {
  _FiltroAnosControllerBase({
    required Filtros filtrosSalvos,
    required Filtros filtrosTemp,
  }) : super(
          filtrosSalvos: filtrosSalvos,
          filtrosTemp: filtrosTemp,
        );

  @override
  String get tituloAppBar => UIStrings.FILTRO_TEXTO_TIPO_ANO;

  @override
  @computed
  int get totalSelecinado => selecionados.length;

  @override
  @computed
  bool get ativarLimpar => totalSelecinado > 0;

  @override
  void limpar() => filtrosTemp.limpar(TiposFiltro.ano);

  /// Lista com todos os anos disponíveis.
  Future<List<int>> get anos {
    return Modular.get<IDbServicos>().filtrarAnos(
      assuntos: filtrosTemp.assuntos,
      niveis: filtrosTemp.niveis,
    );
  }

  void alterarSelecao(int ano) {
    _selecionado(ano) ? remover(ano) : adicionar(ano);
  }

  bool _selecionado(int ano) => selecionados.contains(ano);

  /// Conjunto com todas os anos selecionados.
  @computed
  ObservableSet<int> get selecionados => filtrosTemp.anos;

  void adicionar(int ano) => filtrosTemp.anos.add(ano);

  void remover(int ano) => filtrosTemp.anos.remove(ano);
}

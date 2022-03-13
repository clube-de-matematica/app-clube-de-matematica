import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../services/db_servicos_interface.dart';
import '../../shared/models/filtro_controller_model.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/utils/ui_strings.dart';

part 'filtro_niveis_controller.g.dart';

class FiltroNiveisController = _FiltroNiveisControllerBase
    with _$FiltroNiveisController;

abstract class _FiltroNiveisControllerBase extends FiltroController with Store {
  _FiltroNiveisControllerBase({
    required Filtros filtrosSalvos,
    required Filtros filtrosTemp,
  }) : super(
          filtrosSalvos: filtrosSalvos,
          filtrosTemp: filtrosTemp,
        );

  @override
  String get tituloAppBar => UIStrings.FILTRO_TEXTO_TIPO_NIVEL;

  @override
  @computed
  int get totalSelecinado => selecionados.length;

  @override
  @computed
  bool get ativarLimpar => totalSelecinado > 0;

  @override
  void limpar() => filtrosTemp.limpar(TiposFiltro.nivel);

  /// Lista com todos os níneis disponíveis.
  Future<List<int>> get niveis {
    return Modular.get<IDbServicos>().filtrarNiveis(
      assuntos: filtrosTemp.assuntos,
      anos: filtrosTemp.anos,
    );
  }

  void alterarSelecao(int nivel) {
    _selecionado(nivel) ? remover(nivel) : adicionar(nivel);
  }

  bool _selecionado(int nivel) => selecionados.contains(nivel);

  /// Conjunto com todas os níveis selecionados.
  @computed
  ObservableSet<int> get selecionados => filtrosTemp.niveis;

  void adicionar(int nivel) => filtrosTemp.niveis.add(nivel);

  void remover(int nivel) => filtrosTemp.niveis.remove(nivel);
}

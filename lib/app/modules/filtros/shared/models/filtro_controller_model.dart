import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../utils/ui_strings.dart';
import 'filtros_model.dart';

part 'filtro_controller_model.g.dart';

/// A superclasse para os controles das páginas de filtro.
abstract class FiltroController = _FiltroControllerBase with _$FiltroController;

abstract class _FiltroControllerBase with Store {
  final Filtros filtrosSalvos;
  final Filtros filtrosTemp;

  _FiltroControllerBase(
      {required Filtros filtrosSalvos, required this.filtrosTemp})
      : this.filtrosSalvos = filtrosSalvos;

  /// Retorna o título usado na `AppBar` das páginas de filtro.
  String get tituloAppBar;

  /// Retorna a quantidade total de opções de filtro selecionadas.
  int get totalSelecinado;

  /// Verifica se o estado do botão "Limpar" deve ser ativo.
  /// Retorna `true` se houver filtros selecionados.
  bool get ativarLimpar;

  /// Verifica se o estado do botão "Aplicar" deve ser ativo.
  /// Retorna `true` se houver alteração nos filtros já aplicados.
  bool get ativarAplicar {
    if (!setEquals(filtrosTemp.anos, filtrosSalvos.anos) ||
        !setEquals(filtrosTemp.niveis, filtrosSalvos.niveis) ||
        !setEquals(filtrosTemp.assuntos, filtrosSalvos.assuntos)) {
      return true;
    }
    return false;
  }

  /// Limpa os filtros selecionados.
  void limpar();

  /// Aplica os filtros selecionados.
  @action
  void aplicar() {
    filtrosSalvos.aplicar(filtrosTemp);
    Modular.to.pop(filtrosSalvos);
  }

  /// Retorna a string correspondente a [tipoFiltro].
  String tiposFiltroToString(TiposFiltro tipoFiltro) {
    switch (tipoFiltro) {
      case TiposFiltro.assunto:
        return UIStrings.FILTRO_TEXTO_TIPO_ASSUNTO;
      case TiposFiltro.nivel:
        return UIStrings.FILTRO_TEXTO_TIPO_NIVEL;
      case TiposFiltro.ano:
        return UIStrings.FILTRO_TEXTO_TIPO_ANO;
      //default: return null;
    }
  }
}

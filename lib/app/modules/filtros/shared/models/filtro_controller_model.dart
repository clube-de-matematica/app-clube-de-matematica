import 'package:diacritic/diacritic.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../utils/strings_interface.dart';
import 'filtros_model.dart';
import 'opcao_filtro_model.dart';

part 'filtro_controller_model.g.dart';

///A superclasse para os controles das páginas de filtro.
abstract class FiltroController = _FiltroControllerBase with _$FiltroController;

abstract class _FiltroControllerBase with Store {
  final Filtros _filtrosAplicados;
  final Filtros filtrosTemp;

  _FiltroControllerBase(
      {required Filtros filtrosAplicados, required this.filtrosTemp})
      : this._filtrosAplicados = filtrosAplicados;

  ///***************************************************************************************
  ///Devem ser sobrescritos:
  ///
  ///Retorna a quantidade total de opções de filtro selecionadas.
  int get totalSelecinado;

  ///Verifica se o estado do botão "Limpar" deve ser ativo.
  ///Retorna `true` se houver filtros selecionados.
  bool get ativarLimpar;

  ///Retorna o título usado na `AppBar` das páginas de filtro.
  String get tituloAppBar;

  ///Limpa os filtros selecionados.
  void limpar();

  ///
  ///***************************************************************************************

  @computed

  ///Retorna um [Map] com todos os filtros selecionados, inclusive os que ainda não foram
  ///aplicados.
  Map<TiposFiltro, Set<OpcaoFiltro>> get allFilters => filtrosTemp.allFilters;

  @computed

  ///Verifica se o estado do botão "Aplicar" deve ser ativo.
  ///Retorna `true` se houver alteração nos filtros já aplicados.
  bool get ativarAplicar {
    for (TiposFiltro key in allFilters.keys) {
      if ((allFilters[key]!.isNotEmpty ||
              _filtrosAplicados.allFilters[key]!.isNotEmpty) &&
          allFilters[key]!.union(_filtrosAplicados.allFilters[key]!).length !=
              allFilters[key]!
                  .intersection(_filtrosAplicados.allFilters[key]!)
                  .length) return true;
    }
    return false;
  }

  ///Retorna a string correspondente a [tipoFiltro].
  String tiposFiltroToString(TiposFiltro tipoFiltro) {
    switch (tipoFiltro) {
      case TiposFiltro.assunto:
        return FILTRO_TEXTO_TIPO_ASSUNTO;
      case TiposFiltro.nivel:
        return FILTRO_TEXTO_TIPO_NIVEL;
      case TiposFiltro.dificuldade:
        return FILTRO_TEXTO_TIPO_DIFICULDADE;
      case TiposFiltro.ano:
        return FILTRO_TEXTO_TIPO_ANO;
      //default: return null;
    }
  }

  ///Retorna uma lista com os valores de [TiposFiltro] classificados em ordem alfabética
  ///de acordo com a string retornada por [tiposFiltroToString].
  List<TiposFiltro> get tiposFiltroInOrder {
    final tipos = List<TiposFiltro>.from(TiposFiltro.values)

      ///Reordenar.
      ///`removeDiacritics` é usado para desconsiderar os acentos.
      ..sort((a, b) => removeDiacritics(tiposFiltroToString(a))
          .compareTo(removeDiacritics(tiposFiltroToString(b))));
    return tipos;
  }

  @action

  ///Aplica os filtros selecionados.
  void aplicar() {
    _filtrosAplicados.aplicar(filtrosTemp);
    Modular.to.pop(true);
  }

/* 
  @computed
  ///Itens Filtrados.
  ///Usa o conectivo "ou" para filtros do mesmo tipo, e o conectivo "e" para tipos diferentes.
  ///Posteriormente deve utilizar uma consulta ofline no Firebase Firestore.
  List<Item> get itensFiltrados {
    ///A aplicação do filtro é feita na ordem de maior restrição a longo prazo.
    ///Por exemplo, conforme o banco de dados cresce, filtrar por ano já eliminará a maior 
    ///parte dos itens. Isso gera um ganho de desempenho.
    List<Item> temp = List<Item>();
    List<Item> ref = temp.isNotEmpty ? temp : itens;

    if (_filtrosAplicados.anos.isNotEmpty) temp.addAll(
      ref.where((item) => _filtrosAplicados.anos.any(
          (element) => item.ano == element.opcao))
    );

    if (_filtrosAplicados.niveis.isNotEmpty) temp.addAll(
      ref.where((item) => _filtrosAplicados.niveis.any(
          (element) => item.nivel == element.opcao))
    );

    if (_filtrosAplicados.assuntos.isNotEmpty) temp.addAll(
      ref.where((item) => _filtrosAplicados.assuntos.any(
          (element) => item.assuntos.contains(element.opcao)))
    );

    if (_filtrosAplicados.dificuldades.isNotEmpty) temp.addAll(
      ref.where((item) => _filtrosAplicados.dificuldades.any(
          (element) => item.dificuldade == element.opcao))
    );

    return temp;
  }
 */
}

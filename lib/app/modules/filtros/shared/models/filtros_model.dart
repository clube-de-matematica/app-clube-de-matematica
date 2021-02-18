import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'opcao_filtro_model.dart';
import '../../../quiz/shared/models/item_model.dart';
import '../../../quiz/shared/repositories/itens_repository.dart';

part 'filtros_model.g.dart';

///Os tipos de filtro disponíneis são: [ano], [nivel], [assunto], [dificuldade].
enum TiposFiltro{ano, nivel, assunto, dificuldade}

///Contém os filtros.
class Filtros = _FiltrosBase with _$Filtros;

abstract class _FiltrosBase with Store {
  _FiltrosBase();
  
  ///Cria uma nova instância com base em [other].
  _FiltrosBase.from(Filtros other) {
    assuntos.addAll(other.assuntos);
    anos.addAll(other.anos);
    niveis.addAll(other.niveis);
    dificuldades.addAll(other.dificuldades);
  }

  @observable
  ///Assuntos filtrados.
  ObservableSet<OpcaoFiltro> assuntos = Set<OpcaoFiltro>().asObservable();

  @observable
  ///Anos filtrados.
  ObservableSet<OpcaoFiltro> anos = Set<OpcaoFiltro>().asObservable();

  @observable
  ///Níveis filtrados.
  ObservableSet<OpcaoFiltro> niveis = Set<OpcaoFiltro>().asObservable();

  @observable
  ///Níveis de dificuldade filtrados.
  ObservableSet<OpcaoFiltro> dificuldades = Set<OpcaoFiltro>().asObservable();

  @computed
  ///Contém todos os filtros selecionados.
  ///Reune [anos], [assuntos], [niveis] e [dificuldades] em um [Map] cuja `key` é um 
  ///[TiposFiltro] correspondente.
  Map<TiposFiltro,Set<OpcaoFiltro>> get allFilters => 
      Map<TiposFiltro,Set<OpcaoFiltro>>.fromEntries(
        TiposFiltro.values.map((tipo) {
          switch (tipo) {
            case TiposFiltro.ano:
              return MapEntry(tipo, anos);
            case TiposFiltro.assunto:
              return MapEntry(tipo, assuntos);
            case TiposFiltro.dificuldade:
              return MapEntry(tipo, dificuldades);
            case TiposFiltro.nivel:
              return MapEntry(tipo, niveis);
          }
        })
  );

  @computed
  ///Retorna a quantidade total de opções de filtro selecionadas.
  int get totalSelecinado {
    int contador = 0;
    for (Set<OpcaoFiltro> opcoes in allFilters.values) contador += opcoes.length;
    return contador;
  }

  @action
  ///Adiciona [opcao] ao filtro correspondente.
  void add(OpcaoFiltro opcao) {
    if (opcao != null) {
      allFilters[opcao.tipo].add(opcao);
    }
  }

  @action
  ///Remove [opcao] do filtro correspondente.
  void remove(OpcaoFiltro opcao) {
    if (opcao != null) {
      allFilters[opcao.tipo].remove(opcao);
    }
  }

  @action
  ///Atribui os valores de [anos], [assuntos], [niveis] e [dificuldades] em [other] a essa 
  ///intância.
  void aplicar(Filtros other) {
    ///`toList()` é usado para criar uma lista que não será afetada por modificações 
    ///ocorridas em `allFilters`, evitando que o `forEach` lance erros de iteração.
    allFilters.keys.toList().forEach((tipo) {
      if (allFilters[tipo].intersection(other.allFilters[tipo]) 
          != allFilters[tipo].union(other.allFilters[tipo])) {
            allFilters[tipo].clear();
            allFilters[tipo].addAll(other.allFilters[tipo]);
      }
    });
  }

  @computed
  ///Retorna uma lista com todos os itens carregados.
  List<Item> get allItens => Modular.get<ItensRepository>().itens;

  @computed
  ///Retorna uma lista com os itens resultantes da aplicação dos filtros.
  ///A condição aplicada na filtragem dos itens usa o conectivo "ou" para filtros do mesmo 
  ///tipo, e o conectivo "e" para tipos diferentes.
  List<Item> get itensFiltrados => allItens.where((item) {
    return 
      (
        anos.isEmpty ||
        anos.any((element) => item.ano == element.opcao)
      ) 
      &&
      (
        niveis.isEmpty ||
        niveis.any((element) => item.nivel == element.opcao)
      ) 
      &&
      (
        assuntos.isEmpty ||
        assuntos.any((element) => item.assuntos.contains(element.opcao)) 
      )
      &&
      (
        dificuldades.isEmpty ||
        dificuldades.any((element) => item.dificuldade == element.opcao)
      );  
  }).toList();
}
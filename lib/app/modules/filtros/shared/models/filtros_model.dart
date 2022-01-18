import 'package:mobx/mobx.dart';

import '../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../../quiz/shared/models/questao_model.dart';
import 'opcao_filtro_model.dart';

part 'filtros_model.g.dart';

/// Os tipos de filtro disponíneis são: [ano], [nivel], [assunto].
enum TiposFiltro { ano, nivel, assunto }

/// Contém os filtros.
class Filtros = _FiltrosBase with _$Filtros;

abstract class _FiltrosBase with Store {
  final QuestoesRepository questoesRepository;

  _FiltrosBase(this.questoesRepository);

  /// Cria uma nova instância com base em [other].
  // ignore: unused_element
  _FiltrosBase.from(Filtros other)
      : questoesRepository = other.questoesRepository {
    assuntos.addAll(other.assuntos);
    anos.addAll(other.anos);
    niveis.addAll(other.niveis);
  }

  /// Assuntos filtrados.
  @observable
  ObservableSet<OpcaoFiltro> assuntos = Set<OpcaoFiltro>().asObservable();

  /// Anos filtrados.
  @observable
  ObservableSet<OpcaoFiltro> anos = Set<OpcaoFiltro>().asObservable();

  /// Níveis filtrados.
  @observable
  ObservableSet<OpcaoFiltro> niveis = Set<OpcaoFiltro>().asObservable();

  /// Contém todos os filtros selecionados.
  /// Reune [anos], [assuntos] e [niveis] em um [Map] cuja `key` é um
  /// [TiposFiltro] correspondente.
  @computed
  Map<TiposFiltro, Set<OpcaoFiltro>> get allFilters =>
      Map<TiposFiltro, Set<OpcaoFiltro>>.fromEntries(
          TiposFiltro.values.map((tipo) {
        switch (tipo) {
          case TiposFiltro.ano:
            return MapEntry(tipo, anos);
          case TiposFiltro.assunto:
            return MapEntry(tipo, assuntos);
          case TiposFiltro.nivel:
            return MapEntry(tipo, niveis);
        }
      }));

  /// Retorna a quantidade total de opções de filtro selecionadas.
  @computed
  int get totalSelecinado {
    int contador = 0;
    for (Set<OpcaoFiltro> opcoes in allFilters.values)
      contador += opcoes.length;
    return contador;
  }

  /// Adiciona [opcao] ao filtro correspondente.
  /// 
  /// **ATENÇÃO:** a propriedade [opcao.isSelected] não será atualizada.
  @action
  void add(OpcaoFiltro opcao) => allFilters[opcao.tipo]!.add(opcao);

  /// Remove [opcao] do filtro correspondente.
  /// 
  /// **ATENÇÃO:** a propriedade [opcao.isSelected] não será atualizada.
  @action
  void remove(OpcaoFiltro opcao) => allFilters[opcao.tipo]!.remove(opcao);

  /// Limpa os filtros selecionados correspondentes a [tipo].
  /// Se [tipo] for `null`, todos os filtros serão excluídos.
  /// 
  /// **ATENÇÃO:** a propriedade [OpcaoFiltro.isSelected] de cada elemento do filtro não 
  /// será atualizada.
  @action
  void limpar([TiposFiltro? tipo]) {
    allFilters.forEach((_tipo, opcoes) {
      if (tipo == null || tipo == _tipo) opcoes.clear();
    });
  }

  /// Atribui os valores de [anos], [assuntos] e [niveis] em [other] a essa intância.
  @action
  void aplicar(Filtros other) {
    // `toList()` é usado para criar uma lista que não será afetada por modificações
    // ocorridas em `allFilters`, evitando que o `forEach` lance erros de iteração.
    allFilters.keys.toList().forEach((tipo) {
      if (allFilters[tipo]!.intersection(other.allFilters[tipo]!) !=
          allFilters[tipo]!.union(other.allFilters[tipo]!)) {
        allFilters[tipo]!.clear();
        allFilters[tipo]!.addAll(other.allFilters[tipo]!);
      }
    });
  }

  /// Retorna uma lista com todos os itens carregados.
  @computed
  ObservableList<Questao> get allItens => questoesRepository.questoes.toList().asObservable();

  /// Retorna uma lista com os itens resultantes da aplicação dos filtros.
  /// A condição aplicada na filtragem dos itens usa o conectivo "ou" para filtros do mesmo
  /// tipo, e o conectivo "e" para tipos diferentes.
  @computed
  List<Questao> get itensFiltrados => allItens.where((item) {
        return (anos.isEmpty ||
                anos.any((element) => item.ano == element.opcao)) &&
            (niveis.isEmpty ||
                niveis.any((element) => item.nivel == element.opcao)) &&
            (assuntos.isEmpty ||
                assuntos
                    .any((element) => item.assuntos.contains(element.opcao)));
      }).toList();
}

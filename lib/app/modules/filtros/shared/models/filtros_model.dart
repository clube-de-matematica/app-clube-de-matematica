import 'package:mobx/mobx.dart';

part 'filtros_model.g.dart';

/// Os tipos de filtro disponíneis são: [ano], [nivel], [assunto].
enum TiposFiltro { ano, nivel, assunto }

/// Contém os filtros.
class Filtros = _FiltrosBase with _$Filtros;

abstract class _FiltrosBase with Store {
  _FiltrosBase();

  /// Cria uma nova instância com base em [other].
  // ignore: unused_element
  _FiltrosBase.from(Filtros other) {
    assuntos.addAll(other.assuntos);
    anos.addAll(other.anos);
    niveis.addAll(other.niveis);
  }

  /// Ids dos assuntos filtrados.
  final ObservableSet<int> assuntos = Set<int>().asObservable();

  /// Anos filtrados.
  final ObservableSet<int> anos = Set<int>().asObservable();

  /// Níveis filtrados.
  final ObservableSet<int> niveis = Set<int>().asObservable();

  /// Retorna a quantidade total de opções de filtro selecionadas.
  @computed
  int get totalSelecinado {
    return assuntos.length + anos.length + niveis.length;
  }

  /// Limpa os filtros selecionados correspondentes a [tipo].
  /// Se [tipo] for `null`, todos os filtros serão excluídos.
  void limpar([TiposFiltro? tipo]) {
    if (tipo == null || tipo == TiposFiltro.ano) {
      anos.clear();
    }
    if (tipo == null || tipo == TiposFiltro.assunto) {
      assuntos.clear();
    }
    if (tipo == null || tipo == TiposFiltro.nivel) {
      niveis.clear();
    }
  }

  /// Atribui os valores de [anos], [assuntos] e [niveis] em [outro] a essa intância.
  void aplicar(Filtros outro) {
    limpar();
    assuntos.addAll(outro.assuntos);
    anos.addAll(outro.anos);
    niveis.addAll(outro.niveis);
  }
}

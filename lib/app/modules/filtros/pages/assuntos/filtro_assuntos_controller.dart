import 'package:diacritic/diacritic.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../services/db_servicos.dart';
import '../../../../shared/repositories/questoes/assuntos_repository.dart';
import '../../../quiz/shared/models/assunto_model.dart';
import '../../shared/models/filtro_controller_model.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/utils/ui_strings.dart';

part 'filtro_assuntos_controller.g.dart';

class FiltroAssuntosController = _FiltroAssuntosControllerBase
    with _$FiltroAssuntosController;

abstract class _FiltroAssuntosControllerBase extends FiltroController
    with Store {
  _FiltroAssuntosControllerBase({
    required Filtros filtrosSalvos,
    required Filtros filtrosTemp,
  }) : super(
          filtrosSalvos: filtrosSalvos,
          filtrosTemp: filtrosTemp,
        );

  @override
  String get tituloAppBar => UIStrings.FILTRO_TEXTO_TIPO_ASSUNTO;

  @override
  @computed
  int get totalSelecinado => selecionados.length;

  @override
  @computed
  bool get ativarLimpar => totalSelecinado > 0;

  @override
  void limpar() => filtrosTemp.limpar(TiposFiltro.assunto);

  /// Lista com todos os assuntos (incluindo as unidades) disponíveis.
  late final _assuntos = Modular.get<DbServicos>()
      .filtrarAssuntos(
        anos: filtrosTemp.anos,
        niveis: filtrosTemp.niveis,
      )
      .asObservable();

  /// Lista com todos os assuntos disponíveis, incluindo [unidades].
  ObservableFuture<List<Assunto>> get assuntos => _assuntos;

  @computed
  List<Assunto> get unidades {
    final unidades =
        assuntos.value?.where((assunto) => assunto.isUnidade).toList();
    return unidades ?? [];
  }

  List<Assunto> subAssuntos(Assunto unidade) {
    if (!unidade.isUnidade) return [];
    final subAssuntos = assuntos.value
        ?.where((assunto) => assunto.idUnidade == unidade.id)
        .toList();
    return subAssuntos ?? [];
  }

  Observable<Assunto?> obterAssunto(int id) =>
      Modular.get<AssuntosRepository>().getSinc(id);

  /// Conjunto com todas os assuntos selecionados.
  @computed
  ObservableSet<int> get selecionados => filtrosTemp.assuntos;

  Computed<bool> selecionado(int id) {
    return Computed<bool>(() => selecionados.contains(id));
  }

  bool adicionarAssunto(int assunto, Assunto unidade) {
    if (filtrosTemp.assuntos.add(assunto)) {
      final selecionarUnidade = filtrosTemp.assuntos
          .containsAll(subAssuntos(unidade).map((e) => e.id));
      if (selecionarUnidade) {
        return filtrosTemp.assuntos.add(unidade.id);
      }
      return true;
    }
    return false;
  }

  bool removerAssunto(int assunto, Assunto unidade) {
    final unidadeSelecionada = filtrosTemp.assuntos.contains(unidade.id);
    if (unidadeSelecionada) {
      filtrosTemp.assuntos.remove(unidade.id);
    }
    return filtrosTemp.assuntos.remove(assunto);
  }

  void adicionarUnidade(Assunto unidade) {
    filtrosTemp.assuntos.addAll([
      unidade.id,
      ...subAssuntos(unidade).map((e) => e.id),
    ]);
  }

  void removerUnidade(Assunto unidade) {
    filtrosTemp.assuntos.removeAll([
      unidade.id,
      ...subAssuntos(unidade).map((e) => e.id),
    ]);
  }

  Future<bool> remover(int id) async {
    final _assuntos = await this.assuntos;
    final assunto = _assuntos.cast<Assunto?>().firstWhere(
          (e) => e!.id == id,
          orElse: () => null,
        );
    if (assunto != null) {
      if (assunto.isUnidade) {
        removerUnidade(assunto);
        return true;
      }
      final unidade = _assuntos.cast<Assunto?>().firstWhere(
            (e) => e!.id == assunto.idUnidade,
            orElse: () => null,
          );
      if (unidade != null) return removerAssunto(id, unidade);
    }
    return false;
  }
}

extension OrdenarDesconsiderandoAcentos on List<Assunto> {
  void ordenarDesconsiderandoAcentos() {
    sort((a, b) =>
        removeDiacritics(a.titulo).compareTo(removeDiacritics(b.titulo)));
  }
}

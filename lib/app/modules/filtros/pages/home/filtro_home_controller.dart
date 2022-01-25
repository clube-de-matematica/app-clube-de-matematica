import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/repositories/questoes/assuntos_repository.dart';
import '../../../quiz/shared/models/assunto_model.dart';
import '../../shared/models/filtro_controller_model.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/utils/ui_strings.dart';

part 'filtro_home_controller.g.dart';

class FiltroHomeController = _FiltroHomeControllerBase
    with _$FiltroHomeController;

abstract class _FiltroHomeControllerBase extends FiltroController with Store {
  _FiltroHomeControllerBase({
    required Filtros filtrosSalvos,
    required Filtros filtrosTemp,
  }) : super(
          filtrosSalvos: filtrosSalvos,
          filtrosTemp: filtrosTemp,
        );

  /// Retorna o título usado na `AppBar` da página de tipos de filtro.
  @override
  String get tituloAppBar => UIStrings.FILTRO_TIPOS_TEXTO_APPBAR;

  /// Conjunto com todas as opções de filtro selecionadas para [tipo].
  ObservableSet<int> opcoes(TiposFiltro tipo) {
    switch (tipo) {
      case TiposFiltro.ano:
        return filtrosTemp.anos;
      case TiposFiltro.assunto:
        return filtrosTemp.assuntos;
      case TiposFiltro.nivel:
        return filtrosTemp.niveis;
    }
  }

  /// Retorna a quantidade total de opções de filtro selecionadas.
  @override
  @computed
  int get totalSelecinado => filtrosTemp.totalSelecinado;

  /// Verifica se o estado do botão "Limpar" deve ser ativo.
  /// Retorna `true` se houver filtros selecionados.
  @override
  @computed
  bool get ativarLimpar => totalSelecinado > 0;

  @override
  void limpar() => filtrosTemp.limpar();

  void adicionarAno(int ano) => filtrosTemp.anos.add(ano);

  void adicionarAssunto(int assunto) => filtrosTemp.assuntos.add(assunto);

  void adicionarNivel(int nivel) => filtrosTemp.niveis.add(nivel);

  void removerAno(int ano) => filtrosTemp.anos.remove(ano);

  void removerAssunto(int assunto) => filtrosTemp.assuntos.remove(assunto);

  void removerNivel(int nivel) => filtrosTemp.niveis.remove(nivel);

  Observable<Assunto?> obterAssunto(int id){
   return Modular.get<AssuntosRepository>().getSinc(id);
  }
}

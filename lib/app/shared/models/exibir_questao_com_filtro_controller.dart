import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../modules/filtros/shared/models/filtros_model.dart';
import '../../modules/quiz/shared/models/questao_model.dart';
import '../../navigation.dart';
import '../repositories/questoes/imagem_questao_repository.dart';
import 'exibir_questao_controller.dart';

part 'exibir_questao_com_filtro_controller.g.dart';

/// Base do controle de páginas que exibem questões e têm a opção de filtrar.
/// * Para páginas sem a opção de filtrar, veja [ExibirQuestaoController].
class ExibirQuestaoComFiltroController = _ExibirQuestaoComFiltroControllerBase
    with _$ExibirQuestaoComFiltroController;

abstract class _ExibirQuestaoComFiltroControllerBase
    extends ExibirQuestaoController with Store implements Disposable {
  final Filtros filtros;
  final _disposers = <ReactionDisposer>[];

  _ExibirQuestaoComFiltroControllerBase({
    required ImagemQuestaoRepository imagemQuestaoRepository,
    required this.filtros,
  }) : super(imagemQuestaoRepository, filtros.questoesRepository) {
    _disposers.add(
      autorun((_) {
        definirIndice(
          questoes.isEmpty ? -1 : 0,
          forcar: true,
        );
      }),
    );
  }

  /// Encerrar as [Reaction] em execução.
  @override
  void dispose() {
    _disposers
      ..forEach((element) => element())
      ..clear();
  }

  /// Questões disponíveis para exibição.
  @computed
  @override
  List<Questao> get questoes => filtros.itensFiltrados;

  /// Ação executada para abrir a página de filtro.
  /// Retornará o objeto [Filtros] resultante.
  Future<Filtros> abrirPaginaFiltros(BuildContext context) async {
    // Usa-se `Modular.to` para caminhos literais e `Modular.link` para rotas no
    // módulo atual.
    // Se o retorno de `pushNamed` for `true`, significa que o botão "Aplicar" de uma das
    // páginas de  filtro foi pressionado.
    /* final retorno = await Modular.to
            .pushNamed<bool>(FiltrosModule.kAbsoluteRouteFiltroTiposPage) ??
        false; */
    final Filtros? retorno = await Navegacao.abrirPagina<Filtros>(
      context,
      RotaPagina.filtrosTipos,
      argumentos: filtros,
    );
    /* // Substituído pela Reaction criada no método de inicialização.
    if (retorno) {
      _setIndice(
        filtros.itensFiltrados.isEmpty ? null : 0,
        force: true,
      );
    } */
    return retorno ?? filtros;
  }

  /// Limpa os filtros selecionados.
  void limparFiltros() => filtros.limpar();
}

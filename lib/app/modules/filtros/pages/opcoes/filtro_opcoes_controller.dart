import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:mobx/mobx.dart';

import '../../../quiz/shared/models/ano_questao_model.dart';
import '../../../quiz/shared/models/assunto_model.dart';
import '../../../quiz/shared/models/questao_model.dart';
import '../../../quiz/shared/models/nivel_questao_model.dart';
import '../../shared/models/filtro_controller_model.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/models/opcao_filtro_model.dart';
import 'filtro_opcoes_page.dart';

part 'filtro_opcoes_controller.g.dart';

class FiltroOpcoesController = _FiltroOpcoesControllerBase
    with _$FiltroOpcoesController;

abstract class _FiltroOpcoesControllerBase extends FiltroController with Store {
  _FiltroOpcoesControllerBase(
      {required this.tipo,
      required Filtros filtrosAplicados,
      required Filtros filtrosTemp})
      : super(filtrosAplicados: filtrosAplicados, filtrosTemp: filtrosTemp) {
    _setAllOpcoes();
  }

  ///Se incompeto, indica que as opções ainda estão sendo carregadas.
  final _loading = Completer<bool>();

  ///Se incompeto, indica que as opções ainda estão sendo carregadas.
  Future<bool> get loading => _loading.future;

  ///O tipo de filtro exibido em [FiltroOpcoesPage].
  final TiposFiltro tipo;

  ///Se [tipo] corresponder a assunto, conterá as instâncias de [OpcaoFiltroAssuntoUnidade]
  ///disponíveis.
  ///Nos demais casos conterá as instâncias de [OpcaoFiltro] disponíveis para o [tipo].
  final List<OpcaoFiltro> allOpcoes = <OpcaoFiltro>[];

  ///Retorna um [Iterable] com os [Questao] relacionados às opções temporariamente selecionadas,
  ///excetuando-se as do tipo [tipo].
  ///A condição aplicada na filtragem dos itens usa o conectivo "ou" para filtros do mesmo
  ///tipo, e o conectivo "e" para tipos diferentes.
  Iterable<Questao> get _itensRelacionados {
    return filtrosTemp.allItens.where((item) {
      return (tipo == TiposFiltro.ano ||
              filtrosTemp.anos.isEmpty ||
              filtrosTemp.anos.any((element) => item.ano == element.opcao)) &&
          (tipo == TiposFiltro.nivel ||
              filtrosTemp.niveis.isEmpty ||
              filtrosTemp.niveis
                  .any((element) => item.nivel == element.opcao)) &&
          (tipo == TiposFiltro.assunto ||
              filtrosTemp.assuntos.isEmpty ||
              filtrosTemp.assuntos
                  .any((element) => item.assuntos.contains(element.opcao)));
    });
  }

  ///Carrega e ordena [allOpcoes] com as [OpcaoFiltro] disponíveis para [tipo].
  Future<void> _setAllOpcoes() async {
    late Iterable opcoesRelacionadas;
    switch (tipo) {
      case TiposFiltro.assunto:
        opcoesRelacionadas = Assunto.instancias

            ///Se não houver filtros selecionados a condição de filtragem é uma taltologia,
            ///portanto, não haverá restrição. Nos demais casos, a condição restringe aos
            ///assuntos que estão na lista de assuntos de algum dos itens temporariamente
            ///filtrados ou que são unidade de algum destes.
            .where((a) => filtrosTemp.totalSelecinado == 0
                ? true
                : _itensRelacionados.any((questao) => questao.assuntos
                    .any((b) => a == b || a.id == b.unidade.id)));
        break;
      case TiposFiltro.nivel:
        opcoesRelacionadas = Nivel.instancias.where((nivel) =>
            filtrosTemp.totalSelecinado == 0
                ? true
                : _itensRelacionados.any((questao) => questao.nivel == nivel));
        break;
      case TiposFiltro.ano:
        opcoesRelacionadas = Ano.instancias.where((ano) =>
            filtrosTemp.totalSelecinado == 0
                ? true
                : _itensRelacionados.any((questao) => questao.ano == ano));
        break;
    }

    if (tipo == TiposFiltro.assunto) {
      ///Adicionar as unidade que já estão no filtro.
      allOpcoes
          .addAll(allFilters[tipo]!.whereType<OpcaoFiltroAssuntoUnidade>());

      ///Adicionar as demais unidades.
      ///O operador `==` foi sobrescrito em `OpcaoFiltroAssuntoUnidade` para que a relação de
      ///igualdade ocorra da forma desejada.
      allOpcoes.addAll(opcoesRelacionadas
          .cast<Assunto>()

          ///Pegar os assuntos que são unidades e ainda não estão no filtro.
          .where((a) =>
              a.isUnidade &&

              ///`any` retorna `true` se algum elemento safisfizer o teste.
              !allFilters[tipo]!.any((b) => b.opcao == a))

          ///Criar uma `OpcaoFiltroAssuntoUnidade` para cada assunto desses.
          .map<OpcaoFiltroAssuntoUnidade>((unidade) =>
              OpcaoFiltroAssuntoUnidade(unidade)

                ///Adicionar os assuntos que já estão no filtro.
                ..assuntos.addAll(allFilters[tipo]!
                    .where((element) =>
                        unidade.id == (element.opcao as Assunto).unidade.id)
                    .cast<OpcaoFiltroAssunto>())));

      ///Adicionar os assuntos que não estão nos filtros em suas respectivas unidades.
      opcoesRelacionadas
          .cast<Assunto>()

          ///Pegar os assuntos que não são unidades e ainda não estão no filtro.
          ///`any` retorna `true` se algum elemento safisfizer o teste.
          .where((a) =>
              !a.isUnidade &&

              ///O assunto ainda não estão no filtro.
              !allFilters[tipo]!.any((b) => b.opcao == a))

          ///Adicionar cada um desses assuntos em sua respectiva unidade.
          .forEach((assunto) {
        ///Pegar a unidade correspondente ao assunto.
        allOpcoes.cast<OpcaoFiltroAssuntoUnidade>().firstWhere(
                    (element) => assunto.unidade.id == element.opcao.id)
            .assuntos
            .add(OpcaoFiltroAssunto(assunto));
      });

      ///Ordenar os subassuntos.
      ///`removeDiacritics` é usado para desconsiderar os acentos.
      allOpcoes.cast<OpcaoFiltroAssuntoUnidade>().forEach((e) {
        e.assuntos.sort((a, b) =>
            removeDiacritics(a.opcao.toString())
                .compareTo(removeDiacritics(b.opcao.toString())));
      });
    } else {
      ///Adicionar as opções que já estão no filtro.
      allOpcoes.addAll(allFilters[tipo]!.cast<OpcaoFiltro>());

      ///Adicionar as demais opções.
      allOpcoes.addAll(opcoesRelacionadas
          .where((a) => !allFilters[tipo]!.any((b) => b.opcao == a))

          ///Criar uma `OpcaoFiltro` para cada opção dessas.
          .map<OpcaoFiltro>((e) => OpcaoFiltro(e, tipo)));
    }

    ///Ordenar.
    ///`removeDiacritics` é usado para desconsiderar os acentos.
    allOpcoes.sort((a, b) => removeDiacritics(a.opcao.toString())
        .compareTo(removeDiacritics(b.opcao.toString())));
    _loading.complete(
        await Future.delayed(const Duration(seconds: 1), () => false));
  }

  ///Ação a ser executada quando um item da lista de opções é pressionado.
  ///[opcao] é a opção de filtro ao qual o item pressionado corresponde.
  void onTap(OpcaoFiltro opcao) => opcao.changeIsSelected(filtrosTemp);

  ///Ação a ser executada quando um assunto na lista de opções é pressionado.
  ///[assunto] é a opção de filtro ao qual o item pressionado corresponde.
  ///[unidade] é a unidade ao qual [assunto] pertence.
  void onTapAssunto(
      OpcaoFiltroAssunto assunto, OpcaoFiltroAssuntoUnidade unidade) {
    onTap(assunto);
    unidade.assuntoChanged(filtrosTemp);
  }

  @override

  ///Retorna o título usado na `AppBar` da página de opções de filtro de acordo com [tipo].
  String get tituloAppBar => tiposFiltroToString(tipo);

  @override
  @computed

  ///Sobrescreve `totalSelecinado` de [FiltroController] para retorna apenas a
  ///quantidade de opções de filtro selecionadas para [tipo].
  int get totalSelecinado => allFilters[tipo]!.length;

  @override
  @computed

  ///Verifica se o estado do botão "Limpar" deve ser ativo.
  ///Sobrescreve `ativarLimpar` de [FiltroController] para retorna `true` apenas se houver
  ///opcões selecionadas correspondentes a [tipo].
  bool get ativarLimpar => allFilters[tipo]!.isNotEmpty;

  @override

  ///Limpa os filtros temporariamente selecionados.
  void limpar() {
    ///`toList()` é usado para criar outro `Iterable` que não será afetado quando `opcao`
    ///for removodo de `allFilters[tipo]`, evitando que o `forEach` emita um erro de iteração.
    allFilters[tipo]!.toList().forEach((opcao) {
      opcao.changeIsSelected(filtrosTemp, forcRemove: true);
    });
  }
}

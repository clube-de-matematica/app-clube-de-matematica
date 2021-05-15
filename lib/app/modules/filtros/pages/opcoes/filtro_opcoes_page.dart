import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/theme/tema.dart';
import '../../../../shared/utils/string_interface.dart';
import '../../shared/models/filtros_model.dart';
import '../../shared/models/opcao_filtro_model.dart';
import '../../shared/widgets/expansion_tile_personalizado.dart';
import '../../shared/widgets/filtro_listtile.dart';
import '../../shared/widgets/filtro_page_model.dart';
import '../tipos/filtro_tipos_controller.dart';
import 'filtro_opcoes_controller.dart';

///Esta é a página onde são listadas as opções disponíveis para cada tipo de filtro:
///ano, assunto, nível, etc.
class FiltroOpcoesPage extends StatefulWidget {
  ///O tipo de filtro que será exibido na página.
  final TiposFiltro tipo;

  const FiltroOpcoesPage(this.tipo, {Key? key}) : super(key: key);

  @override
  _FiltroOpcoesPageState createState() => _FiltroOpcoesPageState(tipo);
}

class _FiltroOpcoesPageState extends State<FiltroOpcoesPage> {
  _FiltroOpcoesPageState(TiposFiltro tipo)
      : controller = FiltroOpcoesController(
            tipo: tipo,
            filtrosAplicados: Modular.get<Filtros>(),
            filtrosTemp: Modular.get<FiltroTiposController>().filtrosTemp);

  final FiltroOpcoesController controller;

  ThemeData get tema => Modular.get<MeuTema>().temaClaro;

  Color get backgroundColor => tema.primaryColor.withOpacity(0.07);

  Color get textColor => Colors.black.withOpacity(0.8);

  ///O tipo de filtro que a página irá exibir.
  TiposFiltro get tipo => widget.tipo;

  ///A instância de [Filtros] para os filtros temporários.
  Filtros get filtrosTemp => controller.filtrosTemp;

  ///Lista com todas as opções a serem exibidadas nesta página.
  List<OpcaoFiltro> get allOpcoes => controller.allOpcoes.toList();

  @override
  Widget build(BuildContext context) {
    return FiltroPageModel(
        controller: controller,
        tipo: tipo,
        body: FutureBuilder(
            future: controller.loading,
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return const Text(APP_MSG_ERRO_INESPERADO);
              } else if (snapshot.hasData) {
                return Expanded(
                    child: ListView.separated(
                  itemCount: allOpcoes.length,
                  itemBuilder: (_, indice) {
                    final valor = allOpcoes[indice];
                    return tipo == TiposFiltro.assunto
                        ? _opcaoTipoAssunto(valor as OpcaoFiltroAssuntoUnidade)
                        : _opcaoOutrosTipos(valor);
                  },
                  separatorBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: const Divider(height: double.minPositive),
                  ),
                ));
              } else
                return Container(
                    padding: EdgeInsets.only(top: 100),
                    child: const CircularProgressIndicator());
            }));
  }

  ///Retorna um [Widget] para a [opcao] fornecida.
  Observer _opcaoOutrosTipos(OpcaoFiltro opcao) {
    return Observer(builder: (_) {
      return FiltroListTile(
        titulo: opcao.opcao.toString(),
        selecionado: opcao.isSelected,
        onTap: () => controller.onTap(opcao),
      );
    });
  }

  ///Retorna um componente expansivo para a [unidade] fornecida contendo todos as
  ///opções de assunto para essa [unidade].
  ///Para cada unidade, exibe um [ExpansionTile] com os respectivos assuntos.
  ///Se a unidade não possuir subassuntos, ela será exibida em um [ListTile].
  Widget _opcaoTipoAssunto(OpcaoFiltroAssuntoUnidade unidade) {
    ///Lista com os componentes dos subassuntos da unidade.
    final List<Widget> subItens = _gerarListTileAssuntos(unidade);

    ///Título para o componente da unidade.
    final title = Text(unidade.opcao.titulo +
        " ${subItens.isEmpty ? "" : "(" + subItens.length.toString() + ")"}");

    ///O ícone à esquerda.
    final leading = subItens.isEmpty

        ///Garantir o afastamento.
        ? const SizedBox(width: 24.0)

        ///Usar o valor padrão.
        : null;

    ///O ícone à direita.
    final trailing = IconButton(
        icon: Observer(builder: (_) {
          return Icon(Icons.check,
              color: unidade.isSelected
                  ? tema.colorScheme.primary
                  : tema.disabledColor);
        }),
        onPressed: () => controller.onTap(unidade));

    final padding = const EdgeInsets.fromLTRB(16, 0, 10, 0);

    if (subItens.isEmpty) {
      return ListTile(
        contentPadding: padding,
        title: title,
        leading: leading,
        trailing: trailing,
        onTap: () => controller.onTap(unidade),
      );
    } else {
      return ExpansionTilePersonalizado(
        tilePadding: padding,
        leading: leading,
        trailing: trailing,
        title: title,
        children: subItens,
        //textColor: textColor,
        collapsedTextColor: textColor,
        //iconColor: textColor,
        collapsedIconColor: textColor,
        backgroundColor: backgroundColor,
      );
    }
  }

  ///Retorna uma lista com um [ListTile] para cada opção de assundo em [assuntos].
  List<Widget> _gerarListTileAssuntos(OpcaoFiltroAssuntoUnidade unidade) {
    List<Widget> list = [];
    unidade.assuntos.forEach((assunto) {
      list.add(Observer(builder: (_) {
        return FiltroListTile(
            titulo: assunto.opcao.titulo,
            selecionado: assunto.isSelected,
            onTap: () => controller.onTapAssunto(assunto, unidade));
      }));
    });
    return list;
  }
}

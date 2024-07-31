import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../shared/theme/appTheme.dart';
import '../../../shared/widgets/appBottomSheet.dart';
import '../../filtros/shared/widgets/expansion_tile_personalizado.dart';
import '../../quiz/shared/models/assunto_model.dart';
import 'selecionar_assuntos_controller.dart';

/// Página onde são listados os assuntos disponíveis para filtragem.
class SelecionarAssuntosPage extends StatelessWidget {
  SelecionarAssuntosPage(
    Iterable<ArvoreAssuntos> assuntosSelecionados, {
    Key? key,
  })  : controle = SelecionarAssuntosController(assuntosSelecionados),
        super(key: key);

  final SelecionarAssuntosController controle;

  ThemeData get tema => AppTheme.instance.light;

  Color get backgroundColor => tema.primaryColor.withOpacity(0.07);

  Color get textColor => Colors.black.withOpacity(0.8);

  Widget _construirCorpo() {
    return Observer(
      builder: (_) {
        final unidades = controle.arvores..ordenarDesconsiderandoAcentos();

        if (unidades.isEmpty) {
          return Center(
            child: Text('Não há opções disponíveis'),
          );
        }

        final numUnidades = controle.arvores.length;
        return ListView.separated(
          itemCount: numUnidades + 1,
          itemBuilder: (_, indice) {
            if (indice < numUnidades) return _construirOpcao(unidades[indice]);
            return _construirWidgetNovoAssunto();
          },
          separatorBuilder: (_, __) => const Divider(),
        );
      },
    );
  }

  /// Retorna um componente expansivo para a [arvore] fornecida contendo todos as
  /// opções de assunto para essa [arvore].
  Widget _construirOpcao(ArvoreAssuntos arvore) {
    arvore.subAssuntos.ordenarDesconsiderandoAcentos();

    // Título para o componente da unidade.
    final titulo = Text(
      '${arvore.assunto.titulo} '
      '${arvore.subAssuntos.isEmpty ? "" : "(" + arvore.subAssuntos.length.toString() + ")"}',
    );

    final selecionado = controle.selecionado(arvore);

    // O ícone à direita.
    final trailing = Observer(builder: (context) {
      return IconButton(
        icon: Icon(
          Icons.check,
          color:
              selecionado.value ? tema.colorScheme.primary : tema.disabledColor,
        ),
        onPressed: () => Navigator.of(context).pop(arvore),
      );
    });

    return ExpansionTilePersonalizado(
      trailing: trailing,
      title: titulo,
      children: [
        ...arvore.subAssuntos.map((subArvore) => _construirOpcao(subArvore)),
        _construirWidgetNovoAssunto(arvore.assunto),
      ],
      //textColor: textColor,
      collapsedTextColor: textColor,
      //iconColor: textColor,
      collapsedIconColor: textColor,
      backgroundColor: backgroundColor,
    );
  }

  Padding _construirWidgetNovoAssunto([Assunto? assuntoPai]) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
      child: Builder(builder: (context) {
        bool _inserindo = false;
        String assunto = '';
        return TextField(
          //controller: textControle,
          decoration: InputDecoration(
            label: const Text('Novo'),
            suffixIcon: IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                if (_inserindo) return;
                _inserindo = true;
                final futuro = controle.inserirAssunto(assunto, assuntoPai);
                await BottomSheetCarregando(future: futuro).showModal(context);
                await futuro;
                _inserindo = false;
              },
            ),
          ),
          onChanged: (valor) => assunto = valor,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assuntos'),
      ),
      body: _construirCorpo(),
    );
  }
}

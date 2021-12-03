import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/theme/appTheme.dart';
import '../../../../shared/widgets/appBottomSheet.dart';
import '../../../../shared/widgets/scaffoldWithDrawer.dart';
import '../../shared/widgets/bottom_sheet_erro.dart';
import '../../shared/widgets/form_codigo_clube.dart';
import 'home_clubes_controller.dart';
import 'widgets/clube_card.dart';
import 'widgets/home_clubes_options_button.dart';

enum _OpcaoAdicionarClube { entrar, criar }

/// Página inicial para visualização dos clubes do usuário.
class HomeClubesPage extends StatefulWidget {
  const HomeClubesPage({Key? key}) : super(key: key);

  @override
  _HomeClubesPageState createState() => _HomeClubesPageState();
}

class _HomeClubesPageState
    extends ModularState<HomeClubesPage, HomeClubesController> {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: AppTheme.escala * 24,
      fontWeight: FontWeight.w400,
    );

    return ScaffoldWithDrawer(
      page: AppDrawerPage.clubes,
      appBar: AppBar(
        title: const Text('Clubes'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: HomeClubesOptionsButton(controller: controller),
          )
        ],
      ),
      body: Observer(builder: (_) {
        final cards = _buildCards(context);
        return ListView(
          padding: const EdgeInsets.all(4),
          children: [
            if (cards.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Você ainda não participa de nenhum clube.',
                  style: textStyle,
                ),
              ),
            for (var clube in cards) clube,
          ],
        );
      }),
      floatingActionButton: _buildBotaoAdicionar(context),
    );
  }

  Future _onParticipar(BuildContext context, String codigo) async {
    final future = controller.participar(codigo);
    await BottomSheetCarregando(future: future).showModal(context);
    final clube = await future;
    if (clube != null) {
      controller.abrirPaginaClube(context, clube);
    } else {
      await BottomSheetErroParticiparClube().showModal(context);
    }
  }

  List<Widget> _buildCards(BuildContext context) {
    return controller.clubes.map((clube) {
      return ClubeCard(
        controller: controller,
        clube: clube,
        onTap: () => controller.abrirPaginaClube(context, clube),
      );
    }).toList();
  }

  Widget _buildBotaoAdicionar(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<_OpcaoAdicionarClube>(
      child: FloatingActionButton(
        backgroundColor: theme.scaffoldBackgroundColor,
        onPressed: null,
        child: Icon(
          Icons.add,
          color: theme.primaryColor,
          size: 28.0,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<_OpcaoAdicionarClube>(
          value: _OpcaoAdicionarClube.entrar,
          child: Text('Entrar com um código'),
        ),
        PopupMenuItem<_OpcaoAdicionarClube>(
          value: _OpcaoAdicionarClube.criar,
          child: Text('Criar'),
        ),
      ],
      onSelected: (opcao) async {
        switch (opcao) {
          case _OpcaoAdicionarClube.entrar:
            await AppBottomSheet(
              isScrollControlled: true,
              content: FormCodigoClube(
                onParticipar: (codigo) => _onParticipar(context, codigo),
              ),
              builder: (context, child) {
                return Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: child,
                );
              },
            ).showModal(context);
            break;
          case _OpcaoAdicionarClube.criar:
            controller.criarClube(context);
            break;
        }
      },
    );
  }
}

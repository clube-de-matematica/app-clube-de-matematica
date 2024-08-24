import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/theme/appTheme.dart';
import '../../../../shared/widgets/appBottomSheet.dart';
import '../../../../shared/widgets/scaffoldWithDrawer.dart';
import '../../shared/models/clube.dart';
import '../../shared/widgets/bottom_sheet_erro.dart';
import '../../shared/widgets/form_codigo_clube.dart';
import 'home_clubes_controller.dart';
import 'widgets/clube_card.dart';
import 'widgets/home_clubes_options_button.dart';

enum _OpcaoAdicionarClube { entrar, criar }

/// Página inicial para visualização dos clubes do usuário.
class HomeClubesPage extends StatefulWidget {
  const HomeClubesPage({super.key});

  @override
  HomeClubesPageState createState() => HomeClubesPageState();
}

class HomeClubesPageState extends State<HomeClubesPage> {
  final controller = Modular.get<HomeClubesController>();

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
      body: RefreshIndicator(
        onRefresh: controller.sincronizarClubes,
        child: Observer(builder: (_) {
          final cards = _buildCards(context, controller.clubes);
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
      ),
      floatingActionButton: _buildBotaoAdicionar(context),
    );
  }

  List<Widget> _buildCards(BuildContext context, List<Clube> clubes) {
    return clubes.map((clube) {
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
        const PopupMenuItem<_OpcaoAdicionarClube>(
          value: _OpcaoAdicionarClube.entrar,
          child: Text('Entrar com um código'),
        ),
        const PopupMenuItem<_OpcaoAdicionarClube>(
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
                onParticipar: (codigo) async {
                  final future = controller.participar(codigo);
                  await BottomSheetCarregando(future: future)
                      .showModal(context);
                  final clube = await future;
                  if (clube != null) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      controller.abrirPaginaClube(context, clube);
                    }
                  } else {
                    if (context.mounted) {
                      await const BottomSheetErroParticiparClube()
                          .showModal(context);
                    }
                  }
                },
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

  @override
  void dispose() {
    Modular.dispose<HomeClubesController>();    
    super.dispose();
  }
}

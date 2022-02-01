import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/widgets/appBottomSheet.dart';
import '../../../../shared/widgets/scaffoldWithDrawer.dart';
import '../../shared/models/clube.dart';
import '../../shared/utils/tema_clube.dart';
import '../../shared/widgets/clube_options_button.dart';
import 'clube_controller.dart';
import 'widgets/aba_atividades_page.dart';
import 'widgets/aba_pessoas_page.dart';

/// Página para exibir o [clube].
class ClubePage extends WidgetModule {
  ClubePage(this.clube, {Key? key});

  final Clube clube;

  @override
  List<Bind<Object>> get binds => [
        Bind.singleton((i) => TemaClube(clube)),
        Bind.singleton((i) => ClubeController(clube)),
      ];

  @override
  Widget get view => _ClubePage();
}

/// Página para exibir o [clube].
class _ClubePage extends StatefulWidget {
  const _ClubePage({Key? key}) : super(key: key);

  @override
  _ClubePageState createState() => _ClubePageState();
}

class _ClubePageState extends State<_ClubePage> {
  ClubeController get controller => Modular.get<ClubeController>();
  TemaClube get temaClube => Modular.get<TemaClube>();
  Color get sobrePrimaria => temaClube.sobrePrimaria;
  Color get enfaseSobreSuperficie => temaClube.enfaseSobreSuperficie;
  Color get primaria => temaClube.primaria;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Observer(builder: (_) {
        return Theme(
          data: temaClube.tema,
          child: ScaffoldWithDrawer(
            page: AppDrawerPage.clubes,
            appBar: _buildAppBar(),
            body: TabBarView(
              children: [
                AtividadesPage(),
                PessoasPage(),
              ],
            ),
            bottomNavigationBar: _buildBarraInferior(),
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      //iconTheme: IconThemeData(color: sobrePrimaria),
      //backgroundColor: primaria,
      title: Text(
        controller.clube.nome,
        //style: TextStyle(color: sobrePrimaria),
      ),
      actions: [
        Builder(builder: (context) {
          return ClubeOptionsButton(
            clube: controller.clube,
            onSair: () async {
              final sair = controller.sair();
              await BottomSheetCarregando(future: sair)
                  .showModal<bool>(context);
              if (await sair) Navigator.pop(context);
            },
            onExcluir: () async {
              final excluir = controller.excluir();
              await BottomSheetCarregando(future: excluir)
                  .showModal<bool>(context);
              if (await excluir) Navigator.pop(context);
            },
            onEditar: () => controller.abrirPaginaEditarClube(context),
            onCompartilharCodigo: () {},
          );
        })
      ],
    );
  }

  /// Retorna a barra inferior da página.
  Widget _buildBarraInferior() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: enfaseSobreSuperficie.withOpacity(0.3),
          height: 0.0,
        ),
        TabBar(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 4.0,
              color: enfaseSobreSuperficie,
            ),
          ),
          tabs: [
            _buildTab(Icons.note_alt_outlined, 'Atividades'),
            _buildTab(Icons.people_alt_outlined, 'Pessoas'),
          ],
        ),
      ],
    );
  }

  /// Retorna um widget para o botão da aba.
  Widget _buildTab(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: enfaseSobreSuperficie,
            size: 24.0,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: enfaseSobreSuperficie),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

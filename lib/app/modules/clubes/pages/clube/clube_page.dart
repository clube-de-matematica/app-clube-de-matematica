import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../shared/widgets/scaffoldWithDrawer.dart';
import '../../shared/models/clube.dart';
import 'clube_controller.dart';
import 'widgets/aba_atividades_page.dart';
import 'widgets/aba_pessoas_page.dart';

/// Página para exibir o [clube].
class ClubePage extends InheritedWidget {
  ClubePage(Clube clube, {Key? key})
      : this.controller = ClubeController(clube),
        super(child: _ClubePage(key: key));

  final ClubeController controller;

  Color get _capa => controller.clube.capa;
  Brightness get _brightness => ThemeData.estimateBrightnessForColor(_capa);

  Color get corTextoCapa {
    return _brightness == Brightness.light ? Colors.black : Colors.white;
  }

  Color get corTexto {
    return _brightness == Brightness.light ? Colors.black : _capa;
  }

  static ClubePage of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClubePage>() as ClubePage;
  }

  @override
  bool updateShouldNotify(covariant ClubePage oldWidget) =>
      controller != oldWidget.controller;
}

/// Página para exibir o [clube].
class _ClubePage extends StatefulWidget {
  const _ClubePage({Key? key}) : super(key: key);

  @override
  _ClubePageState createState() => _ClubePageState();
}

class _ClubePageState extends State<_ClubePage> {
  ClubeController get controller => ClubePage.of(context).controller;
  Color get corTextoCapa => ClubePage.of(context).corTextoCapa;
  Color get corTexto => ClubePage.of(context).corTexto;
  Color get capa => controller.clube.capa;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Observer(builder: (_) {
        return ScaffoldWithDrawer(
          page: AppDrawerPage.clubes,
          appBar: _buildAppBar(),
          body: TabBarView(
            children: [
              AtividadesPage(),
              PessoasPage(),
            ],
          ),
          bottomNavigationBar: _buildBarraInferior(),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: corTextoCapa),
      backgroundColor: capa,
      title: Text(
        controller.clube.nome,
        style: TextStyle(color: corTextoCapa),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.more_vert),
        )
      ],
    );
  }

  /// Retorna a barra inferior da página.
  Widget _buildBarraInferior() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: corTexto.withOpacity(0.3),
          height: 0.0,
        ),
        TabBar(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 4.0,
              color: corTexto,
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
            color: corTexto,
            size: 24.0,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: corTexto),
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

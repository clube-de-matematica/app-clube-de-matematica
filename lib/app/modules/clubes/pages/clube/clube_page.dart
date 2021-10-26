import 'package:clubedematematica/app/modules/clubes/pages/clube/clube_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../shared/widgets/scaffoldWithDrawer.dart';
import '../../shared/models/clube.dart';
import 'widgets/aba_atividades_page.dart';
import 'widgets/aba_pessoas_page.dart';

/// Página para exibir o [clube].
class ClubePage extends StatefulWidget {
  const ClubePage(this.clube, {Key? key}) : super(key: key);

  final Clube clube;

  @override
  _ClubePageState createState() => _ClubePageState();
}

class _ClubePageState extends State<ClubePage> {
  late final controller = ClubeController(widget.clube);

  Brightness get brightness => ThemeData.estimateBrightnessForColor(capa);

  Color get capa => widget.clube.capa;

  Color get onCapa {
    return brightness == Brightness.light ? Colors.black : Colors.white;
  }

  Color get corTexto {
    return brightness == Brightness.light ? Colors.black : capa;
  }

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
              AtividadesPage(clube: widget.clube),
              PessoasPage(controller: controller),
            ],
          ),
          bottomNavigationBar: _buildBarraInferior(),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: onCapa),
      backgroundColor: capa,
      title: Text(
        widget.clube.nome,
        style: TextStyle(color: onCapa),
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
        Divider(color: corTexto.withOpacity(0.3)),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/theme/appTheme.dart';
import '../../../../shared/widgets/scaffoldWithDrawer.dart';
import '../../../perfil/models/userapp.dart';
import '../../shared/models/clube.dart';
import 'home_clubes_controller.dart';

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
    final theme = Theme.of(context);
    return ScaffoldWithDrawer(
      page: AppDrawerPage.clubes,
      appBar: AppBar(title: const Text('Clubes')),
      body: Observer(builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(4),
          children: [
            for (var clube in _buildCards(context)) clube,
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: Icon(
          Icons.add,
          color: theme.primaryColor,
          size: 28.0,
        ),
        onPressed: controller.addClube,
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    return controller.clubes.map((clube) {
      return ClubeCard(
        clube: clube,
        onTap: () => controller.openClubePage(context, clube),
      );
    }).toList();
  }
}

class ClubeCard extends StatelessWidget {
  const ClubeCard({Key? key, required this.clube, required this.onTap})
      : super(key: key);
  final Clube clube;
  final VoidCallback onTap;

  /// ID do usuário do aplicativo.
  int? get userId => Modular.get<UserApp>().id;

  /// Numero de integrantes do Clubes.
  int get numeroParticipantes =>
      clube.administradores.length + clube.membros.length + 1;

  TextStyle get headerTextStyle => TextStyle(
        color: AppTheme.instance.temaClaro.colorScheme.onPrimary,
        fontSize: AppTheme.escala * 26,
        fontWeight: FontWeight.w400,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 160.0),
        child: Card(
          color: clube.capa,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nome e descrição do clube.
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      header(),
                      body(),
                    ],
                  ),
                ),
                // Permissão do usuário e número de participantes.
                footer(),
              ],
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  /// Um widget com o nome do clube e um botão de opções.
  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            clube.nome,
            style: headerTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        optionsButton(),
      ],
    );
  }

  /// O botão para o menu de opções do clube.
  Widget optionsButton() {
    return PopupMenuButton<OpcoesClube>(
      child: Icon(
        Icons.more_vert,
        size: headerTextStyle.fontSize,
        color: headerTextStyle.color,
      ),
      itemBuilder: (context) => [
        for (var opcao in OpcoesClube.values)
          PopupMenuItem<OpcoesClube>(
            value: opcao,
            child: Text(opcao.textButton),
            onTap: opcao.onTap, 
          ),
      ],
    );
  }

  /// Um widget com a descrição do clube.
  Widget body() {
    final bodyTextStyle = headerTextStyle.copyWith(
      fontSize: AppTheme.escala * 14,
    );

    return Text(
      clube.descricao ?? '',
      style: bodyTextStyle,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Um widget com a permissão do usuário e o número de participantes do clube.
  Widget footer() {
    final footerTextStyle = headerTextStyle.copyWith(
      fontSize: AppTheme.escala * 12,
    );

    String permicao;

    if (userId == clube.proprietario) {
      permicao = 'Proprietário';
    } else if (clube.administradores.contains(userId)) {
      permicao = 'Administrador';
    } else {
      permicao = 'Membro';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          permicao,
          style: footerTextStyle,
        ),
        Text(
          numeroParticipantes < 2 ? '' : '$numeroParticipantes membros',
          style: footerTextStyle,
        ),
      ],
    );
  }
}

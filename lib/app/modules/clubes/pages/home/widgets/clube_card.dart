import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../shared/theme/appTheme.dart';
import '../../../../perfil/models/userapp.dart';
import '../../../shared/models/clube.dart';
import '../home_clubes_controller.dart';
import 'clube_card_options_button.dart';

class ClubeCard extends StatelessWidget {
  const ClubeCard({
    Key? key,
    required this.clube,
    required this.onTap,
    required this.controller,
  }) : super(key: key);
  final Clube clube;
  final VoidCallback onTap;
  final HomeClubesController controller;

  /// ID do usuário do aplicativo.
  int? get userId => UserApp.instance.id;

  /// Numero de integrantes do Clubes.
  int get numeroParticipantes => clube.usuarios.length;

  Brightness get brightness => ThemeData.estimateBrightnessForColor(clube.capa);

  Color get textColor {
    return brightness == Brightness.light ? Colors.black : Colors.white;
  }

  TextStyle get headerTextStyle => TextStyle(
        color: textColor,
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
                      header(context),
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
  Widget header(BuildContext context) {
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
        ClubeCardOptionsButton(
          clube: clube,
          userId: userId!,
          controller: controller,
          textStyle: headerTextStyle,
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

    String permissao;

    switch (clube.permissao(userId!)) {
      case PermissoesClube.proprietario:
        permissao = 'Proprietário';
        break;
      case PermissoesClube.administrador:
        permissao = 'Administrador';
        break;
      case PermissoesClube.membro:
        permissao = 'Membro';
        break;
      case PermissoesClube.externo:
        // Teoricamente, essa exceção nunca ocorrerá, pois a lista de clubes que o aplicativo
        // busca já está vinculada ao ID do usuário.
        throw 'Usuário sem acesso ao clube.';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            permissao,
            style: footerTextStyle,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              numeroParticipantes < 2 ? '' : '$numeroParticipantes membros',
              style: footerTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/theme/tema.dart';
import '../utils/ui_strings.dart';
import 'expansion_tile_personalizado.dart';

///Contém um [InputChip] para cada filtro selecionado.
class FiltrosSelecionados extends StatelessWidget {
  FiltrosSelecionados({Key? key, required this.children, this.trailing})
      : super(key: key);
  final Widget? trailing;
  final List<Widget> children;

  Color get textColor =>
      Modular.get<MeuTema>().temaClaro.colorScheme.onPrimary.withOpacity(0.8);

  Color get backgroundColor =>
      Modular.get<MeuTema>().temaClaro.colorScheme.primary;

  TextStyle? get textStyle => Modular.get<MeuTema>()
      .temaClaro
      .textTheme
      .bodyText1
      ?.copyWith(color: textColor);

  @override
  Widget build(BuildContext context) {
    return ExpansionTilePersonalizado(
      iconColor: textColor.withOpacity(
          textColor.opacity + 0.1 < 1.0 ? textColor.opacity + 0.1 : 1.0),
      collapsedIconColor: textColor,
      textColor: textColor.withOpacity(
          textColor.opacity + 0.1 < 1.0 ? textColor.opacity + 0.1 : 1.0),
      collapsedTextColor: textColor,
      backgroundColor: backgroundColor,
      collapsedBackgroundColor: backgroundColor,
      title: Text(
        UIStrings.FILTRO_TEXTO_SECAO_FILROS_SELECINADO,
        //style: textStyle,
      ),
      children: children,
      trailing: trailing,
      maintainState: true,
    );
  }
}

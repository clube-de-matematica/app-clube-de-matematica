import 'package:flutter/material.dart';

import '../../../../shared/theme/appTheme.dart';
import '../utils/ui_strings.dart';
import 'expansion_tile_personalizado.dart';

///Contém um [InputChip] para cada filtro selecionado.
class FiltrosSelecionados extends StatelessWidget {
  FiltrosSelecionados({Key? key, required this.child, this.trailing})
      : super(key: key);
  final Widget? trailing;
  final Widget child;

  Color get textColor =>
      AppTheme.instance.temaClaro.colorScheme.onPrimary.withOpacity(0.8);

  Color get backgroundColor => AppTheme.instance.temaClaro.colorScheme.primary;

  TextStyle? get textStyle => AppTheme.instance.temaClaro.textTheme.bodyLarge
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
      children: [
        AnimatedContainer(
          duration: kExpand,
          constraints: BoxConstraints(
              maxHeight: .4 * MediaQuery.of(context).size.height),
          child: SingleChildScrollView(child: child),
        )
      ],
      trailing: trailing,
      maintainState: true,
    );
  }
}

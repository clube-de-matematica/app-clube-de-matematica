import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../utils/ui_strings.dart';
import 'expansion_tile_personalizado.dart';

///Contém um [InputChip] para cada filtro selecionado.
class FiltrosSelecionados extends StatelessWidget {
  const FiltrosSelecionados({super.key, required this.child, this.trailing});
  final Widget? trailing;
  final Widget child;

  Color get textColor =>
      AppTheme.instance.light.colorScheme.onPrimary.withValues(alpha: 0.8);

  Color get backgroundColor => AppTheme.instance.light.colorScheme.primary;

  TextStyle? get textStyle => AppTheme.instance.light.textTheme.bodyLarge
      ?.copyWith(color: textColor);

  @override
  Widget build(BuildContext context) {
    return ExpansionTilePersonalizado(
      iconColor: textColor.withValues(alpha: 
          textColor.a + 0.1 < 1.0 ? textColor.a + 0.1 : 1.0),
      collapsedIconColor: textColor,
      textColor: textColor.withValues(alpha: 
          textColor.a + 0.1 < 1.0 ? textColor.a + 0.1 : 1.0),
      collapsedTextColor: textColor,
      backgroundColor: backgroundColor,
      collapsedBackgroundColor: backgroundColor,
      title: const Text(
        UIStrings.FILTRO_TEXTO_SECAO_FILROS_SELECINADO,
        //style: textStyle,
      ),
      trailing: trailing,
      maintainState: true,
      children: [
        AnimatedContainer(
          duration: kExpand,
          constraints: BoxConstraints(
              maxHeight: .4 * MediaQuery.of(context).size.height),
          child: SingleChildScrollView(child: child),
        )
      ],
    );
  }
}

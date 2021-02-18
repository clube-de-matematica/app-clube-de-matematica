import 'package:clubedematematica/app/shared/theme/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'expansion_tile_personalizado.dart';
import '../utils/strings_interface.dart';

///Contém um [InputChip] para cada filtro selecionado.
class FiltrosSelecionados extends StatelessWidget {
  FiltrosSelecionados({Key key, @required this.children, this.trailing})
      :assert(children != null), super(key: key);
  final Widget trailing;
  final List<Widget> children;

  Color get corTitulo => Modular.get<MeuTema>().temaClaro.colorScheme
      .onPrimary.withOpacity(0.8);

  TextStyle get textStyle => Modular.get<MeuTema>().temaClaro.textTheme.bodyText1
    .copyWith(color: corTitulo);

  @override
  Widget build(BuildContext context) {
    return ExpansionTilePersonalizado(
      corTitulo: Theme.of(context).colorScheme.primary,
      titleTextColor: corTitulo,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        FILTRO_TEXTO_SECAO_FILROS_SELECINADO, 
        //style: textStyle,
      ),
      children: children,
      trailing: trailing,
      maintainState: true,
    );
  }
}

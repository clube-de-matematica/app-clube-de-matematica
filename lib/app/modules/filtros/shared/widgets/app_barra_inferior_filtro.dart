import 'package:flutter/material.dart';

import '../../../../shared/widgets/botoes.dart';
import '../utils/ui_strings.dart';

/// Barra de botões na parte inferior das páginas de filtros.
class AppBarraInferiorFiltro extends StatelessWidget {
  const AppBarraInferiorFiltro({
    super.key,
    required this.onPressedLimpar,
    required this.onPressedAplicar,
  });

  final VoidCallback? onPressedLimpar;
  final VoidCallback? onPressedAplicar;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: FilledButton.tonal(
              onPressed: onPressedLimpar,
              child: const Text(UIStrings.FILTRO_TEXTO_BOTAO_LIMPAR),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: BotaoPrimario(
              label: UIStrings.FILTRO_TEXTO_BOTAO_APLICAR,
              onPressed: onPressedAplicar,
            ),
          )
        ],
      ),
    );
  }
}

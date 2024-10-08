import 'package:flutter/material.dart';

import 'botoes.dart';

/// Uma barra inferior com um botão para cancelar uma ação e outro para aplicar.
class BottomAppBarCancelarAplicar extends BottomAppBar {
  BottomAppBarCancelarAplicar({super.key,
    required void Function()? onCancelar,
    required void Function()? onAplicar,
  }) : super(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancelar,
                    child: const Text('CANCELAR'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BotaoPrimario(
                    label: 'APLICAR',
                    onPressed: onAplicar,
                  ),
                )
              ],
            ),
          ),
        );
}

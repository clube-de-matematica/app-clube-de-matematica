import 'package:flutter/material.dart';

import 'botao_primario.dart';

/// Uma barra inferior com um botão para cancelar uma ação e outro para aplicar.
class BottomAppBarCancelarAplicar extends BottomAppBar {
  BottomAppBarCancelarAplicar({
    Key? key,
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
                    child: const Text('CANCELAR'),
                    onPressed: onCancelar,
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

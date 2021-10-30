import 'package:flutter/material.dart';

import '../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../shared/widgets/botoes.dart';
import '../../../shared/models/clube.dart';

/// Uma página inferior para confirmar a saída de um clube.
/// Ao ser fechada, retorna `true` se o usuário confirmar que deseja sair do clube.
class BottomSheetSairClube extends BottomSheetCancelarConfirmar {
  BottomSheetSairClube(Clube clube, {Key? key})
      : super(
          key: key,
          message: 'Deseja realmente sair do clube "${clube.nome}"?',
        );
}

/// Uma página inferior para exibir o código de um clube.
class BottomSheetCodigoClube extends AppBottomSheet {
  const BottomSheetCodigoClube(this.clube, {Key? key}) : super(key: key);

  final Clube clube;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: Center(
        // Permitir a seleção do texto.
        child: SelectableText('${clube.codigo}'),
      ),
      actions: [
        TextButtonPriario(
          child: const Text('FECHAR'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

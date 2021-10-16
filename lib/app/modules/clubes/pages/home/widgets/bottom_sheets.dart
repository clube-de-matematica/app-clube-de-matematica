import 'package:flutter/material.dart';

import '../../../../../shared/widgets/appBottomSheet.dart';
import '../../../shared/models/clube.dart';

/// Uma página inferior para confirmar a saída de um clube.
/// Ao ser fechada, retorna `true` se o usuário confirmar que deseja sair do clube.
class BottomSheetSairClube extends AppBottomSheet {
  const BottomSheetSairClube(this.clube, {Key? key}) : super(key: key);

  final Clube clube;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      content: Text(
        'Deseja realmente sair do clube "${clube.nome}"?',
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          child: const Text('CANCELAR'),
          onPressed: () => Navigator.pop<bool>(context, false),
        ),
        TextButton(
          child: const Text('CONFIRMAR'),
          onPressed: () => Navigator.pop<bool>(context, true),
        ),
      ],
    );
  }
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
        TextButton(
          child: const Text('FECHAR'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

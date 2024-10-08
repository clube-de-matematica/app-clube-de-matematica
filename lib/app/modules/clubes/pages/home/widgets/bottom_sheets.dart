import 'package:flutter/material.dart';

import '../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../shared/widgets/botoes.dart';
import '../../../shared/models/clube.dart';

/// Uma página inferior para confirmar a saída de um clube.
/// Ao ser fechada, retorna `true` se o usuário confirmar que deseja sair do clube.
class BottomSheetSairClube extends BottomSheetCancelarConfirmar {
  BottomSheetSairClube(Clube clube, {super.key})
      : super(
          message: 'Deseja realmente sair do clube "${clube.nome}"?',
        );
}

/// Uma página inferior para confirmar a exclusão de um clube.
/// Ao ser fechada, retorna `true` se o usuário confirmar que deseja excluir do clube.
class BottomSheetExcluirClube extends BottomSheetCancelarConfirmar {
  BottomSheetExcluirClube(Clube clube, {super.key})
      : super(
          message: 'Deseja realmente excluir o clube "${clube.nome}"?',
        );
}

/// Uma página inferior para exibir o código de um clube.
class BottomSheetCodigoClube extends AppBottomSheet {
  const BottomSheetCodigoClube(this.clube, {super.key});

  final Clube clube;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: Center(
        // Permitir a seleção do texto.
        child: SelectableText(clube.codigo),
      ),
      actions: [
        AppTextButton(
          primary: true,
          child: const Text('FECHAR'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

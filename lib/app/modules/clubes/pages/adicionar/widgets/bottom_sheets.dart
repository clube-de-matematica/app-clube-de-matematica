import 'package:flutter/material.dart';

import '../../../../../shared/widgets/appBottomSheet.dart';

/// Uma página inferior para exibir uma mensagem de erro [mensagem].
class BottomSheetErro extends AppBottomSheet {
  const BottomSheetErro(this.mensagem, {Key? key}) : super(key: key);
  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: const Text('Falha na operação'),
      content: Text(mensagem),
      actions: [
        TextButton(
          child: const Text('FECHAR'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

/// Uma página inferior para exibir uma mensagem de erro quando o ingresso em um clube não for
/// bem sucedido.
class BottomSheetErroParticiparClube extends BottomSheetErro {
  const BottomSheetErroParticiparClube({Key? key})
      : super(
          'Verifique o código usado e se há conexão com a internet.',
          key: key,
        );
}

/// Uma página inferior para exibir uma mensagem de erro quando a criação de um clube não for
/// bem sucedido.
class BottomSheetErroCriarClube extends BottomSheetErro {
  const BottomSheetErroCriarClube({Key? key})
      : super(
          'Tente novamente.',
          key: key,
        );
}

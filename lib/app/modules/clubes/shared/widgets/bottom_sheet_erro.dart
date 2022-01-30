import 'package:flutter/material.dart';

import '../../../../shared/widgets/appBottomSheet.dart';

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
          'Verifique se há conexão com a internet e tente novamente.',
          key: key,
        );
}

/// Uma página inferior para exibir uma mensagem de erro quando a atualização dos dados de 
/// um clube não for bem sucedido.
class BottomSheetErroAtualizarClube extends BottomSheetErro {
  const BottomSheetErroAtualizarClube({Key? key})
      : super(
          'Tente novamente.',
          key: key,
        );
}

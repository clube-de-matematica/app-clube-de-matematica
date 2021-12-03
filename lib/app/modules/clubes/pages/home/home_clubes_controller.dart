import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import '../../../../navigation.dart';
import '../../shared/models/clube.dart';
import '../../shared/utils/mixin_controllers.dart';

part 'home_clubes_controller.g.dart';

/// Uma enumeração para os itens do menu de opções da página inicial dos clubes.
enum OpcoesHomeClubePage {
  atualizar,
}

extension OpcoesHomeClubePageExtension on OpcoesHomeClubePage {
  /// Retorna o texto para ser usado no item do menu de opções.
  String get textButton {
    switch (this) {
      case OpcoesHomeClubePage.atualizar:
        return 'Atualizar';
    }
  }
}

/// Uma enumeração para os itens do menu de opções dos clubes.
enum OpcoesClube {
  compartilharCodigo,
  editar,
  sair,
}

extension OpcoesClubeExtension on OpcoesClube {
  /// Retorna o texto para ser usado no item do menu de opções do clube.
  String get textButton {
    switch (this) {
      case OpcoesClube.compartilharCodigo:
        return 'Compartilhar código de acesso';
      case OpcoesClube.editar:
        return 'Editar';
      case OpcoesClube.sair:
        return 'Sair do clube';
    }
  }
}

class HomeClubesController = _HomeClubesControllerBase
    with _$HomeClubesController;

abstract class _HomeClubesControllerBase extends IClubeController
    with
        Store,
        IClubeControllerMixinSair,
        IClubeControllerMixinShowPageEditar,
        IClubeControllerMixinShowPageClube {
  /// Lista com os clubes do usuário.
  List<Clube> get clubes => repository.clubes;

  /// Abre a página para criar um clube.
  void criarClube(BuildContext context) {
    Navegacao.abrirPagina(context, RotaPagina.criarClube);
  }

  /// Atualizar a lista de clubes do usuário do aplicativo.
  Future<bool> atualizarListaDeClubes() async {
    final clubes = await repository.carregarClubes();
    return clubes.isNotEmpty;
  }

  /// Inclui o usuário atual no clube correspondente a [codigo].
  Future<Clube?> participar(String codigo) async {
    return repository.entrarClube(codigo);
  }
}

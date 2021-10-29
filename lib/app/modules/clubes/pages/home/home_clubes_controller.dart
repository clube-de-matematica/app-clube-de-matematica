import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../navigation.dart';
import '../../../perfil/models/userapp.dart';
import '../../shared/models/clube.dart';
import '../../shared/repositories/clubes_repository.dart';

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

abstract class _HomeClubesControllerBase with Store {
  ClubesRepository get repository => Modular.get<ClubesRepository>();

  /// Lista com os clubes do usuário.
  List<Clube> get clubes => repository.clubes;

  /// Usuário do aplicativo.
  UserApp get user => Modular.get<UserApp>();

  /// Abre a página para [clube].
  void openClubePage(BuildContext context, Clube clube) {
    Navigation.showPage(
      context,
      RoutePage.clube,
      routeName: '${RoutePage.homeClubes.name}/${clube.id}',
      arguments: clube,
    );
  }

  /// Criar ou participar de um clube.
  void addClube(BuildContext context) {
    Navigation.showPage(context, RoutePage.adicionarClube);
  }

  /// Abre um diálogo com o código de acesso [clube].
  void compartilharCodigo(Clube clube) {}

  /// Abre a página para editar as informações [clube].
  void editar(BuildContext context, Clube clube) {
    Navigation.showPage(context, RoutePage.editarClube, arguments: clube);
  }

  /// Sair do [clube].
  Future<bool> sair(Clube clube) async {
    return repository.sairClube(clube);
  }

  /// Atualizar a lista de clubes do usuário do aplicativo.
  Future<bool> atualizarListaDeClubes() async {
    final clubes = await repository.carregarClubes();
    return clubes.isNotEmpty;
  }
}

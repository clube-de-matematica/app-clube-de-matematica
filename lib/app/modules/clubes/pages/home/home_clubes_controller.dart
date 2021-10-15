import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../navigation.dart';
import '../../../perfil/models/userapp.dart';
import '../../shared/models/clube.dart';
import '../../shared/repositories/clubes_repository.dart';

part 'home_clubes_controller.g.dart';

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

  /// Retorna a ação a ser executada quando o item do menu de opções do clube é selecionado.
  VoidCallback get onTap {
    switch (this) {
      case OpcoesClube.compartilharCodigo:
        return () {}; // TODO
      case OpcoesClube.editar:
        return () {}; // TODO
      case OpcoesClube.sair:
        return () {}; // TODO
    }
  }
}

class HomeClubesController = _HomeClubesControllerBase
    with _$HomeClubesController;

abstract class _HomeClubesControllerBase with Store {
  /// Lista com os clubes do usuário.
  List<Clube> get clubes => Modular.get<ClubesRepository>().clubes;

  /// Usuário do aplicativo.
  UserApp get user => Modular.get<UserApp>();

  void openClubePage(BuildContext context, Clube clube) {
    /* Modular.to.pushNamed(
      '${ClubesModule.kAbsoluteRouteModule}/${clube.id}',
      arguments: clube,
    ); */
    Navigation.showPage(
      context,
      RoutePage.clube,
      routeName: '${RoutePage.homeClubes.name}/${clube.id}',
      arguments: clube,
    );
  }

  void addClube() {}
}

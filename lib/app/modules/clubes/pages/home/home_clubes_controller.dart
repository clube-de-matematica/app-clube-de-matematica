import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../navigation.dart';
import '../../../perfil/models/userapp.dart';
import '../../shared/models/clube.dart';
import '../../shared/repositories/clubes_repository.dart';

part 'home_clubes_controller.g.dart';

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

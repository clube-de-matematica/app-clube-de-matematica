import 'package:flutter/widgets.dart';

import '../../../../navigation.dart';
import '../models/clube.dart';

abstract class ClubeController {}

mixin ClubeControllerMixin on ClubeController {
  /// Abre uma página para [clube].
  abrirPaginaClube(BuildContext context, Clube clube) {
    Navigation.showPage(
      context,
      RoutePage.clube,
      routeName: '${RoutePage.homeClubes.name}/${clube.id}',
      arguments: clube,
    );
  }

  /// Faz a validação de [valor] como nome de clube.
  /// Retorna `null` se a validação for bem sucedida.
  String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'O nome não pode ser vazio';
    } else if (valor.trim().length < 5) {
      return 'O nome deve ter no mínimo 5 caracteres';
    }
  }
}

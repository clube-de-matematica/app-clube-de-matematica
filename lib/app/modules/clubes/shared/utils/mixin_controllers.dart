import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../navigation.dart';
import '../models/clube.dart';
import '../repositories/clubes_repository.dart';

/// Abstração para os controles das páginas do módulo clubes.
abstract class IClubeController {
  ClubesRepository get repository => Modular.get<ClubesRepository>();
}

mixin IClubeControllerMixinShowPageEditar on IClubeController {
  /// Abre a página para editar as informações do [clube].
  void abrirPaginaEditarClube(BuildContext context, Clube clube) {
    Navigation.showPage(context, RoutePage.editarClube, arguments: clube);
  }
}

mixin IClubeControllerMixinShowPageClube on IClubeController {
  /// Abre uma página para [clube].
  void abrirPaginaClube(BuildContext context, Clube clube) {
    Navigation.showPage(
      context,
      RoutePage.clube,
      routeName: '${RoutePage.homeClubes.name}/${clube.id}',
      arguments: clube,
    );
  }
}

mixin IClubeControllerMixinValidar on IClubeController {
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

mixin IClubeControllerMixinSair on IClubeController {
  /// Sair do [clube].
  Future<bool> sair(Clube clube) async {
    return repository.sairClube(clube);
  }
}

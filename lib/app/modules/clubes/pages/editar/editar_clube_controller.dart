
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/models/clube.dart';
import '../../shared/repositories/clubes_repository.dart';
import '../../shared/utils/mixin_controllers.dart';

class EditarClubeController extends ClubeController with ClubeControllerMixin {
  final repository = Modular.get<ClubesRepository>();

  /// Atualiza os dados do clube que foram modificados.
  Future<bool> atualizar(
    BuildContext context, {
    required Clube clube,
    required String nome,
    required String codigo,
    String? descricao,
    required Color corTema,
    required bool privado,
  }) async {
    final _clube = await repository.atualizarClube(
      clube: clube,
      nome: nome,
      codigo: codigo,
      descricao: descricao,
      capa: corTema,
      privado: privado,
    );
    if (_clube == null) return false;
    abrirPaginaClube(context, _clube);
    return true;
  }
}

import 'package:flutter/widgets.dart';

import '../../shared/models/clube.dart';
import '../../shared/utils/interface_clube_controller.dart';

class EditarClubeController extends IClubeController
    with IClubeControllerMixinValidar, IClubeControllerMixinShowPageClube {

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
    final sucesso = await repository.atualizarClube(
      clube: clube,
      nome: nome,
      codigo: codigo,
      descricao: descricao,
      capa: corTema,
      privado: privado,
    );
    return sucesso;
  }
}

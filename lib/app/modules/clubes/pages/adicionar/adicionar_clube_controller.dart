import 'package:flutter/painting.dart';

import '../../shared/models/clube.dart';
import '../../shared/utils/mixin_controllers.dart';

class AdicionarClubeController extends IClubeController
    with IClubeControllerMixinValidar, IClubeControllerMixinShowPageClube {

  /// Inclui o usuário atual no clube correspondente a [codigo].
  Future<Clube?> participar(String codigo) async {
    return repository.entrarClube(codigo);
  }

  /// Cria um clube com as informações dos parâmetros.
  Future<Clube?> criar(
    String nome,
    String? descricao,
    Color corTema,
    bool privado, {
    List<int>? administradores,
    List<int>? membros,
  }) async {
    final clube = await repository.criarClube(
      nome,
      descricao,
      '${corTema.value}',
      privado,
      administradores: administradores,
      membros: membros,
    );
    return clube;
  }
}

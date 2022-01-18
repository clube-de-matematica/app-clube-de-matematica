import 'package:flutter/painting.dart';

import '../../shared/models/clube.dart';
import '../../shared/models/usuario_clube.dart';
import '../../shared/utils/mixin_controllers.dart';

class AdicionarClubeController extends IClubeController
    with IClubeControllerMixinValidar, IClubeControllerMixinShowPageClube {
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
      RawClube(
        nome: nome,
        descricao: descricao,
        capa: corTema,
        privado: privado,
        administradores:
            administradores?.map((e) => RawUsuarioClube(id: e)).toList(),
        membros: membros?.map((e) => RawUsuarioClube(id: e)).toList(),
      ),
    );
    return clube;
  }
}

import 'package:flutter/painting.dart';

import '../../shared/models/clube.dart';
import '../../shared/models/usuario_clube.dart';
import '../../shared/utils/interface_clube_controller.dart';

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
          usuarios: [
            ...?administradores?.map((e) => RawUsuarioClube(
                  id: e,
                  permissao: PermissoesClube.administrador,
                )),
            ...?membros?.map((e) => RawUsuarioClube(
                  id: e,
                  permissao: PermissoesClube.administrador,
                )),
          ]),
    );
    return clube;
  }
}

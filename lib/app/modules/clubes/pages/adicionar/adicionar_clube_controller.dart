import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/repositories/clubes_repository.dart';
import '../../shared/utils/mixin_controllers.dart';

class AdicionarClubeController extends ClubeController with ClubeControllerMixin {
  final repository = Modular.get<ClubesRepository>();
  
  /// Inclui o usuário atual no clube correspondente a [codigo].
  Future<bool> participar(BuildContext context, String codigo) async {
    final clube = await repository.entrarClube(codigo);
    if (clube == null) return false;
    abrirPaginaClube(context, clube);
    return true;
  }

  /// Cria um clube com as informações dos parâmetros.
  Future<bool> criar(
    BuildContext context,
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
    if (clube == null) return false;
    abrirPaginaClube(context, clube);
    return true;
  }
}

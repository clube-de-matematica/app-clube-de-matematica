import 'package:clubedematematica/app/modules/clubes/shared/repositories/clubes_repository.dart';
import 'package:clubedematematica/app/modules/clubes/shared/utils/mixin_controllers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EditarClubeController extends ClubeController with ClubeControllerMixin {
  final repository = Modular.get<ClubesRepository>();

  /// Cria um clube com as informações dos parâmetros.
  Future<bool> atualizar(
    BuildContext context,
    String nome,
    String? descricao,
    Color corTema,
    bool privado, {
    List<int>? administradores,
    List<int>? membros,
  }) async {
    /* final clube = await repository.criarClube(
      nome,
      descricao,
      '${corTema.value}',
      privado,
      administradores: administradores,
      membros: membros,
    );
    if (clube == null) return false;
    abrirPaginaClube(context, clube); */
    return true;
  }
}

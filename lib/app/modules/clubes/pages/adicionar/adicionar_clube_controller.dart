import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../navigation.dart';
import '../../shared/models/clube.dart';
import '../../shared/repositories/clubes_repository.dart';
import '../../shared/utils/random_colors.dart';

class AdicionarClubeController {
  final repository = Modular.get<ClubesRepository>();
  String? nome;
  String? descricao;
  Color cor = RandomColor();
  bool privado = false;

  /// Faz a validação 
  String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'O nome não pode ser vazio';
    } else if (valor.trim().length < 5) {
      return 'O nome deve ter no mínimo 5 caracteres';
    }
  }

  /// Inclui o usuário atual no clube correspondente a [codigo].
  Future<bool> participar(BuildContext context, String codigo) async {
    final clube = await repository.entrarClube(codigo);
    if (clube == null) return false;
    _abrirPaginaClube(context, clube);
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
    _abrirPaginaClube(context, clube);
    return true;
  }

  /// Abre uma página para [clube].
  _abrirPaginaClube(BuildContext context, Clube clube) {
    Navigation.showPage(
      context,
      RoutePage.clube,
      routeName: '${RoutePage.homeClubes.name}/${clube.id}',
      arguments: clube,
    );
  }
}

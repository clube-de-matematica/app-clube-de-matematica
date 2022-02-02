import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../navigation.dart';
import '../../../../../quiz/shared/models/questao_model.dart';
import '../../../../shared/models/clube.dart';
import '../../../../shared/repositories/clubes_repository.dart';
import '../../models/atividade.dart';
import '../../pages/editar/editar_atividade_page.dart';

/// Abstração para os controles das páginas do módulo atividades.
abstract class IAtividadeController {
  IAtividadeController(this.clube);

  /// Clube vinculado à atividade.
  final Clube clube;

  ClubesRepository get repositorio => Modular.get<ClubesRepository>();
}

mixin IAtividadeControllerMixinShowPageEditar on IAtividadeController {
  /// Abre a página para editar as informações da [atividade].
  Future<bool> abrirPaginaEditarAtividade(
      BuildContext context, Atividade atividade) async {
    final retorno = await Navegacao.abrirPagina<bool>(
      context,
      RotaPagina.editarAtividade,
      argumentos: ArgumentosEditarAtividadePage(
        clube: clube,
        atividade: atividade,
      ),
    );
    return retorno ?? false;
  }
}

mixin IAtividadeControllerMixinCriarEditar on IAtividadeController {
  /// Retorna `null` se [titulo] for um título válido, caso contrário, retorna uma
  /// mensagem de erro.
  String? validarTitulo(String? titulo) {
    if (titulo?.isEmpty ?? true) return 'Insira um título';
    return null;
  }

  /// Ação executada para salvar os dados da atividade.
  Future<bool> salvar({
    String? descricao,
    DateTime? encerramento,
    required DateTime liberacao,
    required String titulo,
    List<Questao> questoes = const [],
  });
}

mixin IAtividadeControllerMixinExcluir on IAtividadeController {}

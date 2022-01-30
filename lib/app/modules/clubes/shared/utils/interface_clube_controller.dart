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
  Future<bool> abrirPaginaEditarClube(BuildContext context, Clube clube) async {
    final retorno = await Navegacao.abrirPagina<bool>(
      context,
      RotaPagina.editarClube,
      argumentos: clube,
    );
    return retorno ?? false;
  }
}

mixin IClubeControllerMixinShowPageClube on IClubeController {
  /// Abre uma página para [clube].
  void abrirPaginaClube(BuildContext context, Clube clube) {
    Navegacao.abrirPagina(
      context,
      RotaPagina.clube,
      nomeRota: '${RotaPagina.homeClubes.nome}/${clube.id}',
      argumentos: clube,
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

mixin IClubeControllerMixinSairExcluir on IClubeController {
  /// Sair do [clube].
  Future<bool> sair(Clube clube) async {
    return repository.sairClube(clube);
  }

  /// Excluir o [clube].
  Future<bool> excluir(Clube clube) async {
    return repository.excluirClube(clube);
  }
}

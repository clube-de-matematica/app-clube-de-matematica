import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import '../../../../../perfil/models/userapp.dart';
import '../../../../shared/models/clube.dart';
import '../../../../shared/models/usuario_clube.dart';
import '../../models/atividade.dart';
import '../../shared/models/interface_atividade_controller.dart';

class ConsolidarAtividadeController extends IAtividadeController
    with IAtividadeControllerMixinShowPageEditar {
  ConsolidarAtividadeController({
    required Clube clube,
    required this.atividade,
  }) : super(clube) {
    _carregarQuestoes();
  }

  final Atividade atividade;

  Future<void> _carregarQuestoes() =>
      repositorio.carregarQuestoesAtividade(atividade);

  Future<void> sincronizar() => repositorio.sincronizarClubes();

  /// Um observável com o número de questões respondidas corretamente por [membro].
  Computed<int> acertos(UsuarioClube membro) {
    return Computed(() {
      return atividade.questoes
          .where(
              (quet) => quet.resposta(membro.id)?.sequencial == quet.gabarito)
          .length;
    });
  }

  /// Um observável com o número de questões não respondidas respondidas por [membro].
  Computed<int> brancos(UsuarioClube membro) {
    return Computed(() {
      return atividade.questoes
          .where((quet) => quet.resposta(membro.id)?.sequencial == null)
          .length;
    });
  }

  /// Um observável com o número de questões respondidas incorretamente por [membro].
  Computed<int> erros(UsuarioClube membro) {
    return Computed(() {
      return atividade.questoes.length -
          acertos(membro).value -
          brancos(membro).value;
    });
  }

  /// Libera a [atividade] para os membros com a data corrente.
  Future<bool> liberarAtividade() async {
    return repositorio.atualizarAtividade(
      atividade: atividade,
      titulo: atividade.titulo,
      dataLiberacao: DateTime.now().toUtc(),
    );
  }

  /// Verdadeiro se o usuário atual tiver permissão para excluir [atividade].
  bool get podeExcluir {
    final usuario = clube.getUsuario(UserApp.instance.id!);
    if (usuario == null) return false;
    if (usuario.proprietario) return true;
    if (usuario.id == atividade.idAutor) return true;
    return false;
  }

  /// Marca [atividade] como excluída.
  Future<bool> excluirAtividade() async {
    return repositorio.excluirAtividade(atividade);
  }

  @override
  Future<bool> abrirPaginaEditarAtividade(
    BuildContext context, [
    Atividade? atividade,
  ]) async {
    final editada = await super
        .abrirPaginaEditarAtividade(context, atividade ?? this.atividade);
    if (editada) await _carregarQuestoes();
    return editada;
  }
}

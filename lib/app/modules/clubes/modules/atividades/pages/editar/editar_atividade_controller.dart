import '../../../../../quiz/shared/models/questao_model.dart';
import '../../models/atividade.dart';
import '../../shared/models/interface_atividade_controller.dart';

class EditarAtividadeController extends IAtividadeController
    with IAtividadeControllerMixinCriarEditar {
  EditarAtividadeController(super.clube, this.atividade);

  final Atividade atividade;

  @override
  Future<bool> salvar({
    String? descricao,
    DateTime? encerramento,
    required DateTime liberacao,
    required String titulo,
    List<Questao> questoes = const [],
  }) {
    if (descricao?.isEmpty ?? false) descricao = null;
    return repositorio.atualizarAtividade(
      atividade: atividade,
      titulo: titulo,
      descricao: descricao,
      questoes: questoes,
      dataLiberacao: liberacao,
      dataEncerramento: encerramento,
    );
  }
}

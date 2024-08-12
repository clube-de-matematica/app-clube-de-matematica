import '../../../../../quiz/shared/models/questao_model.dart';
import '../../shared/models/interface_atividade_controller.dart';

class CriarAtividadeController extends IAtividadeController
    with IAtividadeControllerMixinCriarEditar {
  CriarAtividadeController(super.clube);

  @override
  Future<bool> salvar({
    String? descricao,
    DateTime? encerramento,
    required DateTime liberacao,
    required String titulo,
    List<Questao> questoes = const [],
  }) {
    if (descricao?.isEmpty ?? false) descricao = null;
    return repositorio.criarAtividade(
      clube: clube,
      titulo: titulo,
      descricao: descricao,
      questoes: questoes,
      dataLiberacao: liberacao,
      dataEncerramento: encerramento,
    );
  }
}

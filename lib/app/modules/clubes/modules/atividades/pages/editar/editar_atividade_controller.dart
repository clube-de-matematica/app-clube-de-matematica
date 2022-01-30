import '../../../../../quiz/shared/models/questao_model.dart';
import '../../../../shared/models/clube.dart';
import '../../models/atividade.dart';
import '../../shared/models/criar_editar_aticidade_controler.dart';

class EditarAtividadeController extends CriarEditarAtividadeController {
  EditarAtividadeController(Clube clube, this.atividade) : super(clube);

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

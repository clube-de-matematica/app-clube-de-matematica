import '../../../../../quiz/shared/models/questao_model.dart';
import '../../../../shared/models/clube.dart';
import '../../shared/models/criar_editar_aticidade_controler.dart';

class CriarAtividadeController extends CriarEditarAtividadeController {
  CriarAtividadeController(Clube clube) : super(clube);

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

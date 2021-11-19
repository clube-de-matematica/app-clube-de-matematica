
import '../../../../../quiz/shared/models/questao_model.dart';
import '../../../../shared/models/clube.dart';
import '../../models/atividade.dart';
import '../../shared/models/criar_editar_aticidade_controler.dart';

class EditarAtividadeController extends CriarEditarAtividadeController {
  EditarAtividadeController(Clube clube) : super(clube);

  @override
  Future<Atividade?> salvar({
    String? descricao,
    DateTime? encerramento,
    required DateTime liberacao,
    required String titulo,
    List<Questao> questoes = const [],
  }) {
    if (descricao?.isEmpty ?? false) descricao = null;
   /* return _repositorio.criarAtividades(
      clube: clube,
      nome: titulo,
      descricao: descricao,
      questoes: questoes,
      dataPublicacao: liberacao,
      dataEncerramento: encerramento,
    ); */
    throw UnimplementedError();
  }
}

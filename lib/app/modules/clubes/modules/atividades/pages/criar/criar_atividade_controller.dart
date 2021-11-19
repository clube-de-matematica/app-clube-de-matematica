import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../quiz/shared/models/questao_model.dart';
import '../../../../shared/models/clube.dart';
import '../../../../shared/repositories/clubes_repository.dart';
import '../../models/atividade.dart';
import '../../shared/models/criar_editar_aticidade_controler.dart';

class CriarAtividadeController extends CriarEditarAtividadeController {
  CriarAtividadeController(this.clube);

  final Clube clube;

  ClubesRepository get _repositorio => Modular.get<ClubesRepository>();

  @override
  Future<Atividade?> salvar({
    String? descricao,
    DateTime? encerramento,
    required DateTime liberacao,
    required String titulo,
    List<Questao> questoes = const [],
  }) {
    if (descricao?.isEmpty ?? false) descricao = null;
   return _repositorio.criarAtividades(
      clube: clube,
      nome: titulo,
      descricao: descricao,
      questoes: questoes,
      dataPublicacao: liberacao,
      dataEncerramento: encerramento,
    );
  }
}

import 'dart:async';

import '../../../modules/quiz/shared/models/questao_model.dart';
import '../../../modules/quiz/shared/models/resposta_questao.dart';
import '../../../services/db_servicos_interface.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere às questões, excetuando-se os assuntos e as imágens.
class QuestoesRepository {
  final IDbServicos dbServicos;

  QuestoesRepository(this.dbServicos);

  Future<Questao?> get(String id) => dbServicos.obterQuestao(id);

  Future<int> nunQuestoes({
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
  }) {
    return dbServicos.contarQuestoes(
      anos: anos,
      niveis: niveis,
      assuntos: assuntos,
    );
  }

  Future<List<Questao>> questoes({
    Iterable<String> ids = const [],
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
    int? limit,
    int? offset,
  }) {
    return dbServicos.obterQuestoes(
      ids: ids,
      anos: anos,
      niveis: niveis,
      assuntos: assuntos,
      limit: limit,
      offset: offset,
    );
  }

  Future<bool> inserirRespostaQuestao(RawRespostaQuestao resposta) async {
    return dbServicos.salvarRespostaQuestao(resposta);
  }

  /// {@macro app.IDbServicos.obterRespostaQuestao}
  Future<RespostaQuestao?> obterResposta(Questao questao) async {
    return dbServicos.obterRespostaQuestao(questao);
  }
}

import 'dart:async';

import '../../../modules/quiz/shared/models/questao_model.dart';
import '../../../services/interface_db_servicos.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere às questões, excetuando-se os assuntos e as imágens.
class QuestoesRepository {
  final IDbServicos dbServicos;

  QuestoesRepository(this.dbServicos);

  Future<Questao?> get(String id) => dbServicos.questao(id);

  Future<int> nunQuestoes({
    List<int> anos = const [],
    List<int> niveis = const [],
    List<int> assuntos = const [],
  }) {
    return dbServicos.contarQuestoes(
      anos: anos,
      niveis: niveis,
      assuntos: assuntos,
    );
  }

  Future<List<Questao>> questoes({
    List<int> anos = const [],
    List<int> niveis = const [],
    List<int> assuntos = const [],
    int? limit,
    int? offset,
  }) {
    return dbServicos.getQuestoes(
      anos: anos,
      niveis: niveis,
      assuntos: assuntos,
      limit: limit,
      offset: offset, //TODO verificar offset maior que o número de registros
    );
  }
}
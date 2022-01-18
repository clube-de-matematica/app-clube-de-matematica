import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../modules/quiz/shared/models/questao_model.dart';
import '../../../services/interface_db_servicos.dart';
import '../../models/debug.dart';
import '../interface_db_repository.dart';
import 'assuntos_repository.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere às questões, excetuando-se os assuntos e as imágens.
class QuestoesRepository {
  final IDbServicos dbServicos;
  final AssuntosRepository assuntosRepository;

  QuestoesRepository(this.dbServicos, this.assuntosRepository) {
    carregarQuestoes().whenComplete(() {
      if (!_inicializando.isCompleted) _inicializando.complete();
    });
  }

  /// Conjunto com as quetões já carregadas.
  ObservableSet<Questao> get questoes => Questao.instancias;

  /// Um [Future] que será concluído após a primeira chamada de [carregarQuestoes].
  /// Nunca será concluído com um erro.
  Future<void> get inicializando => _inicializando.future;
  final _inicializando = Completer<void>();

  /// Conjunto assíncrono com as quetões já carregadas.
  Future<ObservableSet<Questao>> get questoesAsync async {
    await inicializando;
    return questoes;
  }

  /// Buscar as questões no banco de dados e carregar em [questoes], caso ainda não tenham
  /// sido carregadas.
  /// Retornará uma lista vazia se o usuário não estiver logado ou ocorrer algum erro ao
  /// buscar os dados.
  Future<List<Questao>> carregarQuestoes() async {
    // Aguardar o carregamento dos assuntos.
    await assuntosRepository.carregarAssuntos();

    try {
      final resultado = await dbServicos.getQuestoes();
      return resultado;
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro a buscar os dados da coleção ${CollectionType.questoes.name}."));
      assert(Debug.print(e));
      return List<Questao>.empty();
    }
  }
}

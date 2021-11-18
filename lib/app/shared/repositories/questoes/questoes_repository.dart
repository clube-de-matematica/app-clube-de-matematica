import 'dart:async';

import 'package:mobx/mobx.dart';

import '../../../modules/quiz/shared/models/questao_model.dart';
import '../../models/debug.dart';
import '../../utils/strings_db.dart';
import '../interface_db_repository.dart';
import 'assuntos_repository.dart';

part 'questoes_repository.g.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere às questões, excetuando-se os assuntos e as imágens.
class QuestoesRepository = _QuestoesRepositoryBase with _$QuestoesRepository;

abstract class _QuestoesRepositoryBase with Store {
  final IDbRepository dbRepository;
  final AssuntosRepository assuntosRepository;

  _QuestoesRepositoryBase(this.dbRepository, this.assuntosRepository) {
    carregarQuestoes().whenComplete(() {
      if (!_inicializando.isCompleted) _inicializando.complete();
    });
  }

  /// Lista com as quetões já carregadas.
  @observable
  ObservableList<Questao> _questoes = <Questao>[].asObservable();

  /// Lista com as quetões já carregadas.
  @computed
  List<Questao> get questoes => _questoes;

  /// Um [Future] que será concluído após a primeira chamada de [carregarQuestoes].
  /// Nunca será concluído com um erro.
  Future<void> get inicializando => _inicializando.future;
  final _inicializando = Completer<void>();

  /// Lista assíncrona com as quetões já carregadas.
  Future<List<Questao>> get questoesAsync => () async {
        await inicializando;
        return _questoes;
      }();

  /* 
  /// A [Reaction] `asyncWhen` é usada para esperar uma condição em um [Observable].
  /// Ficará ativa até que a condição seja satisfeita pela primeira vez.
  /// Após isso ela executa o seu método `dispose`.
  Future<List<Questao>> get questoesAsync =>
      asyncWhen((_) => _questoes.isNotEmpty).then((_) => _questoes);
   */

  /// Adiciona um novo [Questao] a [questoes].
  @action
  void _addInQuestoes(Questao questao) {
    if (!_existeQuestao(questao.id)) _questoes.add(questao);
  }

  /// Retorna `true` se um [Questao] com o mesmo [id] já tiver sido instanciado.
  /// O método `any()` executa um `for` nos elementos de [questoes].
  /// O loop é interrompido assim que a condição for verdadeira.
  bool _existeQuestao(String id) {
    if (_questoes.isEmpty)
      return false;
    else
      return _questoes.any((element) => element.id == id);
  }

  /// Assim o [Observable] notificará apenas ao final da execução do método.
  /// Buscar as questões no banco de dados e carregar na lista [questoes],
  /// caso ainda não tenham sido carregados.
  /// Retornará uma lista vazia se o usuário não estiver logado ou ocorrer algum erro ao buscar os dados.
  @action
  Future<List<Questao>> carregarQuestoes() async {
    DataCollection resultado;
    try {
      // Aguardar o retorno das questões.
      resultado = await dbRepository.getQuestoes();
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro a buscar os dados da coleção ${CollectionType.questoes.name}."));
      assert(Debug.print(e));
      return List<Questao>.empty();
    }
    if (resultado.isEmpty) return List<Questao>.empty();

    // Aguardar o carregamento dos assuntos.
    await assuntosRepository.assuntos;

    // Carregar as questões.
    // Não pode ser um `forEach`, pois precisa ser assincrono.
    for (var data in resultado) {
      if (!_existeQuestao(data[DbConst.kDbDataQuestaoKeyId])) {
        // Criar um `Questao` com base no `data` e incluir na lista de questões carregadas.
        // Não será emitido várias notificações, pois `carregarQuestoes` também é um `action`.
        _addInQuestoes(Questao.fromJson(data));
      }
    }
    return _questoes;
  }
}

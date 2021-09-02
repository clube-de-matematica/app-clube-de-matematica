import 'package:collection/collection.dart' show IterableExtension;
import 'package:mobx/mobx.dart';

import '../../../../shared/models/debug.dart';
import '../../../../shared/repositories/interface_db_repository.dart';
import '../../../../shared/utils/strings_db.dart';
import '../models/questao_model.dart';
import 'assuntos_repository.dart';

part 'questoes_repository.g.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere às questões, excetuando-se os assuntos e as imágens.
class QuestoesRepository = _QuestoesRepositoryBase with _$QuestoesRepository;

abstract class _QuestoesRepositoryBase with Store {
  final IDbRepository dbRepository;
  final AssuntosRepository assuntosRepository;

  _QuestoesRepositoryBase(this.dbRepository, this.assuntosRepository) {
    carregarQuestoes();
  }

  /// Lista com as quetões já carregadas.
  @observable
  ObservableList<Questao> _questoes = <Questao>[].asObservable();

  /// Lista com as quetões já carregadas.
  @computed
  List<Questao> get questoes => _questoes;

  /// Lista com as quetões já carregadas.
  /// A [Reaction] `asyncWhen` é usada para esperar uma condição em um [Observable].
  /// Ficará ativa até que a condição seja satisfeita pela primeira vez.
  /// Após isso ela executa o seu método `dispose`.
  Future<List<Questao>> get questoesAsync =>
      asyncWhen((_) => _questoes.isNotEmpty).then((value) => _questoes);

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

  /// Retorna um elemento de [questoes] com base em [id].
  /// Retorna `null` se não for encontrado um elemento que satisfaça `element.id == id`.
  Questao? _getQuestaoById(String id) {
    if (_questoes.isEmpty)
      return null;
    else
      return _questoes.firstWhereOrNull((element) => element.id == id);
  }

  /// Assim o [Observable] notificará apenas ao final da execução do método.
  /// Buscar as questões no banco de dados e carregar na lista [questoes],
  /// caso ainda não tenham sido carregados.
  /// Retornará uma lista vazia se o usuário não estiver logado ou ocorrer algum erro ao buscar os dados.
  @action
  Future<List<Questao>> carregarQuestoes() async {
    DataCollection resultado;
    try {
      /// Aguardar o retorno das questões.
      resultado = await dbRepository.getCollection(CollectionType.questoes);
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro a buscar os dados da coleção ${CollectionType.questoes.name}."));
      assert(Debug.print(e));
      return List<Questao>.empty();
    }
    if (resultado.isEmpty) return List<Questao>.empty();

    /// Aguardar o carregamento dos assuntos.
    await assuntosRepository.assuntos;

    /// Carregar as questões.
    /// Não pode ser um `forEach`, pois precisa ser assincrono.
    for (var data in resultado) {
      if (!_existeQuestao(data[DbConst.kDbDataQuestaoKeyId])) {
        if (data.containsKey(DbConst.kDbDataQuestaoKeyReferencia)) {
          await _carregarQuestaoReferenciada(resultado, data);
        } else {
          /// Criar um `Item` com base no `map` e incluir na lista de questões carregadas.
          /// Não será emitido várias notificações, pois `carregarItens` também é um `action`.
          _addInQuestoes(
              Questao.fromJson(data, assuntosRepository.assuntosCarregados));
        }
      }
    }
    return _questoes;
  }

  /// Assim o [Observable] notificará apenas ao final da execução do método.
  /// Carrega uma questão referenciada na lista [questoes], caso ainda não tenha sido carregada.
  @action
  Future<Questao?> _carregarQuestaoReferenciada(
    // Retorno de `get()` na coleção das questões.
    DataCollection dbQuestoesData,
    // [Map] da questão que faz a referência.
    DataDocument questaoReferenciadora,
  ) async {
    if (dbQuestoesData.isEmpty) return null;

    /// Aguardar o carregamento dos assuntos. Não haverá atraso caso já tenham sido carregados.
    final assuntos = await assuntosRepository.assuntos;
    if (assuntos.isEmpty) return null;
    
    final idRef = questaoReferenciadora[DbConst.kDbDataQuestaoKeyReferencia];

    // Retornar a questão se ela já estiver carregada.
    if (_existeQuestao(idRef)) {
      return _getQuestaoById(idRef);
    }
    // Criar e retornar a questão se ele não estiver carregada.
    else {
      /// Criar uma cópia dos dados da questão referenciada.
      final data = DataDocument.from(
        dbQuestoesData.firstWhere(
          (element) => element[DbConst.kDbDataQuestaoKeyId] == idRef,
        ),
      );

      /// Criar uma entrada para o id da questão referenciada.
      data[Questao.kKeyIdReferencia] = data[DbConst.kDbDataQuestaoKeyId];

      /// Criar uma entrada para o índice da questão referenciada.
      data[Questao.kKeyIndiceReferencia] = data[DbConst.kDbDataQuestaoKeyIndice];

      /// Criar uma entrada para o nível da questão referenciada.
      data[Questao.kKeyNivelReferencia] = data[DbConst.kDbDataQuestaoKeyNivel];

      /// Atualizar com o id da questão que referencia.
      data[DbConst.kDbDataQuestaoKeyId] =
          questaoReferenciadora[DbConst.kDbDataQuestaoKeyId];

      /// Atualizar com o índice da questão que referencia.
      data[DbConst.kDbDataQuestaoKeyIndice] =
          questaoReferenciadora[DbConst.kDbDataQuestaoKeyIndice];

      /// Atualizar com o nível da questão que referencia.
      data[DbConst.kDbDataQuestaoKeyNivel] =
          questaoReferenciadora[DbConst.kDbDataQuestaoKeyNivel];

      final _questao = Questao.fromJson(data, assuntos);
      _addInQuestoes(_questao);
      return _questao;
    }
  }
}

import 'package:collection/collection.dart' show IterableExtension;
import 'package:mobx/mobx.dart';

import '../../../../shared/models/debug.dart';
import '../../../../shared/repositories/interface_db_repository.dart';
import '../../../../shared/utils/strings_db.dart';
import '../models/item_model.dart';
import 'assuntos_repository.dart';

part 'itens_repository.g.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere aos itens, excetuando-se os assuntos e as imágens.
class ItensRepository = _ItensRepositoryBase with _$ItensRepository;

abstract class _ItensRepositoryBase with Store {
  final IDbRepository dbRepository;
  final AssuntosRepository assuntosRepository;

  _ItensRepositoryBase(this.dbRepository, this.assuntosRepository) {
    carregarItens();
  }

  /// Lista com os itens já carregados.
  @observable
  ObservableList<Item> _itens = <Item>[].asObservable();

  /// Lista com os itens já carregados.
  @computed
  List<Item> get itens => _itens;

  /// Lista com os itens já carregados.
  /// A [Reaction] `asyncWhen` é usada para esperar uma condição em um [Observable].
  /// Ficará ativa até que a condição seja satisfeita pela primeira vez.
  /// Após isso ela executa o seu método `dispose`.
  Future<List<Item>> get itensAsync =>
      asyncWhen((_) => _itens.isNotEmpty).then((value) => _itens);

  /// Adiciona um novo [Item] a [itens].
  @action
  void _addInItens(Item item) {
    if (!_existeItem(item.id)) _itens.add(item);
  }

  /// Retorna `true` se um [Item] com o mesmo [id] já tiver sido instanciado.
  /// O método `any()` executa um `for` nos elementos de [itens].
  /// O loop é interrompido assim que a condição for verdadeira.
  bool _existeItem(String id) {
    if (_itens.isEmpty)
      return false;
    else
      return _itens.any((element) => element.id == id);
  }

  /// Retorna um elemento de [itens] com base em [id].
  /// Retorna `null` se não for encontrado um elemento que satisfaça `element.id == id`.
  Item? _getItemById(String id) {
    if (_itens.isEmpty)
      return null;
    else
      return _itens.firstWhereOrNull((element) => element.id == id);
  }

  /// Assim o [Observable] notificará apenas ao final da execução do método.
  /// Buscar os itens (questões) no banco de dados e carregar na lista [itens],
  /// caso ainda não tenham sido carregados.
  /// Retornará uma lista vazia se o usuário não estiver logado ou ocorrer algum erro ao buscar os dados.
  @action
  Future<List<Item>> carregarItens() async {
    DataCollection resultado;
    try {
      /// Aguardar o retorno dos itens.
      resultado = await dbRepository.getCollection(CollectionType.itens);
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro a buscar os dados da coleção ${CollectionType.itens.name}."));
      assert(Debug.print(e));
      return List<Item>.empty();
    }
    if (resultado.isEmpty) return List<Item>.empty();

    /// Aguardar o carregamento dos assuntos.
    await assuntosRepository.assuntos;

    /// Carregar os itens.
    /// Não pode ser um `forEach`, pois precisa ser assincrono.
    for (var data in resultado) {
      if (!_existeItem(data[DbConst.kDbDataItemKeyId])) {
        if (data.containsKey(DbConst.kDbDataItemKeyReferencia)) {
          await _carregarItemReferenciado(resultado, data);
        } else {
          /// Criar um `Item` com base no `map` e incluir na lista de itens carregados.
          /// Não será emitido várias notificações, pois `carregarItens` também é um `action`.
          _addInItens(
              Item.fromJson(data, assuntosRepository.assuntosCarregados));
        }
      }
    }
    return _itens;
  }

  /// Assim o [Observable] notificará apenas ao final da execução do método.
  /// Carrega um item referenciado na lista [itens], caso ainda não tenha sido carregado.
  @action
  Future<Item?> _carregarItemReferenciado(
    // Retorno de `get()` na coleção dos itens.
    DataCollection dbItensData,
    // [Map] do item que faz a referência.
    DataDocument itemReferenciador,
  ) async {
    if (dbItensData.isEmpty) return null;

    /// Aguardar o carregamento dos assuntos. Não haverá atraso caso já tenham sido carregados.
    final assuntos = await assuntosRepository.assuntos;
    if (assuntos.isEmpty) return null;
    
    final idRef = itemReferenciador[DbConst.kDbDataItemKeyReferencia];

    // Retornar o item se ele já estiver carregado.
    if (_existeItem(idRef)) {
      return _getItemById(idRef);
    }
    // Criar e retornar o item se ele não estiver carregado.
    else {
      /// Criar uma cópia dos dados do item referenciado.
      final data = DataDocument.from(
        dbItensData.firstWhere(
          (element) => element[DbConst.kDbDataItemKeyId] == idRef,
        ),
      );

      /// Criar uma entrada para o id do item referenciado.
      data[Item.kKeyIdReferencia] = data[DbConst.kDbDataItemKeyId];

      /// Criar uma entrada para o índice do item referenciado.
      data[Item.kKeyIndiceReferencia] = data[DbConst.kDbDataItemKeyIndice];

      /// Criar uma entrada para o nível do item referenciado.
      data[Item.kKeyNivelReferencia] = data[DbConst.kDbDataItemKeyNivel];

      /// Atualizar com o id do item que referencia.
      data[DbConst.kDbDataItemKeyId] =
          itemReferenciador[DbConst.kDbDataItemKeyId];

      /// Atualizar com o índice do item que referencia.
      data[DbConst.kDbDataItemKeyIndice] =
          itemReferenciador[DbConst.kDbDataItemKeyIndice];

      /// Atualizar com o nível do item que referencia.
      data[DbConst.kDbDataItemKeyNivel] =
          itemReferenciador[DbConst.kDbDataItemKeyNivel];

      final _item = Item.fromJson(data, assuntos);
      _addInItens(_item);
      return _item;
    }
  }
}

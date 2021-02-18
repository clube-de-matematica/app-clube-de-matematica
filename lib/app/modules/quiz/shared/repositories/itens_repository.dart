import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import 'assuntos_repository.dart';
import '../models/item_model.dart';
import '../utils/strings_db_remoto.dart';
import '../../../../shared/repositories/firebase/firestore_repository.dart';

part 'itens_repository.g.dart';

///Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se 
///refere aos itens, excetuando-se os assuntos e as imágens.
class ItensRepository = _ItensRepositoryBase with _$ItensRepository;

abstract class _ItensRepositoryBase with Store {
  final FirestoreRepository firestoreRepository;
  final CollectionReference itensCollection;
  final AssuntosRepository assuntosRepository;

  _ItensRepositoryBase(
  this.firestoreRepository,
  this.assuntosRepository):  
  itensCollection = firestoreRepository.firestore.collection(DB_FIRESTORE_COLEC_ITENS) 
  {
    carregarItens();
  }

  @observable
  ///Lista com os itens já carregados.
  ObservableList<Item> _itens = List<Item>().asObservable();

  @computed
  ///Lista com os itens já carregados.
  List<Item> get itens => _itens;

  ///Lista com os itens já carregados.
  ///A [Reaction] `asyncWhen` é usada para esperar uma condição em um [Observable].
  ///Ficará ativa até que a condição seja satisfeita pela primeira vez.
  ///Após isso ela executa o seu método `dispose`.
  Future<List<Item>> get itensAsync => 
      asyncWhen((_) => _itens.isNotEmpty)
      .then((value) => _itens);

  @action
  ///Adiciona um novo [Item] a [itens].
  void _addInItens(Item item) {
    if (!_existeItem(item.id)) _itens.add(item);
  }

  ///Retorna `true` se um [Item] com o mesmo [id] já tiver sido instanciado.
  ///O método `any()` executa um `for` nos elementos de [itens].
  ///O loop é interrompido assim que a condição for verdadeira.
  bool _existeItem(String id) {
    if (_itens.isEmpty) return false;
    else return _itens.any((element) => element.id == id);
  }

  ///Retorna um elemento de [itens] com base em [id].
  ///Retorna `null` se não for encontrado um elemento se satisfaça `element.id == id`.
  Item _getItemById(String id) {
    if (_itens.isEmpty) return null;
    else return _itens.firstWhere(
      (element) => element.id == id,
      orElse: () => null
    );
  }
  
  @action ///Assim o [Observable] notificará apenas ao final da execução do método.
  ///Buscar os itens (questões) no banco de dados e carregar na lista [itens], 
  ///caso ainda não tenham sido carregados.
  ///Retornará `null` se o usuário não estiver logado ou ocorrer algum erro ao buscar os dados.
  Future<List<Item>> carregarItens() async {
    QuerySnapshot resultado;
    try {
      ///Aguardar o retorno dos itens.
      resultado = await firestoreRepository.getCollection(
        itensCollection,  
      );
    } on MyExceptionFirestoryRepository catch (e) {
      print(e.toString());
      return null;
    }
    if (resultado.docs.isEmpty) return null;
    ///Aguardar o carregamento dos assuntos.
    await assuntosRepository.assuntos;
    ///Carregar os itens.
    ///Não pode ser um `forEach`, pois precisa ser assincrono.
    for (var snapshot in resultado.docs) {
      ///Criar um [Map] do item.
      final map = snapshot.data();
      if (!_existeItem(map[DB_FIRESTORE_DOC_ITEM_ID])) {
        if (map.containsKey(DB_FIRESTORE_DOC_ITEM_REFERENCIA)) {
          await _carregarItemReferenciado(resultado, map);
        }
        else {
          ///Criar um `Item` com base no `map` e incluir na lista de itens carregados.
          ///Não será emitido várias notificações, pois `carregarItens` também é um `action`.
          _addInItens(Item.fromJson(map, assuntosRepository.assuntosCarregados));
        }
      }
    }
    return _itens;
  }

  @action ///Assim o [Observable] notificará apenas ao final da execução do método.
  ///Carrega um item referenciado na lista [itens], caso ainda não tenha sido carregado.
  Future<Item> _carregarItemReferenciado(
    ///Retorno de `get()` na coleção dos itens.
    QuerySnapshot dbItensSnapshot, 
    ///[Map] do item que faz a referência.
    Map<String, dynamic> itemReferenciador
  ) async {
    ///Aguardar o carregamento dos assuntos. Não haverá atraso caso já tenham sido carregados.
    final assuntos = await assuntosRepository.assuntos;
    if (dbItensSnapshot.docs.isEmpty) return null; 
    final DocumentReference ref = itemReferenciador[DB_FIRESTORE_DOC_ITEM_REFERENCIA];
    ///Retornar o item se ele já estiver carregado.
    if (_existeItem(ref.id)) return _getItemById(ref.id);
    ///Criar e retornar o item se ele não estiver carregado.
    else {
      ///Criar uma cópia dos dados do item referenciado.
      final _map = Map<String, dynamic>.from(
        dbItensSnapshot.docs.firstWhere(
          (element) => element.id == ref.id
        ).data()
      );
      ///Criar uma entrada para o id do item referenciado.
      _map[ITEM_ID_REFERENCIA_KEY] = _map[DB_FIRESTORE_DOC_ITEM_ID];
      ///Criar uma entrada para o índice do item referenciado.
      _map[ITEM_INDICE_REFERENCIA_KEY] = _map[DB_FIRESTORE_DOC_ITEM_INDICE];
      ///Criar uma entrada para o nível do item referenciado.
      _map[ITEM_NIVEL_REFERENCIA_KEY] = _map[DB_FIRESTORE_DOC_ITEM_NIVEL];

      ///Atualizar com o id do item que referencia.
      _map[DB_FIRESTORE_DOC_ITEM_ID] = itemReferenciador[DB_FIRESTORE_DOC_ITEM_ID];
      ///Atualizar com o índice do item que referencia.
      _map[DB_FIRESTORE_DOC_ITEM_INDICE] = itemReferenciador[DB_FIRESTORE_DOC_ITEM_INDICE];
      ///Atualizar com o nível do item que referencia.
      _map[DB_FIRESTORE_DOC_ITEM_NIVEL] = itemReferenciador[DB_FIRESTORE_DOC_ITEM_NIVEL];

      final _item = Item.fromJson(_map, assuntos);
      _addInItens(_item);
      return _item;
    }
  }
}
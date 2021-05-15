import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/repositories/firebase/firestore_repository.dart';
import '../models/assunto_model.dart';
import '../utils/strings_db_remoto.dart';

///Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
///refere aos assuntos.
class AssuntosRepository {
  AssuntosRepository(this.firestoreRepository)
      : assuntosCollection = firestoreRepository.firestore
            .collection(DB_FIRESTORE_COLEC_ASSUNTOS) {
    /* _isLoading = true;
    _carregarAssuntos().then((value) {
      _assuntos = Future(() {
        _isLoading = false;
        return value;
      });
    }); */
  }

  final FirestoreRepository firestoreRepository;
  final CollectionReference assuntosCollection;

  ///Retorna uma lista com os assuntos já carregados.
  List<Assunto> get assuntosCarregados => Assunto.instancias;

  ///Lista assincrona com os assuntos já carregados.
  Future<List<Assunto>>? _assuntos;

  ///Se os assuntos não estão sendo carregados, retorna uma lista com os assuntos.
  ///Se [_assuntos] é `null`, o método [_carregarAssuntos()] será executado, pois
  ///os assuntos ainda não foram carregados.
  ///Retorna uma lista vazia se os assuntos estiverem sendo carregados.
  FutureOr<List<Assunto>> get assuntos {
    if (!_isLoading)
      return (_assuntos ??= _carregarAssuntos());
    else
      return List<Assunto>.empty();
  }

  ///Será verdadeiro se os assuntos estiverem em pocesso de carregamento.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ///Buscar os assuntos no banco de dados.
  Future<List<Assunto>> _carregarAssuntos() async {
    _isLoading = true;
    QuerySnapshot resultado;
    try {
      resultado = await firestoreRepository.getCollection(assuntosCollection);
    } on MyExceptionFirestoreRepository catch (e) {
      print(e.toString());
      _isLoading = false;
      return List<Assunto>.empty();
    }
    if (resultado.docs.isEmpty) {
      _isLoading = false;
      return List<Assunto>.empty();
    } else {
      resultado.docs.forEach((snapshot) {
        final map = snapshot.data() as Map<String, dynamic>;

        ///A auxência da árvore hierárquica indica que o assunto é uma unidade.
        ///Se o assunto não for uma unidade será criado um [Assunto] com o título do topo
        ///da hierarquia de assuntos.
        if (map.containsKey(DB_FIRESTORE_DOC_ASSUNTO_ARVORE))
          Assunto(
              arvore: List<String>.empty(),

              ///`map[DB_DOC_ASSUNTO_ARVORE]` vem como [List<dynamic>].
              titulo: map[DB_FIRESTORE_DOC_ASSUNTO_ARVORE][0] as String

              ///Tipado para [String].
              );

        ///Criar um [Assunto] com base no [map].
        Assunto.fromJson(map);
      });
      _isLoading = false;
      return assuntosCarregados;
    }
  }

  ///Insere um novo assunto no banco de dados.
  ///Retorna `true` se o assunto for inserido com suceso.
  Future<bool> inserirAssunto(Assunto assunto) async {
    try {
      return await firestoreRepository.setDocumentIfNotExist(
          assuntosCollection.doc(), assunto.toJson());
    } on MyExceptionFirestoreRepository catch (e) {
      print(e.toString());
      return false;
    }
  }
}

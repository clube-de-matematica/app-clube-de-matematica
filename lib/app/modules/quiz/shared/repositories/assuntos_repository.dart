import 'dart:async';

import '../../../../shared/models/debug.dart';
import '../../../../shared/repositories/interface_db_repository.dart';
import '../models/assunto_model.dart';
import '../utils/strings_db_remoto.dart';

///Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
///refere aos assuntos.
class AssuntosRepository {
  AssuntosRepository(this.dbRepository) {
    /* _isLoading = true;
    _carregarAssuntos().then((value) {
      _assuntos = Future(() {
        _isLoading = false;
        return value;
      });
    }); */
  }

  final IDbRepository dbRepository;

  /// O caminho para a coleção (ou tabela) de assuntos.
  String get collectionPath => dbRepository.pathAssuntos;

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
    DataCollection resultado;
    try {
      resultado = await dbRepository.getCollection(collectionPath);
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro a buscar os dados da coleção $collectionPath."));
      assert(Debug.print(e));
      _isLoading = false;
      return List<Assunto>.empty();
    }
    if (resultado.isEmpty) {
      _isLoading = false;
      return List<Assunto>.empty();
    } else {
      resultado.forEach((data) {
        ///A auxência da árvore hierárquica indica que o assunto é uma unidade.
        ///Se o assunto não for uma unidade será criado um [Assunto] com o título do topo
        ///da hierarquia de assuntos. Caso contrário, primeiramente será criado um [Assunto]
        ///para a unidade - nesse caso a arvore será uma lista vazia.
        if (data.containsKey(DB_FIRESTORE_DOC_ASSUNTO_ARVORE)) {
          Assunto(
              arvore: List<String>.empty(),

              ///`map[DB_DOC_ASSUNTO_ARVORE]` vem como [List<dynamic>].
              titulo: data[DB_FIRESTORE_DOC_ASSUNTO_ARVORE][0]
                  as String //Tipado para [String].
              );
        }

        ///Criar um [Assunto] com base no [map].
        Assunto.fromJson(data);
      });
      _isLoading = false;
      return assuntosCarregados;
    }
  }

  ///Insere um novo assunto no banco de dados.
  ///Retorna `true` se o assunto for inserido com suceso.
  Future<bool> inserirAssunto(Assunto assunto) async {
    try {
      return await dbRepository.setDocumentIfNotExist(
          collectionPath, assunto.toJson());
    } catch (e) {
      assert(Debug.printBetweenLine("Erro ao inserir o assunto $assunto."));
      assert(Debug.print(e));
      return false;
    }
  }
}

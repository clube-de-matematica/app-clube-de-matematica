import 'dart:async';

import '../../../modules/quiz/shared/models/assunto_model.dart';
import '../../models/debug.dart';
import '../../utils/strings_db.dart';
import '../interface_db_repository.dart';

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
      resultado = await dbRepository.getAssuntos();
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro a buscar os dados da coleção ${CollectionType.assuntos.name}."));
      assert(Debug.print(e));
      _isLoading = false;
      return List<Assunto>.empty();
    }
    if (resultado.isEmpty) {
      _isLoading = false;
      return List<Assunto>.empty();
    } else {
      resultado.forEach((data) {
        ///Criar um [Assunto] com base em [data].
        Assunto.fromJson(data);
      });
      _isLoading = false;
      return assuntosCarregados;
    }
  }
}

import '../modules/clubes/shared/models/clube.dart';
import '../modules/quiz/shared/models/assunto_model.dart';
import '../modules/quiz/shared/models/questao_model.dart';
import '../shared/utils/strings_db.dart';

abstract class IDbServicos {
  Future<List<int>> filtrarAnos({
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
  });

  Future<List<int>> filtrarNiveis({
    Iterable<int> anos = const [],
    Iterable<int> assuntos = const [],
  });

  Future<List<Assunto>> filtrarAssuntos({
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
  });

  Future<Assunto?> assunto(int id);

  Stream<List<Assunto>> getAssuntos();

  Future<bool> insertAssunto(RawAssunto data);

  Future<Questao?> questao(String id);

  Future<int> contarQuestoes({
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
  });

  Future<List<Questao>> getQuestoes({
    Iterable<String> ids = const [],
    Iterable<int> anos = const [],
    Iterable<int> niveis = const [],
    Iterable<int> assuntos = const [],
    int? limit,
    int? offset,
  });

  Future<bool> insertQuestao(DataDocument data);

  Future<List<Clube>> getClubes(int idUsuario);

  Future<DataClube> insertClube(DataClube data);

  Future<DataClube> updateClube(DataClube data);

  Future<DataClube> enterClube(String accessCode, int idUser);

  Future<bool> exitClube(int idClube, int idUser);

  Future<bool> updatePermissionUserClube(
      int idClube, int idUser, int idPermission);

  Future<DataCollection> getAtividades(int idClube);

  Future<DataAtividade> insertAtividade(DataAtividade data);

  Future<DataAtividade> updateAtividade(DataAtividade dados);

  Future<List<DataRespostaQuestaoAtividade>> getRespostasAtividade(
    int idAtividade, [
    int? idUsuario,
  ]);

  Future<bool> upsertRespostasAtividade(
      List<DataRespostaQuestaoAtividade> data);
}

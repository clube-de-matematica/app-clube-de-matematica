import '../modules/clubes/modules/atividades/models/atividade.dart';
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

  /// {@template app.IDbServicos.sincronizarClubes}
  /// Sincroniza os registros dos dados relacionados aos clubes entre os bancos de dados
  /// local e remoto.
  /// {@endtemplate}
  Future<void> sincronizarClubes();

  Stream<List<Clube>> getClubes();

  Future<Clube?> insertClube(RawClube data);

  Future<Clube?> updateClube(RawClube data);

  Future<Clube?> enterClube(String accessCode);

  Future<bool> removerUsuarioClube(int idClube, int idUser);

  Future<bool> updatePermissionUserClube(
      int idClube, int idUser, int idPermission);

  Future<bool> excluirClube(Clube clube);

  Stream<List<Atividade>> getAtividades(Clube clube);

  Future<Atividade?> insertAtividade(RawAtividade dados);

  Future<Atividade?> updateAtividade(RawAtividade dados);

  Future<List<DataRespostaQuestaoAtividade>> getRespostasAtividade(
      Atividade atividade);

  Future<bool> upsertRespostasAtividade(
      List<DataRespostaQuestaoAtividade> data);
}
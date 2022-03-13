import '../modules/clubes/modules/atividades/models/atividade.dart';
import '../modules/clubes/modules/atividades/models/questao_atividade.dart';
import '../modules/clubes/modules/atividades/models/resposta_questao_atividade.dart';
import '../modules/clubes/shared/models/clube.dart';
import '../modules/perfil/models/userapp.dart';
import '../modules/quiz/shared/models/assunto_model.dart';
import '../modules/quiz/shared/models/questao_model.dart';
import '../modules/quiz/shared/models/resposta_questao.dart';
import '../shared/repositories/interface_auth_repository.dart';
import '../shared/repositories/supabase/supabase_db_repository.dart';

abstract class IDbServicos {
  IDbServicos(this.dbRemoto, this.auth);

  //TODO final IRemoteDbRepository _dbRemoto;
  final SupabaseDbRepository dbRemoto;
  final IAuthRepository auth;

  bool get logado => auth.logged;

  int? get idUsuarioApp => auth.user.id;

  void close();

  Future<Assunto?> assunto(int id);

  Future<Atividade?> atualizarAtividade(RawAtividade dados);

  Future<Clube?> atualizarClube(RawClube data);

  Future<bool> atualizarPermissaoUsuarioClube(
      int idClube, int idUser, int idPermission);

  Future<bool> atualizarUsuario(RawUserApp dados);

  Future<int> contarQuestoes(
      {Iterable<int> anos = const [],
      Iterable<int> niveis = const [],
      Iterable<int> assuntos = const []});

  Future<Clube?> entrarClube(String accessCode);

  Future<bool> excluirAtividade(Atividade atividade);

  Future<bool> excluirClube(Clube clube);

  Future<List<int>> filtrarAnos(
      {Iterable<int> niveis = const [], Iterable<int> assuntos = const []});

  Future<List<Assunto>> filtrarAssuntos(
      {Iterable<int> anos = const [], Iterable<int> niveis = const []});

  Future<List<int>> filtrarNiveis(
      {Iterable<int> anos = const [], Iterable<int> assuntos = const []});

  Future<bool> inserirAssunto(RawAssunto dados);

  Future<Atividade?> inserirAtividade(RawAtividade dados);

  Future<Clube?> inserirClube(RawClube data);

  Future<bool> inserirQuestao(Questao data);

  Future<bool> inserirReferenciaQuestao(Questao data, int idReferencia);

  Stream<List<Assunto>> obterAssuntos();

  Stream<List<Atividade>> obterAtividades(Clube clube);

  Stream<List<Clube>> obterClubes();

  Future<Questao?> obterQuestao(String id);

  Future<List<Questao>> obterQuestoes(
      {Iterable<String> ids = const [],
      Iterable<int> anos = const [],
      Iterable<int> niveis = const [],
      Iterable<int> assuntos = const [],
      int? limit,
      int? offset});

  Future<List<QuestaoAtividade>> obterQuestoesAtividade(Atividade atividade);

  Future<RespostaQuestao?> obterRespostaQuestao(Questao questao);

  Future<bool> removerUsuarioClube(int idClube, int idUser);

  Future<bool> salvarRespostaQuestao(RawRespostaQuestao resposta);

  Future<bool> salvarRespostasAtividade(
      Iterable<RawRespostaQuestaoAtividade> dados);

  Future<void> sincronizarClubes();
}

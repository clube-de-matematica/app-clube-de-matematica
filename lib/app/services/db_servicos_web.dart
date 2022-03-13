import 'dart:async';

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
import 'db_servicos_interface.dart';

class DbServicos extends IDbServicos {
  DbServicos(
    SupabaseDbRepository dbRemoto,
    IAuthRepository auth,
  ) : super(dbRemoto, auth);

  @override
  void close() {}

  @override
  Future<Assunto?> assunto(int id) {
    return dbRemoto.getAssunto(id);
  }

  @override
  Future<int> contarQuestoes(
      {Iterable<int> anos = const [],
      Iterable<int> niveis = const [],
      Iterable<int> assuntos = const []}) {
    return dbRemoto.getNumQuestoes();
  }

  @override
  Future<bool> inserirAssunto(RawAssunto dados) async {
    final sucesso = await dbRemoto.insertAssunto(dados);
    return sucesso;
  }

  @override
  Future<bool> inserirQuestao(Questao data) async {
    final sucesso = await dbRemoto.insertQuestao(data);
    return sucesso;
  }

  @override
  Future<bool> inserirReferenciaQuestao(Questao data, int idReferencia) async {
    final sucesso = await dbRemoto.insertReferenceQuestao(data, idReferencia);
    return sucesso;
  }

  @override
  Stream<List<Assunto>> obterAssuntos() {
    return Stream.fromFuture(dbRemoto.getAssuntos());
  }

  @override
  Stream<List<Clube>> obterClubes() {
    if (idUsuarioApp == null) return Stream.value([]);
    return Stream.fromFuture(dbRemoto.getClubes(idUsuarioApp!));
  }

  @override
  Future<Questao?> obterQuestao(String id) {
    return dbRemoto.getQuestao(id);
  }

  @override
  Future<List<Questao>> obterQuestoes(
      {Iterable<String> ids = const [],
      Iterable<int> anos = const [],
      Iterable<int> niveis = const [],
      Iterable<int> assuntos = const [],
      int? limit,
      int? offset}) {
    return dbRemoto.getQuestoes();
  }

  @override
  Future<void> sincronizarClubes() {
    throw UnimplementedError();
  }

  @override
  Future<Atividade?> atualizarAtividade(RawAtividade dados) {
    throw UnimplementedError();
  }

  @override
  Future<Clube?> atualizarClube(RawClube data) {
    throw UnimplementedError();
  }

  @override
  Future<bool> atualizarPermissaoUsuarioClube(
      int idClube, int idUser, int idPermission) {
    throw UnimplementedError();
  }

  @override
  Future<bool> atualizarUsuario(RawUserApp dados) {
    throw UnimplementedError();
  }

  @override
  Future<Clube?> entrarClube(String accessCode) {
    throw UnimplementedError();
  }

  @override
  Future<bool> excluirAtividade(Atividade atividade) {
    throw UnimplementedError();
  }

  @override
  Future<bool> excluirClube(Clube clube) {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> filtrarAnos(
      {Iterable<int> niveis = const [], Iterable<int> assuntos = const []}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Assunto>> filtrarAssuntos(
      {Iterable<int> anos = const [], Iterable<int> niveis = const []}) {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> filtrarNiveis(
      {Iterable<int> anos = const [], Iterable<int> assuntos = const []}) {
    throw UnimplementedError();
  }

  @override
  Future<Atividade?> inserirAtividade(RawAtividade dados) {
    throw UnimplementedError();
  }

  @override
  Future<Clube?> inserirClube(RawClube data) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Atividade>> obterAtividades(Clube clube) {
    throw UnimplementedError();
  }

  @override
  Future<List<QuestaoAtividade>> obterQuestoesAtividade(Atividade atividade) {
    throw UnimplementedError();
  }

  @override
  Future<RespostaQuestao?> obterRespostaQuestao(Questao questao) async{
    return null;
  }

  @override
  Future<bool> removerUsuarioClube(int idClube, int idUser) {
    throw UnimplementedError();
  }

  @override
  Future<bool> salvarRespostaQuestao(RawRespostaQuestao resposta) {
    throw UnimplementedError();
  }

  @override
  Future<bool> salvarRespostasAtividade(
      Iterable<RawRespostaQuestaoAtividade> dados) {
    throw UnimplementedError();
  }
}

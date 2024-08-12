import 'dart:async';


import '../modules/clubes/modules/atividades/models/atividade.dart';
import '../modules/clubes/modules/atividades/models/questao_atividade.dart';
import '../modules/clubes/modules/atividades/models/resposta_questao_atividade.dart';
import '../modules/clubes/shared/models/clube.dart';
import '../modules/perfil/models/userapp.dart';
import '../modules/quiz/shared/models/assunto_model.dart';
import '../modules/quiz/shared/models/questao_model.dart';
import '../modules/quiz/shared/models/resposta_questao.dart';
import 'db_servicos_interface.dart';

class DbServicos extends IDbServicos {
  DbServicos(
    super.dbRemoto,
    super.auth,
  );

  @override
  void close() {}

  @override
  Future<Assunto?> assunto(int id) {
    throw UnimplementedError();
  }

  @override
  Future<int> contarQuestoes(
      {Iterable<int> anos = const [],
      Iterable<int> niveis = const [],
      Iterable<int> assuntos = const []}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> inserirAssunto(RawAssunto dados) {
    throw UnimplementedError();
  }

  @override
  Future<bool> checarPermissaoInserirQuestao() {
    throw UnimplementedError();
  }

  @override
  Future<bool> inserirQuestao(Questao data) {
    throw UnimplementedError();
  }

  @override
  Future<bool> inserirReferenciaQuestao(Questao data, int idReferencia) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Assunto>> obterAssuntos() {
    throw UnimplementedError();
  }

  @override
  Stream<List<Clube>> obterClubes() {
    throw UnimplementedError();
  }

  @override
  Future<Questao?> obterQuestao(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Questao>> obterQuestoes(
      {Iterable<String> ids = const [],
      Iterable<int> anos = const [],
      Iterable<int> niveis = const [],
      Iterable<int> assuntos = const [],
      int? limit,
      int? offset}) {
    throw UnimplementedError();
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
  Future<RespostaQuestao?> obterRespostaQuestao(Questao questao) {
    throw UnimplementedError();
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

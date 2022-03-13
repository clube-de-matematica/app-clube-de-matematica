import 'dart:async';

import '../../modules/clubes/modules/atividades/models/atividade.dart';
import '../../modules/clubes/modules/atividades/models/resposta_questao_atividade.dart';
import '../../modules/clubes/shared/models/clube.dart';
import '../../modules/perfil/models/userapp.dart';
import '../../modules/quiz/shared/models/assunto_model.dart';
import '../../modules/quiz/shared/models/questao_model.dart';
import '../../modules/quiz/shared/models/resposta_questao.dart';
import '../utils/strings_db.dart';

enum CollectionType {
  assuntos,
  atividades,
  clubes,
  questoes,
  respostasQuestaoAtividade,
  usuarios,
}

extension ExtensionCollectionType on CollectionType {
  /// Retorna o nome da coleção (ou tabela) correspondente a [this].
  String get name {
    switch (this) {
      case CollectionType.assuntos:
        return DbConst.kDbDataCollectionAssuntos;
      case CollectionType.atividades:
        return DbConst.kDbDataCollectionAtividades;
      case CollectionType.clubes:
        return DbConst.kDbDataCollectionClubes;
      case CollectionType.questoes:
        return DbConst.kDbDataCollectionQuestoes;
      case CollectionType.respostasQuestaoAtividade:
        return DbConst.kDbDataCollectionRespostaQuestaoAtividade;
      case CollectionType.usuarios:
        return DbConst.kDbDataCollectionUsuarios;
    }
  }
}

/// O super tipo para repositórios de banco de dados remoto.
abstract class IRemoteDbRepository implements IDbRepository {}

/// O super tipo para repositórios de banco de dados local.
abstract class ILocalDbRepository implements IDbRepository {}

/// Deve ser implementada pelas classes que gerenciam a conexão com o banco de dados.
abstract class IDbRepository {
  Future<bool> insertAssunto(RawAssunto data);

  Future<bool> insertQuestao(Questao data);

  Future<Clube?> insertClube(RawClube dados);

  /// Adiciona o usuário correspondente a [idUser] ao clube correspondente a [accessCode].
  /// Retorna os dados do clube após a alteração.
  /// Retorna um [DataDocument] vazio se ocorrer algum erro.
  Future<DataClube> enterClube(String accessCode, int idUser);

  /// {@template app.IDbRepository.insertAtividade}
  /// Criar uma nova atividade com as informações dos parâmetros.
  ///
  /// Se o processo for bem sucedido, retorna o clube criado.
  /// {@endtemplate}
  Future<Atividade?> insertAtividade(RawAtividade dados);

  Future<Assunto?> getAssunto(int id);

  Future<List<Assunto>> getAssuntos();

  Future<int> getNumQuestoes();

  Future<Questao?> getQuestao(String id);

  Future<List<Questao>> getQuestoes();

  Future<List<Clube>> getClubes(int idUsuario);

  /// Atualiza os dados do clube com base em [data].
  /// A capa e descrição não serão atualizadas se forem string vazia em [data].
  /// Os demais não serão atualizados se forem null.
  Future<Clube?> updateClube(RawClube dados);

  /// Remove o usuário correspondente a [idUser] do clube correspondente a [idClube].
  Future<bool> exitClube(int idClube, int idUser);

  /// Atualiza a permissão de acesso do usuário do clube de acordo com os correspondentes
  /// [idPermission], [idUser] e [idClube].
  Future<bool> updatePermissionUserClube(
    int idClube,
    int idUser,
    int idPermission,
  );

  /// Marca como excluído o clube correspondente a [idClube].
  Future<bool> deleteClube(int idClube);

  Future<DataCollection> getAtividades(int idClube);

  /// {@template app.IDbRepository.updateAtividade}
  /// Atualiza os dados da atividade com base nas informações do parâmetro.
  ///
  /// A descrição não será atualizada se for uma string vazia.
  ///
  /// A data de encerramento não será atualizada se for
  /// `DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)`.
  ///
  /// As demais propriedades não serão atualizados se forem `null`.
  /// {@endtemplate}
  Future<Atividade?> updateAtividade(RawAtividade dados);

  /// Marca como excluída a atividade correspondente a [idAtividade].
  Future<bool> deleteAtividade(int idAtividade);

  /// {@template app.IDbRepository.getRespostasAtividade}
  /// Retorna as repostas dos usuários a uma atividade.
  ///
  /// Se [idUsuario] for `null`, será retornado as respostas de todos os usuários.
  /// {@endtemplate}
  Future<List<DataRespostaQuestaoAtividade>> getRespostasAtividade(
    int idAtividade, [
    int? idUsuario,
  ]);

  /// {@template app.IDbRepository.upsertRespostasAtividade}
  /// Insere as respostas da atividade, caso ainda não existam, ou atualiza-as,
  /// caso já existam.
  /// {@endtemplate}
  Future<bool> upsertRespostasAtividade(
      Iterable<RawRespostaQuestaoAtividade> data);

  /// {@template app.IDbRepository.getRespostas}
  /// Retorna as repostas não vinculadas a atividades do usuário correspondente a [idUsuario].
  /// {@endtemplate}
  Future<List<DataRespostaQuestaoAtividade>> getRespostas(int idUsuario);

  /// {@template app.IDbRepository.upsertRespostas}
  /// Insere as respostas não vinculadas a atividades, caso ainda não existam, ou atualiza-as,
  /// caso já existam.
  /// {@endtemplate}
  Future<bool> upsertRespostas(Iterable<RawRespostaQuestao> dados);

  /// Atualiza o nome do usuário no banco de dados remoto.
  Future<bool> updateUser(RawUserApp dados);
}

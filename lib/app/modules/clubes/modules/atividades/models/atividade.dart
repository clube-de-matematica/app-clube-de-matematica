import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../../../../shared/utils/db/codificacao.dart';
import '../../../../../shared/utils/strings_db.dart';
import 'questao_atividade.dart';
import 'resposta_questao_atividade.dart';

part 'atividade.g.dart';

/// Modelo para os dados das atividades dos clubes.
class Atividade extends _AtividadeBase with _$Atividade {
  Atividade({
    required int id,
    required String titulo,
    String? descricao,
    required int idClube,
    required int idAutor,
    required DateTime criacao,
    DateTime? liberacao,
    DateTime? encerramento,
    Iterable<QuestaoAtividade>? questoes,
    Iterable<RespostaQuestaoAtividade>? respostas,
  }) : super(
          id: id,
          titulo: titulo,
          descricao: descricao,
          idClube: idClube,
          idAutor: idAutor,
          criacao: criacao,
          liberacao: liberacao,
          encerramento: encerramento,
          questoes: questoes,
          respostas: respostas,
        );

  factory Atividade.fromDataAtividade(DataAtividade map) {
    respostas() {
      final dataRespostas =
          map[DbConst.kDbDataAtividadeKeyRespostas] as List? ?? [];
      return dataRespostas
          .cast<Map>()
          .map((dados) =>
              RespostaQuestaoAtividade.fromDataRespostaQuestaoAtividade(
                  dados.cast()))
          .toList();
    }

    final retorno = Atividade(
      id: map[DbConst.kDbDataAtividadeKeyId],
      titulo: map[DbConst.kDbDataAtividadeKeyTitulo],
      descricao: map[DbConst.kDbDataAtividadeKeyDescricao],
      idClube: map[DbConst.kDbDataAtividadeKeyIdClube],
      idAutor: map[DbConst.kDbDataAtividadeKeyIdAutor],
      criacao: DbRemoto.decodificarData(
              '${map[DbConst.kDbDataAtividadeKeyDataCriacao]}') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      liberacao: DbRemoto.decodificarData(
          '${map[DbConst.kDbDataAtividadeKeyDataLiberacao]}'),
      encerramento: DbRemoto.decodificarData(
          '${map[DbConst.kDbDataAtividadeKeyDataEncerramento]}'),
      questoes: [],
      respostas: respostas(),
    );

    return retorno;
  }
}

abstract class _AtividadeBase with Store {
  final int id;
  String titulo;
  String? descricao;

  /// ID do clube ao qual esta atividade pertence.
  final int idClube;

  /// ID do usuário que criou esta atividade.
  final int idAutor;

  /// Data/hora (no fuso horário UTC) da criação desta atividade.
  final DateTime criacao;

  /// Data/hora (no fuso horário UTC) da liberação desta atividade para os usuários do clube.
  /// Será `NULL` se ainda não tiver sido liberada.
  @observable
  DateTime? liberacao;

  /// Data/hora (no fuso horário UTC) final para que esta atividade seja concluída.
  @observable
  DateTime? encerramento;

  /// Lista com as questões incluídas nesta atividade.
  final ObservableList<QuestaoAtividade> questoes;

  /// Lista com as respostas dos usuários às questões incluídas nesta atividade.
  final ObservableSet<RespostaQuestaoAtividade> respostas;

  _AtividadeBase({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.idClube,
    required this.idAutor,
    required this.criacao,
    this.liberacao,
    this.encerramento,
    Iterable<QuestaoAtividade>? questoes,
    Iterable<RespostaQuestaoAtividade>? respostas,
  })  : questoes = ObservableList.of(questoes ?? Iterable.empty()),
        respostas = ObservableSet.of(respostas ?? Iterable.empty());

  @computed
  bool get encerrada {
    return encerramento?.toUtc().isBefore(DateTime.now().toUtc()) ?? false;
  }

  @computed
  bool get liberada {
    return liberacao?.toUtc().isBefore(DateTime.now().toUtc()) ?? false;
  }

  /// Sobrescreve os campos modificáveis desta atividade com os respectivos valores em
  /// [outra], desde que tenham o mesmo ID.
  void mesclar(Atividade outra) {
    if (this.id == outra.id) {
      titulo = outra.titulo;
      descricao = outra.descricao;
      liberacao = outra.liberacao;
      encerramento = outra.encerramento;
      questoes
        ..clear()
        ..addAll(outra.questoes.where((e) => e.idAtividade == id));
      respostas
        ..clear()
        ..addAll(outra.respostas);
    }
  }

  @override
  String toString() {
    return 'Atividade(id: $id, nome: $titulo, descricao: $descricao, idClube: $idClube, idAutor: $idAutor, criacao: $criacao, publicacao: $liberacao, encerramento: $encerramento, questoes: $questoes, respostas: $respostas)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Atividade &&
        other.id == id &&
        other.titulo == titulo &&
        other.descricao == descricao &&
        other.idClube == idClube &&
        other.idAutor == idAutor &&
        other.criacao == criacao &&
        other.liberacao == liberacao &&
        other.encerramento == encerramento &&
        listEquals(other.questoes, questoes) &&
        setEquals(other.respostas, respostas);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        titulo.hashCode ^
        descricao.hashCode ^
        idClube.hashCode ^
        idAutor.hashCode ^
        criacao.hashCode ^
        liberacao.hashCode ^
        encerramento.hashCode ^
        questoes.hashCode ^
        respostas.hashCode;
  }
}

/// Usada para preencher parcialmente os dados de uma atividade.
class RawAtividade {
  RawAtividade({
    this.id,
    this.titulo,
    this.descricao,
    this.idClube,
    this.idAutor,
    this.criacao,
    this.liberacao,
    this.encerramento,
    this.questoes,
    this.respostas,
  });

  final int? id;
  final String? titulo;
  final String? descricao;
  final int? idClube;
  final int? idAutor;
  final DateTime? criacao;
  final DateTime? liberacao;
  final DateTime? encerramento;
  final List<RawQuestaoAtividade>? questoes;
  final Set<RespostaQuestaoAtividade>? respostas;

  DataAtividade toDataAtividade() {
    return {
      DbConst.kDbDataAtividadeKeyId: id,
      DbConst.kDbDataAtividadeKeyTitulo: titulo,
      DbConst.kDbDataAtividadeKeyDescricao: descricao,
      DbConst.kDbDataAtividadeKeyIdClube: idClube,
      DbConst.kDbDataAtividadeKeyIdAutor: idAutor,
      DbConst.kDbDataAtividadeKeyDataCriacao: criacao?.millisecondsSinceEpoch,
      DbConst.kDbDataAtividadeKeyDataLiberacao:
          liberacao?.millisecondsSinceEpoch,
      DbConst.kDbDataAtividadeKeyDataEncerramento:
          encerramento?.millisecondsSinceEpoch,
      DbConst.kDbDataAtividadeKeyQuestoes:
          questoes?.map((x) => x.toDataQuestaoAtividade()).toList(),
      DbConst.kDbDataAtividadeKeyRespostas:
          respostas?.map((x) => x.toDataRespostaQuestaoAtividade()).toList(),
    };
  }

  RawAtividade copyWith({
    int? id,
    String? titulo,
    String? descricao,
    int? idClube,
    int? idAutor,
    DateTime? criacao,
    DateTime? liberacao,
    DateTime? encerramento,
    List<RawQuestaoAtividade>? questoes,
    Set<RespostaQuestaoAtividade>? respostas,
  }) {
    return RawAtividade(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      idClube: idClube ?? this.idClube,
      idAutor: idAutor ?? this.idAutor,
      criacao: criacao ?? this.criacao,
      liberacao: liberacao ?? this.liberacao,
      encerramento: encerramento ?? this.encerramento,
      questoes: questoes ?? this.questoes,
      respostas: respostas ?? this.respostas,
    );
  }
}

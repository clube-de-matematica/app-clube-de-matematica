import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../../shared/utils/strings_db.dart';

/// Modelo para os dados das atividades dos clubes.
class Atividade {
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
  DateTime? liberacao;

  /// Data/hora (no fuso horário UTC) final para que esta atividade seja concluída.
  DateTime? encerramento;

  /// Lista com as questões incluídas nesta atividade.
  final List<QuestaoAtividade> questoes;

  Atividade({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.idClube,
    required this.idAutor,
    required this.criacao,
    this.liberacao,
    this.encerramento,
    this.questoes = const [],
  });

  Atividade copyWith({
    int? id,
    String? nome,
    String? descricao,
    int? idClube,
    int? idAutor,
    DateTime? criacao,
    DateTime? publicacao,
    DateTime? encerramento,
    List<QuestaoAtividade>? questoes,
  }) {
    return Atividade(
      id: id ?? this.id,
      titulo: nome ?? this.titulo,
      descricao: descricao ?? this.descricao,
      idClube: idClube ?? this.idClube,
      idAutor: idAutor ?? this.idAutor,
      criacao: criacao ?? this.criacao,
      liberacao: publicacao ?? this.liberacao,
      encerramento: encerramento ?? this.encerramento,
      questoes: questoes ?? this.questoes,
    );
  }

  DataAtividade toDataAtividade() {
    return {
      DbConst.kDbDataAtividadeKeyId: id,
      DbConst.kDbDataAtividadeKeyTitulo: titulo,
      DbConst.kDbDataAtividadeKeyDescricao: descricao,
      DbConst.kDbDataAtividadeKeyIdClube: idClube,
      DbConst.kDbDataAtividadeKeyIdAutor: idAutor,
      DbConst.kDbDataAtividadeKeyDataCriacao: criacao.millisecondsSinceEpoch,
      DbConst.kDbDataAtividadeKeyDataLiberacao:
          liberacao?.millisecondsSinceEpoch,
      DbConst.kDbDataAtividadeKeyDataEncerramento:
          encerramento?.millisecondsSinceEpoch,
      DbConst.kDbDataAtividadeKeyQuestoes:
          questoes.map((x) => x.toMap()).toList(),
    };
  }

  factory Atividade.fromDataAtividade(DataAtividade map) {
    final int idAtividade = map[DbConst.kDbDataAtividadeKeyId];
    return Atividade(
      id: idAtividade,
      titulo: map[DbConst.kDbDataAtividadeKeyTitulo],
      descricao: map[DbConst.kDbDataAtividadeKeyDescricao] != null
          ? map[DbConst.kDbDataAtividadeKeyDescricao]
          : null,
      idClube: map[DbConst.kDbDataAtividadeKeyIdClube],
      idAutor: map[DbConst.kDbDataAtividadeKeyIdAutor],
      criacao: DateTime.parse(map[DbConst.kDbDataAtividadeKeyDataCriacao]),
      liberacao: map[DbConst.kDbDataAtividadeKeyDataLiberacao] != null
          ? DateTime.parse(map[DbConst.kDbDataAtividadeKeyDataLiberacao])
          : null,
      encerramento: map[DbConst.kDbDataAtividadeKeyDataEncerramento] != null
          ? DateTime.parse(map[DbConst.kDbDataAtividadeKeyDataEncerramento])
          : null,
      questoes: List<QuestaoAtividade>.from(map[
              DbConst.kDbDataAtividadeKeyQuestoes]
          ?.map((dados) => QuestaoAtividade(
                id: dados[DbConst.kDbDataQuestaoAtividadeKeyId],
                idQuestao:
                    dados[DbConst.kDbDataQuestaoAtividadeKeyIdQuestaoCaderno],
                idAtividade: idAtividade,
              ))),
    );
  }

  String toJson() => json.encode(toDataAtividade());

  factory Atividade.fromJson(String source) =>
      Atividade.fromDataAtividade(json.decode(source));

  /// Sobrescreve os campos desta atividade com os respectivos valores em [outra], desde que
  /// tenham o mesmo ID.
  void sobrescrever(Atividade outra) {
    if (this.id == outra.id) {
      titulo = outra.titulo;
      descricao = outra.descricao;
      liberacao = outra.liberacao;
      encerramento = outra.encerramento;
      questoes
        ..clear()
        ..addAll(outra.questoes);
    }
  }

  @override
  String toString() {
    return 'Atividade(id: $id, nome: $titulo, descricao: $descricao, idClube: $idClube, idAutor: $idAutor, criacao: $criacao, publicacao: $liberacao, encerramento: $encerramento, questoes: $questoes)';
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
        listEquals(other.questoes, questoes);
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
        questoes.hashCode;
  }
}

/// Modelo para as questões usadas em uma atividade.
class QuestaoAtividade {
  final int id;
  final String idQuestao;
  final int idAtividade;
  final List<Resposta> respostas;

  QuestaoAtividade({
    required this.id,
    required this.idQuestao,
    required this.idAtividade,
    this.respostas = const [],
  });

  QuestaoAtividade copyWith({
    int? id,
    String? idQuestao,
    int? idAtividade,
    List<Resposta>? respostas,
  }) {
    return QuestaoAtividade(
      id: id ?? this.id,
      idQuestao: idQuestao ?? this.idQuestao,
      idAtividade: idAtividade ?? this.idAtividade,
      respostas: respostas ?? this.respostas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idQuestao': idQuestao,
      'idAtividade': idAtividade,
      'respostas': respostas.map((x) => x.toMap()).toList(),
    };
  }

  factory QuestaoAtividade.fromMap(Map<String, dynamic> map) {
    return QuestaoAtividade(
      id: map['id'],
      idQuestao: map['idQuestao'],
      idAtividade: map['idAtividade'],
      respostas: List<Resposta>.from(
          map['respostas']?.map((x) => Resposta.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestaoAtividade.fromJson(String source) =>
      QuestaoAtividade.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuestaoAtividade(id: $id, idQuestao: $idQuestao, idAtividade: $idAtividade, respostas: $respostas)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestaoAtividade &&
        other.id == id &&
        other.idQuestao == idQuestao &&
        other.idAtividade == idAtividade &&
        listEquals(other.respostas, respostas);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idQuestao.hashCode ^
        idAtividade.hashCode ^
        respostas.hashCode;
  }
}

/// Modelo para as respostas dos usuários às questões de uma atividade.
class Resposta {
  final int idUsuario;
  int sequencial;
  Resposta({
    required this.idUsuario,
    required this.sequencial,
  });

  Resposta copyWith({
    int? idUsuario,
    int? sequencial,
  }) {
    return Resposta(
      idUsuario: idUsuario ?? this.idUsuario,
      sequencial: sequencial ?? this.sequencial,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'sequencial': sequencial,
    };
  }

  factory Resposta.fromMap(Map<String, dynamic> map) {
    return Resposta(
      idUsuario: map['idUsuario'],
      sequencial: map['sequencial'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Resposta.fromJson(String source) =>
      Resposta.fromMap(json.decode(source));

  @override
  String toString() =>
      'Resposta(idUsuario: $idUsuario, sequencial: $sequencial)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Resposta &&
        other.idUsuario == idUsuario &&
        other.sequencial == sequencial;
  }

  @override
  int get hashCode => idUsuario.hashCode ^ sequencial.hashCode;
}

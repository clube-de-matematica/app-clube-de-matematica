import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Modelo para os dados das atividades dos clubes.
class Atividade {
  final int id;
  String nome;
  String? descricao;

  /// ID do clube ao qual esta atividade pertence.
  final int idClube;

  /// ID do usuário que criou esta atividade.
  final int idAutor;

  /// Data/hora (no fuso horário UTC) da criação desta atividade.
  final DateTime criacao;

  /// Data/hora (no fuso horário UTC) da publicação desta atividade para os usuários do clube.
  /// Será `NULL` se ainda não tiver sido publicada.
  DateTime? publicacao;

  /// Data/hora (no fuso horário UTC) final para que esta atividade seja concluída.
  DateTime? encerramento;

  /// Lista com as questões incluídas nesta atividade.
  final List<QuestaoAtividade> questoes;

  Atividade({
    required this.id,
    required this.nome,
    this.descricao,
    required this.idClube,
    required this.idAutor,
    required this.criacao,
    this.publicacao,
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
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      idClube: idClube ?? this.idClube,
      idAutor: idAutor ?? this.idAutor,
      criacao: criacao ?? this.criacao,
      publicacao: publicacao ?? this.publicacao,
      encerramento: encerramento ?? this.encerramento,
      questoes: questoes ?? this.questoes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'idClube': idClube,
      'idAutor': idAutor,
      'criacao': criacao.millisecondsSinceEpoch,
      'publicacao': publicacao?.millisecondsSinceEpoch,
      'encerramento': encerramento?.millisecondsSinceEpoch,
      'questoes': questoes.map((x) => x.toMap()).toList(),
    };
  }

  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'] != null ? map['descricao'] : null,
      idClube: map['idClube'],
      idAutor: map['idAutor'],
      criacao: DateTime.fromMillisecondsSinceEpoch(map['criacao']),
      publicacao: map['publicacao'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['publicacao'])
          : null,
      encerramento: map['encerramento'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['encerramento'])
          : null,
      questoes: List<QuestaoAtividade>.from(
          map['questoes']?.map((x) => QuestaoAtividade.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Atividade.fromJson(String source) =>
      Atividade.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Atividade(id: $id, nome: $nome, descricao: $descricao, idClube: $idClube, idAutor: $idAutor, criacao: $criacao, publicacao: $publicacao, encerramento: $encerramento, questoes: $questoes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Atividade &&
        other.id == id &&
        other.nome == nome &&
        other.descricao == descricao &&
        other.idClube == idClube &&
        other.idAutor == idAutor &&
        other.criacao == criacao &&
        other.publicacao == publicacao &&
        other.encerramento == encerramento &&
        listEquals(other.questoes, questoes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        descricao.hashCode ^
        idClube.hashCode ^
        idAutor.hashCode ^
        criacao.hashCode ^
        publicacao.hashCode ^
        encerramento.hashCode ^
        questoes.hashCode;
  }
}

/// Modelo para as questões usadas em uma atividade.
class QuestaoAtividade {
  final int id;
  final int idQuestao;
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
    int? idQuestao,
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

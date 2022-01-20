import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../../../../shared/utils/strings_db.dart';
import 'questao_atividade.dart';
import 'resposta_questao_atividade.dart';

/// Modelo para os dados das atividades dos clubes.
class Atividade extends RawAtividade {
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
  final ObservableList<QuestaoAtividade> questoes;

  /// Lista com as respostas dos usuários às questões incluídas nesta atividade.
  final ObservableSet<RespostaQuestaoAtividade> respostas;

  Atividade({
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

/* 
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
    List<RespostaQuestaoAtividade>? respostas,
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
      respostas: respostas ?? this.respostas,
    );
  }
 */

  static Future<Atividade> fromDataAtividade(DataAtividade map) async {
    final int idAtividade = map[DbConst.kDbDataAtividadeKeyId];

    final respostas = () {
      final dataRespostas =
          map[DbConst.kDbDataAtividadeKeyRespostas] as List? ?? [];
      return dataRespostas.cast<Map>().map((dados) {
        return RespostaQuestaoAtividade.fromDataRespostaQuestaoAtividade(
            dados.cast());
      }).toList();
    }();

    final retorno = Atividade(
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
      questoes: [],
      respostas: respostas,
    );

    final questoes = await () async {
      final dataQuestoes =
          map[DbConst.kDbDataAtividadeKeyQuestoes] as List? ?? [];
      final list = dataQuestoes.cast<Map>().map((dados) async {
        final quest = await Modular.get<QuestoesRepository>().get(
          dados[DbConst.kDbDataQuestaoAtividadeKeyIdQuestaoCaderno],
        );
        if (quest != null)
          return QuestaoAtividade(
            idQuestaoAtividade: dados[DbConst.kDbDataQuestaoAtividadeKeyId],
            questao: quest,
            atividade: retorno,
          );
      });
      return (await Future.wait(list));
    }();

    retorno.questoes.addAll(
      questoes.where((e) => e != null).cast(),
    );

    return retorno;
  }

  /// Sobrescreve os campos desta atividade com os respectivos valores em [outra], desde que
  /// tenham o mesmo ID.
  void sobrescrever(Atividade outra) {
    if (this.id == outra.id) {
      titulo = outra.titulo;
      descricao = outra.descricao;
      liberacao = outra.liberacao;
      encerramento = outra.encerramento;
      questoes.replaceRange(0, questoes.length, outra.questoes);
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

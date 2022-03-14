import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'drift_db.dart';

enum Tabelas {
  questoes,
  assuntos,
  questaoAssunto,
  tiposAlternativa,
  alternativas,
  questoesCaderno,
  usuarios,
  clubes,
  tiposPermissao,
  clubeUsuario,
  atividades,
  questaoAtividade,
  respostaQuestaoAtividade,
  respostaQuestao,
}

abstract class _TbDbLocal extends Table {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  IntColumn get dataModificacao => integer().named('data_modificacao')();
}

@DataClassName('LinTbQuestoes')
class TbQuestoes extends _TbDbLocal {
  IntColumn get id => integer().named('id')();
  TextColumn get enunciado => text().named('enunciado')();
  IntColumn get gabarito => integer().named('gabarito')();
  TextColumn get imagensEnunciado =>
      text().named('imagens_enunciado').nullable()();

  @override
  Set<Column>? get primaryKey => {id};

  @override
  String? get tableName => 'questoes';
}

@DataClassName('LinTbAssuntos')
class TbAssuntos extends _TbDbLocal {
  IntColumn get id => integer().named('id')();
  TextColumn get assunto => text().named('assunto')();
  TextColumn get hierarquia => text().named('hierarquia').nullable()();

  @override
  Set<Column>? get primaryKey => {id};

  @override
  List<String> get customConstraints =>
      const ['UNIQUE ("assunto", "hierarquia")'];

  @override
  String? get tableName => 'assuntos';
}

@DataClassName('LinTbQuestaoAssunto')
class TbQuestaoAssunto extends _TbDbLocal {
  IntColumn get idQuestao => integer().named('id_questao')();
  IntColumn get idAssunto => integer().named('id_assunto')();

  @override
  Set<Column>? get primaryKey => {idQuestao, idAssunto};

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY ("id_questao") REFERENCES "questoes" ("id") ON DELETE CASCADE ON UPDATE CASCADE',
        'FOREIGN KEY ("id_assunto") REFERENCES "assuntos" ("id") ON DELETE RESTRICT ON UPDATE CASCADE',
      ];

  @override
  String? get tableName => 'questao_x_assunto';
}

@DataClassName('LinTbTiposAlternativa')
class TbTiposAlternativa extends _TbDbLocal {
  IntColumn get id => integer().named('id')();
  TextColumn get tipo =>
      text().named('tipo').customConstraint('UNIQUE NOT NULL')();

  @override
  Set<Column>? get primaryKey => {id};

  @override
  String? get tableName => 'tipos_alternativa';
}

@DataClassName('LinTbAlternativas')
class TbAlternativas extends _TbDbLocal {
  IntColumn get idQuestao => integer().named('id_questao')();
  IntColumn get sequencial => integer().named('sequencial')();
  IntColumn get idTipo => integer().named('id_tipo')();
  TextColumn get conteudo => text().named('conteudo')();

  @override
  Set<Column>? get primaryKey => {idQuestao, sequencial};

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY ("id_questao") REFERENCES "questoes" ("id") ON DELETE CASCADE ON UPDATE CASCADE',
        'FOREIGN KEY ("id_tipo") REFERENCES "tipos_alternativa" ("id") ON DELETE RESTRICT ON UPDATE CASCADE',
      ];

  @override
  String? get tableName => 'alternativas';
}

@DataClassName('LinTbQuestoesCaderno')
class TbQuestoesCaderno extends _TbDbLocal {
  TextColumn get id => text().named('id')();
  IntColumn get ano => integer().named('ano')();
  IntColumn get nivel => integer().named('nivel')();
  IntColumn get indice => integer().named('indice')();
  IntColumn get idQuestao => integer().named('id_questao')();

  @override
  Set<Column>? get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY ("id_questao") REFERENCES "questoes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE'
      ];

  @override
  String? get tableName => 'questoes_caderno';
}

@DataClassName('LinTbUsuarios')
class TbUsuarios extends _TbDbLocal {
  IntColumn get id => integer().named('id')();
  TextColumn get email => text().named('email').nullable()();
  TextColumn get nome => text().named('nome').nullable()();
  TextColumn get foto => text().named('foto').nullable()();
  BoolColumn get softDelete =>
      boolean().named('soft_delete').withDefault(Constant(false))();
  BoolColumn get sincronizar =>
      boolean().named('sincronizar').withDefault(Constant(false))();

  @override
  Set<Column>? get primaryKey => {id};

  @override
  String? get tableName => 'usuarios';
}

@DataClassName('LinTbClubes')
class TbClubes extends _TbDbLocal {
  IntColumn get id => integer().named('id')();
  TextColumn get nome =>
      text().named('nome').customConstraint('UNIQUE NOT NULL')();
  TextColumn get descricao => text().named('descricao').nullable()();
  IntColumn get dataCriacao => integer().named('data_criacao')();
  BoolColumn get privado =>
      boolean().named('privado').withDefault(Constant(false))();
  TextColumn get codigo =>
      text().named('codigo').customConstraint('UNIQUE NOT NULL')();
  TextColumn get capa => text().named('capa').nullable()();

  @override
  Set<Column>? get primaryKey => {id};

  @override
  String? get tableName => 'clubes';
}

@DataClassName('LinTbTiposPermissao')
class TbTiposPermissao extends _TbDbLocal {
  IntColumn get id => integer().named('id')();
  TextColumn get permissao =>
      text().named('permissao').customConstraint('UNIQUE NOT NULL')();

  @override
  Set<Column>? get primaryKey => {id};

  @override
  String? get tableName => 'tipos_permissao';
}

@DataClassName('LinTbClubeUsuario')
class TbClubeUsuario extends _TbDbLocal {
  IntColumn get idClube => integer().named('id_clube')();
  IntColumn get idUsuario => integer().named('id_usuario')();
  IntColumn get idPermissao => integer().named('id_permissao')();
  IntColumn get dataAdmissao => integer().named('data_admissao')();

  @override
  Set<Column>? get primaryKey => {idClube, idUsuario};

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY ("id_clube") REFERENCES "clubes" ("id") ON DELETE CASCADE ON UPDATE CASCADE',
        'FOREIGN KEY ("id_usuario") REFERENCES "usuarios" ("id") ON DELETE CASCADE ON UPDATE CASCADE',
        'FOREIGN KEY ("id_permissao") REFERENCES "tipos_permissao" ("id") ON DELETE RESTRICT ON UPDATE CASCADE',
      ];

  @override
  String? get tableName => 'clube_x_usuario';
}

@DataClassName('LinTbAtividades')
class TbAtividades extends _TbDbLocal {
  IntColumn get id => integer().named('id')();
  IntColumn get idClube => integer().named('id_clube')();
  TextColumn get titulo => text().named('titulo')();
  TextColumn get descricao => text().named('descricao').nullable()();
  IntColumn get idAutor => integer().named('id_autor')();
  IntColumn get dataCriacao => integer().named('data_criacao')();
  IntColumn get dataLiberacao => integer().named('data_liberacao').nullable()();
  IntColumn get dataEncerramento =>
      integer().named('data_encerramento').nullable()();

  @override
  Set<Column>? get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY ("id_clube") REFERENCES "clubes" ("id") ON DELETE CASCADE ON UPDATE CASCADE',
        // A intenção é que um usuário nunca seja excluído. Em vez disso o campo "soft_delete"
        // deve ser marcado como verdadeiro. A cláusula "ON DELETE RESTRICT" é apenas uma
        // garantia extra.
        'FOREIGN KEY ("id_autor") REFERENCES "usuarios" ("id") ON DELETE RESTRICT ON UPDATE CASCADE',
      ];

  @override
  String? get tableName => 'atividades';
}

@DataClassName('LinTbQuestaoAtividade')
class TbQuestaoAtividade extends _TbDbLocal {
  IntColumn get id => integer().named('id')();
  TextColumn get idQuestaoCaderno => text().named('id_questao_caderno')();
  IntColumn get idAtividade => integer().named('id_atividade')();

  @override
  Set<Column>? get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        'UNIQUE ("id_atividade", "id_questao_caderno")',
        'FOREIGN KEY ("id_questao_caderno") REFERENCES "questoes_caderno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE',
        'FOREIGN KEY ("id_atividade") REFERENCES "atividades" ("id") ON DELETE CASCADE ON UPDATE CASCADE',
      ];

  @override
  String? get tableName => 'questao_x_atividade';
}

@DataClassName('LinTbRespostaQuestaoAtividade')
class TbRespostaQuestaoAtividade extends _TbDbLocal {
  IntColumn get idQuestaoAtividade =>
      integer().named('id_questao_x_atividade')();
  IntColumn get idUsuario => integer().named('id_usuario')();
  IntColumn get resposta => integer().named('resposta').nullable()();
  BoolColumn get sincronizar =>
      boolean().named('sincronizar').withDefault(Constant(false))();

  @override
  Set<Column>? get primaryKey => {idQuestaoAtividade, idUsuario};

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY ("id_questao_x_atividade") REFERENCES "questao_x_atividade" ("id") ON DELETE CASCADE ON UPDATE CASCADE',
        'FOREIGN KEY ("id_usuario") REFERENCES "usuarios" ("id") ON DELETE CASCADE ON UPDATE CASCADE',
      ];

  @override
  String? get tableName => 'resposta_x_questao_x_atividade';
}

@DataClassName('LinTbRespostaQuestao')
class TbRespostaQuestao extends _TbDbLocal {
  IntColumn get idQuestao => integer().named('id_questao')();
  IntColumn get idUsuario => integer().named('id_usuario').nullable()();
  IntColumn get resposta => integer().named('resposta').nullable()();
  BoolColumn get sincronizar =>
      boolean().named('sincronizar').withDefault(Constant(false))();

  @override
  Set<Column>? get primaryKey => {idQuestao /* , idUsuario */};

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY ("id_questao") REFERENCES "questoes" ("id") ON DELETE CASCADE ON UPDATE CASCADE',
        //'FOREIGN KEY ("id_usuario") REFERENCES "usuarios" ("id") ON DELETE CASCADE ON UPDATE CASCADE',
      ];

  @override
  String? get tableName => 'resposta_x_questao';
}

class LinViewQuestoes {
  final String idAlfanumerico;
  final int id;
  final int ano;
  final int nivel;
  final int indice;
  final String enunciado;
  final int gabarito;
  final List<LinTbAssuntos> assuntos;
  final List<LinTbAlternativas> alternativas;
  final String? imagensEnunciado;
  LinViewQuestoes({
    required this.idAlfanumerico,
    required this.id,
    required this.ano,
    required this.nivel,
    required this.indice,
    required this.enunciado,
    required this.gabarito,
    required this.assuntos,
    required this.alternativas,
    this.imagensEnunciado,
  });

  @override
  String toString() {
    return (StringBuffer('LinViewQuestoes(')
          ..write('idAlfanumerico: $idAlfanumerico, ')
          ..write('id: $id, ')
          ..write('ano: $ano, ')
          ..write('nivel: $nivel, ')
          ..write('indice: $indice, ')
          ..write('enunciado: $enunciado, ')
          ..write('gabarito: $gabarito, ')
          ..write('assuntos: $assuntos, ')
          ..write('alternativas: $alternativas, ')
          ..write('imagensEnunciad: $imagensEnunciado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        idAlfanumerico,
        id,
        ano,
        nivel,
        indice,
        enunciado,
        gabarito,
        assuntos,
        alternativas,
        imagensEnunciado,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinViewQuestoes &&
          other.idAlfanumerico == this.idAlfanumerico &&
          other.id == this.id &&
          other.ano == this.ano &&
          other.nivel == this.nivel &&
          other.indice == this.indice &&
          other.enunciado == this.enunciado &&
          other.gabarito == this.gabarito &&
          listEquals(other.assuntos, this.assuntos) &&
          listEquals(other.alternativas, this.alternativas) &&
          other.imagensEnunciado == this.imagensEnunciado);
}

class LinViewClubes {
  final int id;
  final String nome;
  final String? descricao;
  final int dataCriacao;
  final bool privado;
  final String codigo;
  final String? capa;
  final String usuarios;
  LinViewClubes({
    required this.id,
    required this.nome,
    this.descricao,
    required this.dataCriacao,
    required this.privado,
    required this.codigo,
    this.capa,
    required this.usuarios,
  });

  @override
  String toString() {
    return (StringBuffer('LinViewClubes(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('privado: $privado, ')
          ..write('codigo: $codigo, ')
          ..write('capa: $capa, ')
          ..write('usuarios: $usuarios')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        id,
        nome,
        descricao,
        dataCriacao,
        privado,
        codigo,
        capa,
        usuarios,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinViewClubes &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.descricao == this.descricao &&
          other.dataCriacao == this.dataCriacao &&
          other.privado == this.privado &&
          other.codigo == this.codigo &&
          other.capa == this.capa &&
          other.usuarios == this.usuarios);
}

class LinViewAtividades {
  final int id;
  final int idClube;
  final String titulo;
  final String? descricao;
  final int idAutor;
  final int dataCriacao;
  final int? dataLiberacao;
  final int? dataEncerramento;
  final List<LinTbQuestaoAtividade> questoes;
  final List<LinTbRespostaQuestaoAtividade> respostas;

  LinViewAtividades({
    required this.id,
    required this.idClube,
    required this.titulo,
    this.descricao,
    required this.idAutor,
    required this.dataCriacao,
    this.dataLiberacao,
    this.dataEncerramento,
    required this.questoes,
    required this.respostas,
  });

  @override
  String toString() {
    return (StringBuffer('LinViewAtividades(')
          ..write('id: $id, ')
          ..write('idClube: $idClube, ')
          ..write('titulo: $titulo, ')
          ..write('descricao: $descricao, ')
          ..write('idAutor: $idAutor, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataLiberacao: $dataLiberacao, ')
          ..write('dataEncerramento: $dataEncerramento, ')
          ..write('questoes: $questoes, ')
          ..write('respostas: $respostas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        id,
        idClube,
        titulo,
        descricao,
        idAutor,
        dataCriacao,
        dataLiberacao,
        dataEncerramento,
        questoes,
        respostas,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinViewAtividades &&
          other.id == this.id &&
          other.idClube == this.idClube &&
          other.titulo == this.titulo &&
          other.descricao == this.descricao &&
          other.idAutor == this.idAutor &&
          other.dataCriacao == this.dataCriacao &&
          other.dataLiberacao == this.dataLiberacao &&
          other.dataEncerramento == this.dataEncerramento &&
          listEquals(other.questoes, this.questoes) &&
          listEquals(other.respostas, this.respostas));
}

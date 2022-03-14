// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class LinTbQuestoes extends DataClass implements Insertable<LinTbQuestoes> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int id;
  final String enunciado;
  final int gabarito;
  final String? imagensEnunciado;
  LinTbQuestoes(
      {required this.dataModificacao,
      required this.id,
      required this.enunciado,
      required this.gabarito,
      this.imagensEnunciado});
  factory LinTbQuestoes.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbQuestoes(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      enunciado: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}enunciado'])!,
      gabarito: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gabarito'])!,
      imagensEnunciado: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}imagens_enunciado']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id'] = Variable<int>(id);
    map['enunciado'] = Variable<String>(enunciado);
    map['gabarito'] = Variable<int>(gabarito);
    if (!nullToAbsent || imagensEnunciado != null) {
      map['imagens_enunciado'] = Variable<String?>(imagensEnunciado);
    }
    return map;
  }

  TbQuestoesCompanion toCompanion(bool nullToAbsent) {
    return TbQuestoesCompanion(
      dataModificacao: Value(dataModificacao),
      id: Value(id),
      enunciado: Value(enunciado),
      gabarito: Value(gabarito),
      imagensEnunciado: imagensEnunciado == null && nullToAbsent
          ? const Value.absent()
          : Value(imagensEnunciado),
    );
  }

  factory LinTbQuestoes.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbQuestoes(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      id: serializer.fromJson<int>(json['id']),
      enunciado: serializer.fromJson<String>(json['enunciado']),
      gabarito: serializer.fromJson<int>(json['gabarito']),
      imagensEnunciado: serializer.fromJson<String?>(json['imagensEnunciado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'id': serializer.toJson<int>(id),
      'enunciado': serializer.toJson<String>(enunciado),
      'gabarito': serializer.toJson<int>(gabarito),
      'imagensEnunciado': serializer.toJson<String?>(imagensEnunciado),
    };
  }

  LinTbQuestoes copyWith(
          {int? dataModificacao,
          int? id,
          String? enunciado,
          int? gabarito,
          String? imagensEnunciado}) =>
      LinTbQuestoes(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        id: id ?? this.id,
        enunciado: enunciado ?? this.enunciado,
        gabarito: gabarito ?? this.gabarito,
        imagensEnunciado: imagensEnunciado ?? this.imagensEnunciado,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbQuestoes(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('enunciado: $enunciado, ')
          ..write('gabarito: $gabarito, ')
          ..write('imagensEnunciado: $imagensEnunciado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dataModificacao, id, enunciado, gabarito, imagensEnunciado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbQuestoes &&
          other.dataModificacao == this.dataModificacao &&
          other.id == this.id &&
          other.enunciado == this.enunciado &&
          other.gabarito == this.gabarito &&
          other.imagensEnunciado == this.imagensEnunciado);
}

class TbQuestoesCompanion extends UpdateCompanion<LinTbQuestoes> {
  final Value<int> dataModificacao;
  final Value<int> id;
  final Value<String> enunciado;
  final Value<int> gabarito;
  final Value<String?> imagensEnunciado;
  const TbQuestoesCompanion({
    this.dataModificacao = const Value.absent(),
    this.id = const Value.absent(),
    this.enunciado = const Value.absent(),
    this.gabarito = const Value.absent(),
    this.imagensEnunciado = const Value.absent(),
  });
  TbQuestoesCompanion.insert({
    required int dataModificacao,
    this.id = const Value.absent(),
    required String enunciado,
    required int gabarito,
    this.imagensEnunciado = const Value.absent(),
  })  : dataModificacao = Value(dataModificacao),
        enunciado = Value(enunciado),
        gabarito = Value(gabarito);
  static Insertable<LinTbQuestoes> custom({
    Expression<int>? dataModificacao,
    Expression<int>? id,
    Expression<String>? enunciado,
    Expression<int>? gabarito,
    Expression<String?>? imagensEnunciado,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (id != null) 'id': id,
      if (enunciado != null) 'enunciado': enunciado,
      if (gabarito != null) 'gabarito': gabarito,
      if (imagensEnunciado != null) 'imagens_enunciado': imagensEnunciado,
    });
  }

  TbQuestoesCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? id,
      Value<String>? enunciado,
      Value<int>? gabarito,
      Value<String?>? imagensEnunciado}) {
    return TbQuestoesCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      id: id ?? this.id,
      enunciado: enunciado ?? this.enunciado,
      gabarito: gabarito ?? this.gabarito,
      imagensEnunciado: imagensEnunciado ?? this.imagensEnunciado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (enunciado.present) {
      map['enunciado'] = Variable<String>(enunciado.value);
    }
    if (gabarito.present) {
      map['gabarito'] = Variable<int>(gabarito.value);
    }
    if (imagensEnunciado.present) {
      map['imagens_enunciado'] = Variable<String?>(imagensEnunciado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbQuestoesCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('enunciado: $enunciado, ')
          ..write('gabarito: $gabarito, ')
          ..write('imagensEnunciado: $imagensEnunciado')
          ..write(')'))
        .toString();
  }
}

class $TbQuestoesTable extends TbQuestoes
    with TableInfo<$TbQuestoesTable, LinTbQuestoes> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbQuestoesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _enunciadoMeta = const VerificationMeta('enunciado');
  @override
  late final GeneratedColumn<String?> enunciado = GeneratedColumn<String?>(
      'enunciado', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _gabaritoMeta = const VerificationMeta('gabarito');
  @override
  late final GeneratedColumn<int?> gabarito = GeneratedColumn<int?>(
      'gabarito', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _imagensEnunciadoMeta =
      const VerificationMeta('imagensEnunciado');
  @override
  late final GeneratedColumn<String?> imagensEnunciado =
      GeneratedColumn<String?>('imagens_enunciado', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [dataModificacao, id, enunciado, gabarito, imagensEnunciado];
  @override
  String get aliasedName => _alias ?? 'questoes';
  @override
  String get actualTableName => 'questoes';
  @override
  VerificationContext validateIntegrity(Insertable<LinTbQuestoes> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enunciado')) {
      context.handle(_enunciadoMeta,
          enunciado.isAcceptableOrUnknown(data['enunciado']!, _enunciadoMeta));
    } else if (isInserting) {
      context.missing(_enunciadoMeta);
    }
    if (data.containsKey('gabarito')) {
      context.handle(_gabaritoMeta,
          gabarito.isAcceptableOrUnknown(data['gabarito']!, _gabaritoMeta));
    } else if (isInserting) {
      context.missing(_gabaritoMeta);
    }
    if (data.containsKey('imagens_enunciado')) {
      context.handle(
          _imagensEnunciadoMeta,
          imagensEnunciado.isAcceptableOrUnknown(
              data['imagens_enunciado']!, _imagensEnunciadoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinTbQuestoes map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbQuestoes.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbQuestoesTable createAlias(String alias) {
    return $TbQuestoesTable(attachedDatabase, alias);
  }
}

class LinTbAssuntos extends DataClass implements Insertable<LinTbAssuntos> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int id;
  final String assunto;
  final String? hierarquia;
  LinTbAssuntos(
      {required this.dataModificacao,
      required this.id,
      required this.assunto,
      this.hierarquia});
  factory LinTbAssuntos.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbAssuntos(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      assunto: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}assunto'])!,
      hierarquia: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}hierarquia']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id'] = Variable<int>(id);
    map['assunto'] = Variable<String>(assunto);
    if (!nullToAbsent || hierarquia != null) {
      map['hierarquia'] = Variable<String?>(hierarquia);
    }
    return map;
  }

  TbAssuntosCompanion toCompanion(bool nullToAbsent) {
    return TbAssuntosCompanion(
      dataModificacao: Value(dataModificacao),
      id: Value(id),
      assunto: Value(assunto),
      hierarquia: hierarquia == null && nullToAbsent
          ? const Value.absent()
          : Value(hierarquia),
    );
  }

  factory LinTbAssuntos.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbAssuntos(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      id: serializer.fromJson<int>(json['id']),
      assunto: serializer.fromJson<String>(json['assunto']),
      hierarquia: serializer.fromJson<String?>(json['hierarquia']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'id': serializer.toJson<int>(id),
      'assunto': serializer.toJson<String>(assunto),
      'hierarquia': serializer.toJson<String?>(hierarquia),
    };
  }

  LinTbAssuntos copyWith(
          {int? dataModificacao,
          int? id,
          String? assunto,
          String? hierarquia}) =>
      LinTbAssuntos(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        id: id ?? this.id,
        assunto: assunto ?? this.assunto,
        hierarquia: hierarquia ?? this.hierarquia,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbAssuntos(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('assunto: $assunto, ')
          ..write('hierarquia: $hierarquia')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dataModificacao, id, assunto, hierarquia);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbAssuntos &&
          other.dataModificacao == this.dataModificacao &&
          other.id == this.id &&
          other.assunto == this.assunto &&
          other.hierarquia == this.hierarquia);
}

class TbAssuntosCompanion extends UpdateCompanion<LinTbAssuntos> {
  final Value<int> dataModificacao;
  final Value<int> id;
  final Value<String> assunto;
  final Value<String?> hierarquia;
  const TbAssuntosCompanion({
    this.dataModificacao = const Value.absent(),
    this.id = const Value.absent(),
    this.assunto = const Value.absent(),
    this.hierarquia = const Value.absent(),
  });
  TbAssuntosCompanion.insert({
    required int dataModificacao,
    this.id = const Value.absent(),
    required String assunto,
    this.hierarquia = const Value.absent(),
  })  : dataModificacao = Value(dataModificacao),
        assunto = Value(assunto);
  static Insertable<LinTbAssuntos> custom({
    Expression<int>? dataModificacao,
    Expression<int>? id,
    Expression<String>? assunto,
    Expression<String?>? hierarquia,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (id != null) 'id': id,
      if (assunto != null) 'assunto': assunto,
      if (hierarquia != null) 'hierarquia': hierarquia,
    });
  }

  TbAssuntosCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? id,
      Value<String>? assunto,
      Value<String?>? hierarquia}) {
    return TbAssuntosCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      id: id ?? this.id,
      assunto: assunto ?? this.assunto,
      hierarquia: hierarquia ?? this.hierarquia,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (assunto.present) {
      map['assunto'] = Variable<String>(assunto.value);
    }
    if (hierarquia.present) {
      map['hierarquia'] = Variable<String?>(hierarquia.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbAssuntosCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('assunto: $assunto, ')
          ..write('hierarquia: $hierarquia')
          ..write(')'))
        .toString();
  }
}

class $TbAssuntosTable extends TbAssuntos
    with TableInfo<$TbAssuntosTable, LinTbAssuntos> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbAssuntosTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _assuntoMeta = const VerificationMeta('assunto');
  @override
  late final GeneratedColumn<String?> assunto = GeneratedColumn<String?>(
      'assunto', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _hierarquiaMeta = const VerificationMeta('hierarquia');
  @override
  late final GeneratedColumn<String?> hierarquia = GeneratedColumn<String?>(
      'hierarquia', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [dataModificacao, id, assunto, hierarquia];
  @override
  String get aliasedName => _alias ?? 'assuntos';
  @override
  String get actualTableName => 'assuntos';
  @override
  VerificationContext validateIntegrity(Insertable<LinTbAssuntos> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('assunto')) {
      context.handle(_assuntoMeta,
          assunto.isAcceptableOrUnknown(data['assunto']!, _assuntoMeta));
    } else if (isInserting) {
      context.missing(_assuntoMeta);
    }
    if (data.containsKey('hierarquia')) {
      context.handle(
          _hierarquiaMeta,
          hierarquia.isAcceptableOrUnknown(
              data['hierarquia']!, _hierarquiaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinTbAssuntos map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbAssuntos.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbAssuntosTable createAlias(String alias) {
    return $TbAssuntosTable(attachedDatabase, alias);
  }
}

class LinTbQuestaoAssunto extends DataClass
    implements Insertable<LinTbQuestaoAssunto> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int idQuestao;
  final int idAssunto;
  LinTbQuestaoAssunto(
      {required this.dataModificacao,
      required this.idQuestao,
      required this.idAssunto});
  factory LinTbQuestaoAssunto.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbQuestaoAssunto(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      idQuestao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_questao'])!,
      idAssunto: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_assunto'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id_questao'] = Variable<int>(idQuestao);
    map['id_assunto'] = Variable<int>(idAssunto);
    return map;
  }

  TbQuestaoAssuntoCompanion toCompanion(bool nullToAbsent) {
    return TbQuestaoAssuntoCompanion(
      dataModificacao: Value(dataModificacao),
      idQuestao: Value(idQuestao),
      idAssunto: Value(idAssunto),
    );
  }

  factory LinTbQuestaoAssunto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbQuestaoAssunto(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      idQuestao: serializer.fromJson<int>(json['idQuestao']),
      idAssunto: serializer.fromJson<int>(json['idAssunto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'idQuestao': serializer.toJson<int>(idQuestao),
      'idAssunto': serializer.toJson<int>(idAssunto),
    };
  }

  LinTbQuestaoAssunto copyWith(
          {int? dataModificacao, int? idQuestao, int? idAssunto}) =>
      LinTbQuestaoAssunto(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        idQuestao: idQuestao ?? this.idQuestao,
        idAssunto: idAssunto ?? this.idAssunto,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbQuestaoAssunto(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('idQuestao: $idQuestao, ')
          ..write('idAssunto: $idAssunto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dataModificacao, idQuestao, idAssunto);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbQuestaoAssunto &&
          other.dataModificacao == this.dataModificacao &&
          other.idQuestao == this.idQuestao &&
          other.idAssunto == this.idAssunto);
}

class TbQuestaoAssuntoCompanion extends UpdateCompanion<LinTbQuestaoAssunto> {
  final Value<int> dataModificacao;
  final Value<int> idQuestao;
  final Value<int> idAssunto;
  const TbQuestaoAssuntoCompanion({
    this.dataModificacao = const Value.absent(),
    this.idQuestao = const Value.absent(),
    this.idAssunto = const Value.absent(),
  });
  TbQuestaoAssuntoCompanion.insert({
    required int dataModificacao,
    required int idQuestao,
    required int idAssunto,
  })  : dataModificacao = Value(dataModificacao),
        idQuestao = Value(idQuestao),
        idAssunto = Value(idAssunto);
  static Insertable<LinTbQuestaoAssunto> custom({
    Expression<int>? dataModificacao,
    Expression<int>? idQuestao,
    Expression<int>? idAssunto,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (idQuestao != null) 'id_questao': idQuestao,
      if (idAssunto != null) 'id_assunto': idAssunto,
    });
  }

  TbQuestaoAssuntoCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? idQuestao,
      Value<int>? idAssunto}) {
    return TbQuestaoAssuntoCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      idQuestao: idQuestao ?? this.idQuestao,
      idAssunto: idAssunto ?? this.idAssunto,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (idQuestao.present) {
      map['id_questao'] = Variable<int>(idQuestao.value);
    }
    if (idAssunto.present) {
      map['id_assunto'] = Variable<int>(idAssunto.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbQuestaoAssuntoCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('idQuestao: $idQuestao, ')
          ..write('idAssunto: $idAssunto')
          ..write(')'))
        .toString();
  }
}

class $TbQuestaoAssuntoTable extends TbQuestaoAssunto
    with TableInfo<$TbQuestaoAssuntoTable, LinTbQuestaoAssunto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbQuestaoAssuntoTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idQuestaoMeta = const VerificationMeta('idQuestao');
  @override
  late final GeneratedColumn<int?> idQuestao = GeneratedColumn<int?>(
      'id_questao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idAssuntoMeta = const VerificationMeta('idAssunto');
  @override
  late final GeneratedColumn<int?> idAssunto = GeneratedColumn<int?>(
      'id_assunto', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [dataModificacao, idQuestao, idAssunto];
  @override
  String get aliasedName => _alias ?? 'questao_x_assunto';
  @override
  String get actualTableName => 'questao_x_assunto';
  @override
  VerificationContext validateIntegrity(
      Insertable<LinTbQuestaoAssunto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id_questao')) {
      context.handle(_idQuestaoMeta,
          idQuestao.isAcceptableOrUnknown(data['id_questao']!, _idQuestaoMeta));
    } else if (isInserting) {
      context.missing(_idQuestaoMeta);
    }
    if (data.containsKey('id_assunto')) {
      context.handle(_idAssuntoMeta,
          idAssunto.isAcceptableOrUnknown(data['id_assunto']!, _idAssuntoMeta));
    } else if (isInserting) {
      context.missing(_idAssuntoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idQuestao, idAssunto};
  @override
  LinTbQuestaoAssunto map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbQuestaoAssunto.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbQuestaoAssuntoTable createAlias(String alias) {
    return $TbQuestaoAssuntoTable(attachedDatabase, alias);
  }
}

class LinTbTiposAlternativa extends DataClass
    implements Insertable<LinTbTiposAlternativa> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int id;
  final String tipo;
  LinTbTiposAlternativa(
      {required this.dataModificacao, required this.id, required this.tipo});
  factory LinTbTiposAlternativa.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbTiposAlternativa(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      tipo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tipo'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id'] = Variable<int>(id);
    map['tipo'] = Variable<String>(tipo);
    return map;
  }

  TbTiposAlternativaCompanion toCompanion(bool nullToAbsent) {
    return TbTiposAlternativaCompanion(
      dataModificacao: Value(dataModificacao),
      id: Value(id),
      tipo: Value(tipo),
    );
  }

  factory LinTbTiposAlternativa.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbTiposAlternativa(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      id: serializer.fromJson<int>(json['id']),
      tipo: serializer.fromJson<String>(json['tipo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<String>(tipo),
    };
  }

  LinTbTiposAlternativa copyWith(
          {int? dataModificacao, int? id, String? tipo}) =>
      LinTbTiposAlternativa(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        id: id ?? this.id,
        tipo: tipo ?? this.tipo,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbTiposAlternativa(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dataModificacao, id, tipo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbTiposAlternativa &&
          other.dataModificacao == this.dataModificacao &&
          other.id == this.id &&
          other.tipo == this.tipo);
}

class TbTiposAlternativaCompanion
    extends UpdateCompanion<LinTbTiposAlternativa> {
  final Value<int> dataModificacao;
  final Value<int> id;
  final Value<String> tipo;
  const TbTiposAlternativaCompanion({
    this.dataModificacao = const Value.absent(),
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
  });
  TbTiposAlternativaCompanion.insert({
    required int dataModificacao,
    this.id = const Value.absent(),
    required String tipo,
  })  : dataModificacao = Value(dataModificacao),
        tipo = Value(tipo);
  static Insertable<LinTbTiposAlternativa> custom({
    Expression<int>? dataModificacao,
    Expression<int>? id,
    Expression<String>? tipo,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
    });
  }

  TbTiposAlternativaCompanion copyWith(
      {Value<int>? dataModificacao, Value<int>? id, Value<String>? tipo}) {
    return TbTiposAlternativaCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbTiposAlternativaCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('tipo: $tipo')
          ..write(')'))
        .toString();
  }
}

class $TbTiposAlternativaTable extends TbTiposAlternativa
    with TableInfo<$TbTiposAlternativaTable, LinTbTiposAlternativa> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbTiposAlternativaTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String?> tipo = GeneratedColumn<String?>(
      'tipo', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [dataModificacao, id, tipo];
  @override
  String get aliasedName => _alias ?? 'tipos_alternativa';
  @override
  String get actualTableName => 'tipos_alternativa';
  @override
  VerificationContext validateIntegrity(
      Insertable<LinTbTiposAlternativa> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinTbTiposAlternativa map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbTiposAlternativa.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbTiposAlternativaTable createAlias(String alias) {
    return $TbTiposAlternativaTable(attachedDatabase, alias);
  }
}

class LinTbAlternativas extends DataClass
    implements Insertable<LinTbAlternativas> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int idQuestao;
  final int sequencial;
  final int idTipo;
  final String conteudo;
  LinTbAlternativas(
      {required this.dataModificacao,
      required this.idQuestao,
      required this.sequencial,
      required this.idTipo,
      required this.conteudo});
  factory LinTbAlternativas.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbAlternativas(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      idQuestao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_questao'])!,
      sequencial: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sequencial'])!,
      idTipo: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_tipo'])!,
      conteudo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}conteudo'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id_questao'] = Variable<int>(idQuestao);
    map['sequencial'] = Variable<int>(sequencial);
    map['id_tipo'] = Variable<int>(idTipo);
    map['conteudo'] = Variable<String>(conteudo);
    return map;
  }

  TbAlternativasCompanion toCompanion(bool nullToAbsent) {
    return TbAlternativasCompanion(
      dataModificacao: Value(dataModificacao),
      idQuestao: Value(idQuestao),
      sequencial: Value(sequencial),
      idTipo: Value(idTipo),
      conteudo: Value(conteudo),
    );
  }

  factory LinTbAlternativas.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbAlternativas(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      idQuestao: serializer.fromJson<int>(json['idQuestao']),
      sequencial: serializer.fromJson<int>(json['sequencial']),
      idTipo: serializer.fromJson<int>(json['idTipo']),
      conteudo: serializer.fromJson<String>(json['conteudo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'idQuestao': serializer.toJson<int>(idQuestao),
      'sequencial': serializer.toJson<int>(sequencial),
      'idTipo': serializer.toJson<int>(idTipo),
      'conteudo': serializer.toJson<String>(conteudo),
    };
  }

  LinTbAlternativas copyWith(
          {int? dataModificacao,
          int? idQuestao,
          int? sequencial,
          int? idTipo,
          String? conteudo}) =>
      LinTbAlternativas(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        idQuestao: idQuestao ?? this.idQuestao,
        sequencial: sequencial ?? this.sequencial,
        idTipo: idTipo ?? this.idTipo,
        conteudo: conteudo ?? this.conteudo,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbAlternativas(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('idQuestao: $idQuestao, ')
          ..write('sequencial: $sequencial, ')
          ..write('idTipo: $idTipo, ')
          ..write('conteudo: $conteudo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dataModificacao, idQuestao, sequencial, idTipo, conteudo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbAlternativas &&
          other.dataModificacao == this.dataModificacao &&
          other.idQuestao == this.idQuestao &&
          other.sequencial == this.sequencial &&
          other.idTipo == this.idTipo &&
          other.conteudo == this.conteudo);
}

class TbAlternativasCompanion extends UpdateCompanion<LinTbAlternativas> {
  final Value<int> dataModificacao;
  final Value<int> idQuestao;
  final Value<int> sequencial;
  final Value<int> idTipo;
  final Value<String> conteudo;
  const TbAlternativasCompanion({
    this.dataModificacao = const Value.absent(),
    this.idQuestao = const Value.absent(),
    this.sequencial = const Value.absent(),
    this.idTipo = const Value.absent(),
    this.conteudo = const Value.absent(),
  });
  TbAlternativasCompanion.insert({
    required int dataModificacao,
    required int idQuestao,
    required int sequencial,
    required int idTipo,
    required String conteudo,
  })  : dataModificacao = Value(dataModificacao),
        idQuestao = Value(idQuestao),
        sequencial = Value(sequencial),
        idTipo = Value(idTipo),
        conteudo = Value(conteudo);
  static Insertable<LinTbAlternativas> custom({
    Expression<int>? dataModificacao,
    Expression<int>? idQuestao,
    Expression<int>? sequencial,
    Expression<int>? idTipo,
    Expression<String>? conteudo,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (idQuestao != null) 'id_questao': idQuestao,
      if (sequencial != null) 'sequencial': sequencial,
      if (idTipo != null) 'id_tipo': idTipo,
      if (conteudo != null) 'conteudo': conteudo,
    });
  }

  TbAlternativasCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? idQuestao,
      Value<int>? sequencial,
      Value<int>? idTipo,
      Value<String>? conteudo}) {
    return TbAlternativasCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      idQuestao: idQuestao ?? this.idQuestao,
      sequencial: sequencial ?? this.sequencial,
      idTipo: idTipo ?? this.idTipo,
      conteudo: conteudo ?? this.conteudo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (idQuestao.present) {
      map['id_questao'] = Variable<int>(idQuestao.value);
    }
    if (sequencial.present) {
      map['sequencial'] = Variable<int>(sequencial.value);
    }
    if (idTipo.present) {
      map['id_tipo'] = Variable<int>(idTipo.value);
    }
    if (conteudo.present) {
      map['conteudo'] = Variable<String>(conteudo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbAlternativasCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('idQuestao: $idQuestao, ')
          ..write('sequencial: $sequencial, ')
          ..write('idTipo: $idTipo, ')
          ..write('conteudo: $conteudo')
          ..write(')'))
        .toString();
  }
}

class $TbAlternativasTable extends TbAlternativas
    with TableInfo<$TbAlternativasTable, LinTbAlternativas> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbAlternativasTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idQuestaoMeta = const VerificationMeta('idQuestao');
  @override
  late final GeneratedColumn<int?> idQuestao = GeneratedColumn<int?>(
      'id_questao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _sequencialMeta = const VerificationMeta('sequencial');
  @override
  late final GeneratedColumn<int?> sequencial = GeneratedColumn<int?>(
      'sequencial', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idTipoMeta = const VerificationMeta('idTipo');
  @override
  late final GeneratedColumn<int?> idTipo = GeneratedColumn<int?>(
      'id_tipo', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _conteudoMeta = const VerificationMeta('conteudo');
  @override
  late final GeneratedColumn<String?> conteudo = GeneratedColumn<String?>(
      'conteudo', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [dataModificacao, idQuestao, sequencial, idTipo, conteudo];
  @override
  String get aliasedName => _alias ?? 'alternativas';
  @override
  String get actualTableName => 'alternativas';
  @override
  VerificationContext validateIntegrity(Insertable<LinTbAlternativas> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id_questao')) {
      context.handle(_idQuestaoMeta,
          idQuestao.isAcceptableOrUnknown(data['id_questao']!, _idQuestaoMeta));
    } else if (isInserting) {
      context.missing(_idQuestaoMeta);
    }
    if (data.containsKey('sequencial')) {
      context.handle(
          _sequencialMeta,
          sequencial.isAcceptableOrUnknown(
              data['sequencial']!, _sequencialMeta));
    } else if (isInserting) {
      context.missing(_sequencialMeta);
    }
    if (data.containsKey('id_tipo')) {
      context.handle(_idTipoMeta,
          idTipo.isAcceptableOrUnknown(data['id_tipo']!, _idTipoMeta));
    } else if (isInserting) {
      context.missing(_idTipoMeta);
    }
    if (data.containsKey('conteudo')) {
      context.handle(_conteudoMeta,
          conteudo.isAcceptableOrUnknown(data['conteudo']!, _conteudoMeta));
    } else if (isInserting) {
      context.missing(_conteudoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idQuestao, sequencial};
  @override
  LinTbAlternativas map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbAlternativas.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbAlternativasTable createAlias(String alias) {
    return $TbAlternativasTable(attachedDatabase, alias);
  }
}

class LinTbQuestoesCaderno extends DataClass
    implements Insertable<LinTbQuestoesCaderno> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final String id;
  final int ano;
  final int nivel;
  final int indice;
  final int idQuestao;
  LinTbQuestoesCaderno(
      {required this.dataModificacao,
      required this.id,
      required this.ano,
      required this.nivel,
      required this.indice,
      required this.idQuestao});
  factory LinTbQuestoesCaderno.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbQuestoesCaderno(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      ano: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ano'])!,
      nivel: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nivel'])!,
      indice: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}indice'])!,
      idQuestao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_questao'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id'] = Variable<String>(id);
    map['ano'] = Variable<int>(ano);
    map['nivel'] = Variable<int>(nivel);
    map['indice'] = Variable<int>(indice);
    map['id_questao'] = Variable<int>(idQuestao);
    return map;
  }

  TbQuestoesCadernoCompanion toCompanion(bool nullToAbsent) {
    return TbQuestoesCadernoCompanion(
      dataModificacao: Value(dataModificacao),
      id: Value(id),
      ano: Value(ano),
      nivel: Value(nivel),
      indice: Value(indice),
      idQuestao: Value(idQuestao),
    );
  }

  factory LinTbQuestoesCaderno.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbQuestoesCaderno(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      id: serializer.fromJson<String>(json['id']),
      ano: serializer.fromJson<int>(json['ano']),
      nivel: serializer.fromJson<int>(json['nivel']),
      indice: serializer.fromJson<int>(json['indice']),
      idQuestao: serializer.fromJson<int>(json['idQuestao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'id': serializer.toJson<String>(id),
      'ano': serializer.toJson<int>(ano),
      'nivel': serializer.toJson<int>(nivel),
      'indice': serializer.toJson<int>(indice),
      'idQuestao': serializer.toJson<int>(idQuestao),
    };
  }

  LinTbQuestoesCaderno copyWith(
          {int? dataModificacao,
          String? id,
          int? ano,
          int? nivel,
          int? indice,
          int? idQuestao}) =>
      LinTbQuestoesCaderno(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        id: id ?? this.id,
        ano: ano ?? this.ano,
        nivel: nivel ?? this.nivel,
        indice: indice ?? this.indice,
        idQuestao: idQuestao ?? this.idQuestao,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbQuestoesCaderno(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('ano: $ano, ')
          ..write('nivel: $nivel, ')
          ..write('indice: $indice, ')
          ..write('idQuestao: $idQuestao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dataModificacao, id, ano, nivel, indice, idQuestao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbQuestoesCaderno &&
          other.dataModificacao == this.dataModificacao &&
          other.id == this.id &&
          other.ano == this.ano &&
          other.nivel == this.nivel &&
          other.indice == this.indice &&
          other.idQuestao == this.idQuestao);
}

class TbQuestoesCadernoCompanion extends UpdateCompanion<LinTbQuestoesCaderno> {
  final Value<int> dataModificacao;
  final Value<String> id;
  final Value<int> ano;
  final Value<int> nivel;
  final Value<int> indice;
  final Value<int> idQuestao;
  const TbQuestoesCadernoCompanion({
    this.dataModificacao = const Value.absent(),
    this.id = const Value.absent(),
    this.ano = const Value.absent(),
    this.nivel = const Value.absent(),
    this.indice = const Value.absent(),
    this.idQuestao = const Value.absent(),
  });
  TbQuestoesCadernoCompanion.insert({
    required int dataModificacao,
    required String id,
    required int ano,
    required int nivel,
    required int indice,
    required int idQuestao,
  })  : dataModificacao = Value(dataModificacao),
        id = Value(id),
        ano = Value(ano),
        nivel = Value(nivel),
        indice = Value(indice),
        idQuestao = Value(idQuestao);
  static Insertable<LinTbQuestoesCaderno> custom({
    Expression<int>? dataModificacao,
    Expression<String>? id,
    Expression<int>? ano,
    Expression<int>? nivel,
    Expression<int>? indice,
    Expression<int>? idQuestao,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (id != null) 'id': id,
      if (ano != null) 'ano': ano,
      if (nivel != null) 'nivel': nivel,
      if (indice != null) 'indice': indice,
      if (idQuestao != null) 'id_questao': idQuestao,
    });
  }

  TbQuestoesCadernoCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<String>? id,
      Value<int>? ano,
      Value<int>? nivel,
      Value<int>? indice,
      Value<int>? idQuestao}) {
    return TbQuestoesCadernoCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      id: id ?? this.id,
      ano: ano ?? this.ano,
      nivel: nivel ?? this.nivel,
      indice: indice ?? this.indice,
      idQuestao: idQuestao ?? this.idQuestao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ano.present) {
      map['ano'] = Variable<int>(ano.value);
    }
    if (nivel.present) {
      map['nivel'] = Variable<int>(nivel.value);
    }
    if (indice.present) {
      map['indice'] = Variable<int>(indice.value);
    }
    if (idQuestao.present) {
      map['id_questao'] = Variable<int>(idQuestao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbQuestoesCadernoCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('ano: $ano, ')
          ..write('nivel: $nivel, ')
          ..write('indice: $indice, ')
          ..write('idQuestao: $idQuestao')
          ..write(')'))
        .toString();
  }
}

class $TbQuestoesCadernoTable extends TbQuestoesCaderno
    with TableInfo<$TbQuestoesCadernoTable, LinTbQuestoesCaderno> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbQuestoesCadernoTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _anoMeta = const VerificationMeta('ano');
  @override
  late final GeneratedColumn<int?> ano = GeneratedColumn<int?>(
      'ano', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _nivelMeta = const VerificationMeta('nivel');
  @override
  late final GeneratedColumn<int?> nivel = GeneratedColumn<int?>(
      'nivel', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _indiceMeta = const VerificationMeta('indice');
  @override
  late final GeneratedColumn<int?> indice = GeneratedColumn<int?>(
      'indice', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idQuestaoMeta = const VerificationMeta('idQuestao');
  @override
  late final GeneratedColumn<int?> idQuestao = GeneratedColumn<int?>(
      'id_questao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [dataModificacao, id, ano, nivel, indice, idQuestao];
  @override
  String get aliasedName => _alias ?? 'questoes_caderno';
  @override
  String get actualTableName => 'questoes_caderno';
  @override
  VerificationContext validateIntegrity(
      Insertable<LinTbQuestoesCaderno> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ano')) {
      context.handle(
          _anoMeta, ano.isAcceptableOrUnknown(data['ano']!, _anoMeta));
    } else if (isInserting) {
      context.missing(_anoMeta);
    }
    if (data.containsKey('nivel')) {
      context.handle(
          _nivelMeta, nivel.isAcceptableOrUnknown(data['nivel']!, _nivelMeta));
    } else if (isInserting) {
      context.missing(_nivelMeta);
    }
    if (data.containsKey('indice')) {
      context.handle(_indiceMeta,
          indice.isAcceptableOrUnknown(data['indice']!, _indiceMeta));
    } else if (isInserting) {
      context.missing(_indiceMeta);
    }
    if (data.containsKey('id_questao')) {
      context.handle(_idQuestaoMeta,
          idQuestao.isAcceptableOrUnknown(data['id_questao']!, _idQuestaoMeta));
    } else if (isInserting) {
      context.missing(_idQuestaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinTbQuestoesCaderno map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbQuestoesCaderno.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbQuestoesCadernoTable createAlias(String alias) {
    return $TbQuestoesCadernoTable(attachedDatabase, alias);
  }
}

class LinTbUsuarios extends DataClass implements Insertable<LinTbUsuarios> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int id;
  final String? email;
  final String? nome;
  final String? foto;
  final bool softDelete;
  final bool sincronizar;
  LinTbUsuarios(
      {required this.dataModificacao,
      required this.id,
      this.email,
      this.nome,
      this.foto,
      required this.softDelete,
      required this.sincronizar});
  factory LinTbUsuarios.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbUsuarios(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email']),
      nome: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nome']),
      foto: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}foto']),
      softDelete: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}soft_delete'])!,
      sincronizar: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sincronizar'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String?>(email);
    }
    if (!nullToAbsent || nome != null) {
      map['nome'] = Variable<String?>(nome);
    }
    if (!nullToAbsent || foto != null) {
      map['foto'] = Variable<String?>(foto);
    }
    map['soft_delete'] = Variable<bool>(softDelete);
    map['sincronizar'] = Variable<bool>(sincronizar);
    return map;
  }

  TbUsuariosCompanion toCompanion(bool nullToAbsent) {
    return TbUsuariosCompanion(
      dataModificacao: Value(dataModificacao),
      id: Value(id),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      nome: nome == null && nullToAbsent ? const Value.absent() : Value(nome),
      foto: foto == null && nullToAbsent ? const Value.absent() : Value(foto),
      softDelete: Value(softDelete),
      sincronizar: Value(sincronizar),
    );
  }

  factory LinTbUsuarios.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbUsuarios(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String?>(json['email']),
      nome: serializer.fromJson<String?>(json['nome']),
      foto: serializer.fromJson<String?>(json['foto']),
      softDelete: serializer.fromJson<bool>(json['softDelete']),
      sincronizar: serializer.fromJson<bool>(json['sincronizar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String?>(email),
      'nome': serializer.toJson<String?>(nome),
      'foto': serializer.toJson<String?>(foto),
      'softDelete': serializer.toJson<bool>(softDelete),
      'sincronizar': serializer.toJson<bool>(sincronizar),
    };
  }

  LinTbUsuarios copyWith(
          {int? dataModificacao,
          int? id,
          String? email,
          String? nome,
          String? foto,
          bool? softDelete,
          bool? sincronizar}) =>
      LinTbUsuarios(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        id: id ?? this.id,
        email: email ?? this.email,
        nome: nome ?? this.nome,
        foto: foto ?? this.foto,
        softDelete: softDelete ?? this.softDelete,
        sincronizar: sincronizar ?? this.sincronizar,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbUsuarios(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('nome: $nome, ')
          ..write('foto: $foto, ')
          ..write('softDelete: $softDelete, ')
          ..write('sincronizar: $sincronizar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      dataModificacao, id, email, nome, foto, softDelete, sincronizar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbUsuarios &&
          other.dataModificacao == this.dataModificacao &&
          other.id == this.id &&
          other.email == this.email &&
          other.nome == this.nome &&
          other.foto == this.foto &&
          other.softDelete == this.softDelete &&
          other.sincronizar == this.sincronizar);
}

class TbUsuariosCompanion extends UpdateCompanion<LinTbUsuarios> {
  final Value<int> dataModificacao;
  final Value<int> id;
  final Value<String?> email;
  final Value<String?> nome;
  final Value<String?> foto;
  final Value<bool> softDelete;
  final Value<bool> sincronizar;
  const TbUsuariosCompanion({
    this.dataModificacao = const Value.absent(),
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.nome = const Value.absent(),
    this.foto = const Value.absent(),
    this.softDelete = const Value.absent(),
    this.sincronizar = const Value.absent(),
  });
  TbUsuariosCompanion.insert({
    required int dataModificacao,
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.nome = const Value.absent(),
    this.foto = const Value.absent(),
    this.softDelete = const Value.absent(),
    this.sincronizar = const Value.absent(),
  }) : dataModificacao = Value(dataModificacao);
  static Insertable<LinTbUsuarios> custom({
    Expression<int>? dataModificacao,
    Expression<int>? id,
    Expression<String?>? email,
    Expression<String?>? nome,
    Expression<String?>? foto,
    Expression<bool>? softDelete,
    Expression<bool>? sincronizar,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (nome != null) 'nome': nome,
      if (foto != null) 'foto': foto,
      if (softDelete != null) 'soft_delete': softDelete,
      if (sincronizar != null) 'sincronizar': sincronizar,
    });
  }

  TbUsuariosCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? id,
      Value<String?>? email,
      Value<String?>? nome,
      Value<String?>? foto,
      Value<bool>? softDelete,
      Value<bool>? sincronizar}) {
    return TbUsuariosCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      id: id ?? this.id,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      foto: foto ?? this.foto,
      softDelete: softDelete ?? this.softDelete,
      sincronizar: sincronizar ?? this.sincronizar,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String?>(email.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String?>(nome.value);
    }
    if (foto.present) {
      map['foto'] = Variable<String?>(foto.value);
    }
    if (softDelete.present) {
      map['soft_delete'] = Variable<bool>(softDelete.value);
    }
    if (sincronizar.present) {
      map['sincronizar'] = Variable<bool>(sincronizar.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbUsuariosCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('nome: $nome, ')
          ..write('foto: $foto, ')
          ..write('softDelete: $softDelete, ')
          ..write('sincronizar: $sincronizar')
          ..write(')'))
        .toString();
  }
}

class $TbUsuariosTable extends TbUsuarios
    with TableInfo<$TbUsuariosTable, LinTbUsuarios> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbUsuariosTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String?> email = GeneratedColumn<String?>(
      'email', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String?> nome = GeneratedColumn<String?>(
      'nome', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _fotoMeta = const VerificationMeta('foto');
  @override
  late final GeneratedColumn<String?> foto = GeneratedColumn<String?>(
      'foto', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _softDeleteMeta = const VerificationMeta('softDelete');
  @override
  late final GeneratedColumn<bool?> softDelete = GeneratedColumn<bool?>(
      'soft_delete', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (soft_delete IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _sincronizarMeta =
      const VerificationMeta('sincronizar');
  @override
  late final GeneratedColumn<bool?> sincronizar = GeneratedColumn<bool?>(
      'sincronizar', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (sincronizar IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [dataModificacao, id, email, nome, foto, softDelete, sincronizar];
  @override
  String get aliasedName => _alias ?? 'usuarios';
  @override
  String get actualTableName => 'usuarios';
  @override
  VerificationContext validateIntegrity(Insertable<LinTbUsuarios> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    }
    if (data.containsKey('foto')) {
      context.handle(
          _fotoMeta, foto.isAcceptableOrUnknown(data['foto']!, _fotoMeta));
    }
    if (data.containsKey('soft_delete')) {
      context.handle(
          _softDeleteMeta,
          softDelete.isAcceptableOrUnknown(
              data['soft_delete']!, _softDeleteMeta));
    }
    if (data.containsKey('sincronizar')) {
      context.handle(
          _sincronizarMeta,
          sincronizar.isAcceptableOrUnknown(
              data['sincronizar']!, _sincronizarMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinTbUsuarios map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbUsuarios.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbUsuariosTable createAlias(String alias) {
    return $TbUsuariosTable(attachedDatabase, alias);
  }
}

class LinTbClubes extends DataClass implements Insertable<LinTbClubes> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int id;
  final String nome;
  final String? descricao;
  final int dataCriacao;
  final bool privado;
  final String codigo;
  final String? capa;
  LinTbClubes(
      {required this.dataModificacao,
      required this.id,
      required this.nome,
      this.descricao,
      required this.dataCriacao,
      required this.privado,
      required this.codigo,
      this.capa});
  factory LinTbClubes.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbClubes(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      nome: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nome'])!,
      descricao: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descricao']),
      dataCriacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_criacao'])!,
      privado: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}privado'])!,
      codigo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}codigo'])!,
      capa: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}capa']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String?>(descricao);
    }
    map['data_criacao'] = Variable<int>(dataCriacao);
    map['privado'] = Variable<bool>(privado);
    map['codigo'] = Variable<String>(codigo);
    if (!nullToAbsent || capa != null) {
      map['capa'] = Variable<String?>(capa);
    }
    return map;
  }

  TbClubesCompanion toCompanion(bool nullToAbsent) {
    return TbClubesCompanion(
      dataModificacao: Value(dataModificacao),
      id: Value(id),
      nome: Value(nome),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
      dataCriacao: Value(dataCriacao),
      privado: Value(privado),
      codigo: Value(codigo),
      capa: capa == null && nullToAbsent ? const Value.absent() : Value(capa),
    );
  }

  factory LinTbClubes.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbClubes(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      descricao: serializer.fromJson<String?>(json['descricao']),
      dataCriacao: serializer.fromJson<int>(json['dataCriacao']),
      privado: serializer.fromJson<bool>(json['privado']),
      codigo: serializer.fromJson<String>(json['codigo']),
      capa: serializer.fromJson<String?>(json['capa']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'descricao': serializer.toJson<String?>(descricao),
      'dataCriacao': serializer.toJson<int>(dataCriacao),
      'privado': serializer.toJson<bool>(privado),
      'codigo': serializer.toJson<String>(codigo),
      'capa': serializer.toJson<String?>(capa),
    };
  }

  LinTbClubes copyWith(
          {int? dataModificacao,
          int? id,
          String? nome,
          String? descricao,
          int? dataCriacao,
          bool? privado,
          String? codigo,
          String? capa}) =>
      LinTbClubes(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        id: id ?? this.id,
        nome: nome ?? this.nome,
        descricao: descricao ?? this.descricao,
        dataCriacao: dataCriacao ?? this.dataCriacao,
        privado: privado ?? this.privado,
        codigo: codigo ?? this.codigo,
        capa: capa ?? this.capa,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbClubes(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('privado: $privado, ')
          ..write('codigo: $codigo, ')
          ..write('capa: $capa')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      dataModificacao, id, nome, descricao, dataCriacao, privado, codigo, capa);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbClubes &&
          other.dataModificacao == this.dataModificacao &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.descricao == this.descricao &&
          other.dataCriacao == this.dataCriacao &&
          other.privado == this.privado &&
          other.codigo == this.codigo &&
          other.capa == this.capa);
}

class TbClubesCompanion extends UpdateCompanion<LinTbClubes> {
  final Value<int> dataModificacao;
  final Value<int> id;
  final Value<String> nome;
  final Value<String?> descricao;
  final Value<int> dataCriacao;
  final Value<bool> privado;
  final Value<String> codigo;
  final Value<String?> capa;
  const TbClubesCompanion({
    this.dataModificacao = const Value.absent(),
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.descricao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.privado = const Value.absent(),
    this.codigo = const Value.absent(),
    this.capa = const Value.absent(),
  });
  TbClubesCompanion.insert({
    required int dataModificacao,
    this.id = const Value.absent(),
    required String nome,
    this.descricao = const Value.absent(),
    required int dataCriacao,
    this.privado = const Value.absent(),
    required String codigo,
    this.capa = const Value.absent(),
  })  : dataModificacao = Value(dataModificacao),
        nome = Value(nome),
        dataCriacao = Value(dataCriacao),
        codigo = Value(codigo);
  static Insertable<LinTbClubes> custom({
    Expression<int>? dataModificacao,
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String?>? descricao,
    Expression<int>? dataCriacao,
    Expression<bool>? privado,
    Expression<String>? codigo,
    Expression<String?>? capa,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (descricao != null) 'descricao': descricao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (privado != null) 'privado': privado,
      if (codigo != null) 'codigo': codigo,
      if (capa != null) 'capa': capa,
    });
  }

  TbClubesCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? id,
      Value<String>? nome,
      Value<String?>? descricao,
      Value<int>? dataCriacao,
      Value<bool>? privado,
      Value<String>? codigo,
      Value<String?>? capa}) {
    return TbClubesCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      privado: privado ?? this.privado,
      codigo: codigo ?? this.codigo,
      capa: capa ?? this.capa,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String?>(descricao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<int>(dataCriacao.value);
    }
    if (privado.present) {
      map['privado'] = Variable<bool>(privado.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (capa.present) {
      map['capa'] = Variable<String?>(capa.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbClubesCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('privado: $privado, ')
          ..write('codigo: $codigo, ')
          ..write('capa: $capa')
          ..write(')'))
        .toString();
  }
}

class $TbClubesTable extends TbClubes
    with TableInfo<$TbClubesTable, LinTbClubes> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbClubesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String?> nome = GeneratedColumn<String?>(
      'nome', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE NOT NULL');
  final VerificationMeta _descricaoMeta = const VerificationMeta('descricao');
  @override
  late final GeneratedColumn<String?> descricao = GeneratedColumn<String?>(
      'descricao', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _dataCriacaoMeta =
      const VerificationMeta('dataCriacao');
  @override
  late final GeneratedColumn<int?> dataCriacao = GeneratedColumn<int?>(
      'data_criacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _privadoMeta = const VerificationMeta('privado');
  @override
  late final GeneratedColumn<bool?> privado = GeneratedColumn<bool?>(
      'privado', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (privado IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String?> codigo = GeneratedColumn<String?>(
      'codigo', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE NOT NULL');
  final VerificationMeta _capaMeta = const VerificationMeta('capa');
  @override
  late final GeneratedColumn<String?> capa = GeneratedColumn<String?>(
      'capa', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        dataModificacao,
        id,
        nome,
        descricao,
        dataCriacao,
        privado,
        codigo,
        capa
      ];
  @override
  String get aliasedName => _alias ?? 'clubes';
  @override
  String get actualTableName => 'clubes';
  @override
  VerificationContext validateIntegrity(Insertable<LinTbClubes> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(_descricaoMeta,
          descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta));
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
          _dataCriacaoMeta,
          dataCriacao.isAcceptableOrUnknown(
              data['data_criacao']!, _dataCriacaoMeta));
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('privado')) {
      context.handle(_privadoMeta,
          privado.isAcceptableOrUnknown(data['privado']!, _privadoMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta));
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('capa')) {
      context.handle(
          _capaMeta, capa.isAcceptableOrUnknown(data['capa']!, _capaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinTbClubes map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbClubes.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbClubesTable createAlias(String alias) {
    return $TbClubesTable(attachedDatabase, alias);
  }
}

class LinTbTiposPermissao extends DataClass
    implements Insertable<LinTbTiposPermissao> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int id;
  final String permissao;
  LinTbTiposPermissao(
      {required this.dataModificacao,
      required this.id,
      required this.permissao});
  factory LinTbTiposPermissao.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbTiposPermissao(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      permissao: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}permissao'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id'] = Variable<int>(id);
    map['permissao'] = Variable<String>(permissao);
    return map;
  }

  TbTiposPermissaoCompanion toCompanion(bool nullToAbsent) {
    return TbTiposPermissaoCompanion(
      dataModificacao: Value(dataModificacao),
      id: Value(id),
      permissao: Value(permissao),
    );
  }

  factory LinTbTiposPermissao.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbTiposPermissao(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      id: serializer.fromJson<int>(json['id']),
      permissao: serializer.fromJson<String>(json['permissao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'id': serializer.toJson<int>(id),
      'permissao': serializer.toJson<String>(permissao),
    };
  }

  LinTbTiposPermissao copyWith(
          {int? dataModificacao, int? id, String? permissao}) =>
      LinTbTiposPermissao(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        id: id ?? this.id,
        permissao: permissao ?? this.permissao,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbTiposPermissao(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('permissao: $permissao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dataModificacao, id, permissao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbTiposPermissao &&
          other.dataModificacao == this.dataModificacao &&
          other.id == this.id &&
          other.permissao == this.permissao);
}

class TbTiposPermissaoCompanion extends UpdateCompanion<LinTbTiposPermissao> {
  final Value<int> dataModificacao;
  final Value<int> id;
  final Value<String> permissao;
  const TbTiposPermissaoCompanion({
    this.dataModificacao = const Value.absent(),
    this.id = const Value.absent(),
    this.permissao = const Value.absent(),
  });
  TbTiposPermissaoCompanion.insert({
    required int dataModificacao,
    this.id = const Value.absent(),
    required String permissao,
  })  : dataModificacao = Value(dataModificacao),
        permissao = Value(permissao);
  static Insertable<LinTbTiposPermissao> custom({
    Expression<int>? dataModificacao,
    Expression<int>? id,
    Expression<String>? permissao,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (id != null) 'id': id,
      if (permissao != null) 'permissao': permissao,
    });
  }

  TbTiposPermissaoCompanion copyWith(
      {Value<int>? dataModificacao, Value<int>? id, Value<String>? permissao}) {
    return TbTiposPermissaoCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      id: id ?? this.id,
      permissao: permissao ?? this.permissao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (permissao.present) {
      map['permissao'] = Variable<String>(permissao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbTiposPermissaoCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('permissao: $permissao')
          ..write(')'))
        .toString();
  }
}

class $TbTiposPermissaoTable extends TbTiposPermissao
    with TableInfo<$TbTiposPermissaoTable, LinTbTiposPermissao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbTiposPermissaoTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _permissaoMeta = const VerificationMeta('permissao');
  @override
  late final GeneratedColumn<String?> permissao = GeneratedColumn<String?>(
      'permissao', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [dataModificacao, id, permissao];
  @override
  String get aliasedName => _alias ?? 'tipos_permissao';
  @override
  String get actualTableName => 'tipos_permissao';
  @override
  VerificationContext validateIntegrity(
      Insertable<LinTbTiposPermissao> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('permissao')) {
      context.handle(_permissaoMeta,
          permissao.isAcceptableOrUnknown(data['permissao']!, _permissaoMeta));
    } else if (isInserting) {
      context.missing(_permissaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinTbTiposPermissao map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbTiposPermissao.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbTiposPermissaoTable createAlias(String alias) {
    return $TbTiposPermissaoTable(attachedDatabase, alias);
  }
}

class LinTbClubeUsuario extends DataClass
    implements Insertable<LinTbClubeUsuario> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int idClube;
  final int idUsuario;
  final int idPermissao;
  final int dataAdmissao;
  LinTbClubeUsuario(
      {required this.dataModificacao,
      required this.idClube,
      required this.idUsuario,
      required this.idPermissao,
      required this.dataAdmissao});
  factory LinTbClubeUsuario.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbClubeUsuario(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      idClube: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_clube'])!,
      idUsuario: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_usuario'])!,
      idPermissao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_permissao'])!,
      dataAdmissao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_admissao'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id_clube'] = Variable<int>(idClube);
    map['id_usuario'] = Variable<int>(idUsuario);
    map['id_permissao'] = Variable<int>(idPermissao);
    map['data_admissao'] = Variable<int>(dataAdmissao);
    return map;
  }

  TbClubeUsuarioCompanion toCompanion(bool nullToAbsent) {
    return TbClubeUsuarioCompanion(
      dataModificacao: Value(dataModificacao),
      idClube: Value(idClube),
      idUsuario: Value(idUsuario),
      idPermissao: Value(idPermissao),
      dataAdmissao: Value(dataAdmissao),
    );
  }

  factory LinTbClubeUsuario.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbClubeUsuario(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      idClube: serializer.fromJson<int>(json['idClube']),
      idUsuario: serializer.fromJson<int>(json['idUsuario']),
      idPermissao: serializer.fromJson<int>(json['idPermissao']),
      dataAdmissao: serializer.fromJson<int>(json['dataAdmissao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'idClube': serializer.toJson<int>(idClube),
      'idUsuario': serializer.toJson<int>(idUsuario),
      'idPermissao': serializer.toJson<int>(idPermissao),
      'dataAdmissao': serializer.toJson<int>(dataAdmissao),
    };
  }

  LinTbClubeUsuario copyWith(
          {int? dataModificacao,
          int? idClube,
          int? idUsuario,
          int? idPermissao,
          int? dataAdmissao}) =>
      LinTbClubeUsuario(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        idClube: idClube ?? this.idClube,
        idUsuario: idUsuario ?? this.idUsuario,
        idPermissao: idPermissao ?? this.idPermissao,
        dataAdmissao: dataAdmissao ?? this.dataAdmissao,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbClubeUsuario(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('idClube: $idClube, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('idPermissao: $idPermissao, ')
          ..write('dataAdmissao: $dataAdmissao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      dataModificacao, idClube, idUsuario, idPermissao, dataAdmissao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbClubeUsuario &&
          other.dataModificacao == this.dataModificacao &&
          other.idClube == this.idClube &&
          other.idUsuario == this.idUsuario &&
          other.idPermissao == this.idPermissao &&
          other.dataAdmissao == this.dataAdmissao);
}

class TbClubeUsuarioCompanion extends UpdateCompanion<LinTbClubeUsuario> {
  final Value<int> dataModificacao;
  final Value<int> idClube;
  final Value<int> idUsuario;
  final Value<int> idPermissao;
  final Value<int> dataAdmissao;
  const TbClubeUsuarioCompanion({
    this.dataModificacao = const Value.absent(),
    this.idClube = const Value.absent(),
    this.idUsuario = const Value.absent(),
    this.idPermissao = const Value.absent(),
    this.dataAdmissao = const Value.absent(),
  });
  TbClubeUsuarioCompanion.insert({
    required int dataModificacao,
    required int idClube,
    required int idUsuario,
    required int idPermissao,
    required int dataAdmissao,
  })  : dataModificacao = Value(dataModificacao),
        idClube = Value(idClube),
        idUsuario = Value(idUsuario),
        idPermissao = Value(idPermissao),
        dataAdmissao = Value(dataAdmissao);
  static Insertable<LinTbClubeUsuario> custom({
    Expression<int>? dataModificacao,
    Expression<int>? idClube,
    Expression<int>? idUsuario,
    Expression<int>? idPermissao,
    Expression<int>? dataAdmissao,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (idClube != null) 'id_clube': idClube,
      if (idUsuario != null) 'id_usuario': idUsuario,
      if (idPermissao != null) 'id_permissao': idPermissao,
      if (dataAdmissao != null) 'data_admissao': dataAdmissao,
    });
  }

  TbClubeUsuarioCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? idClube,
      Value<int>? idUsuario,
      Value<int>? idPermissao,
      Value<int>? dataAdmissao}) {
    return TbClubeUsuarioCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      idClube: idClube ?? this.idClube,
      idUsuario: idUsuario ?? this.idUsuario,
      idPermissao: idPermissao ?? this.idPermissao,
      dataAdmissao: dataAdmissao ?? this.dataAdmissao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (idClube.present) {
      map['id_clube'] = Variable<int>(idClube.value);
    }
    if (idUsuario.present) {
      map['id_usuario'] = Variable<int>(idUsuario.value);
    }
    if (idPermissao.present) {
      map['id_permissao'] = Variable<int>(idPermissao.value);
    }
    if (dataAdmissao.present) {
      map['data_admissao'] = Variable<int>(dataAdmissao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbClubeUsuarioCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('idClube: $idClube, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('idPermissao: $idPermissao, ')
          ..write('dataAdmissao: $dataAdmissao')
          ..write(')'))
        .toString();
  }
}

class $TbClubeUsuarioTable extends TbClubeUsuario
    with TableInfo<$TbClubeUsuarioTable, LinTbClubeUsuario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbClubeUsuarioTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idClubeMeta = const VerificationMeta('idClube');
  @override
  late final GeneratedColumn<int?> idClube = GeneratedColumn<int?>(
      'id_clube', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idUsuarioMeta = const VerificationMeta('idUsuario');
  @override
  late final GeneratedColumn<int?> idUsuario = GeneratedColumn<int?>(
      'id_usuario', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idPermissaoMeta =
      const VerificationMeta('idPermissao');
  @override
  late final GeneratedColumn<int?> idPermissao = GeneratedColumn<int?>(
      'id_permissao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dataAdmissaoMeta =
      const VerificationMeta('dataAdmissao');
  @override
  late final GeneratedColumn<int?> dataAdmissao = GeneratedColumn<int?>(
      'data_admissao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [dataModificacao, idClube, idUsuario, idPermissao, dataAdmissao];
  @override
  String get aliasedName => _alias ?? 'clube_x_usuario';
  @override
  String get actualTableName => 'clube_x_usuario';
  @override
  VerificationContext validateIntegrity(Insertable<LinTbClubeUsuario> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id_clube')) {
      context.handle(_idClubeMeta,
          idClube.isAcceptableOrUnknown(data['id_clube']!, _idClubeMeta));
    } else if (isInserting) {
      context.missing(_idClubeMeta);
    }
    if (data.containsKey('id_usuario')) {
      context.handle(_idUsuarioMeta,
          idUsuario.isAcceptableOrUnknown(data['id_usuario']!, _idUsuarioMeta));
    } else if (isInserting) {
      context.missing(_idUsuarioMeta);
    }
    if (data.containsKey('id_permissao')) {
      context.handle(
          _idPermissaoMeta,
          idPermissao.isAcceptableOrUnknown(
              data['id_permissao']!, _idPermissaoMeta));
    } else if (isInserting) {
      context.missing(_idPermissaoMeta);
    }
    if (data.containsKey('data_admissao')) {
      context.handle(
          _dataAdmissaoMeta,
          dataAdmissao.isAcceptableOrUnknown(
              data['data_admissao']!, _dataAdmissaoMeta));
    } else if (isInserting) {
      context.missing(_dataAdmissaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idClube, idUsuario};
  @override
  LinTbClubeUsuario map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbClubeUsuario.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbClubeUsuarioTable createAlias(String alias) {
    return $TbClubeUsuarioTable(attachedDatabase, alias);
  }
}

class LinTbAtividades extends DataClass implements Insertable<LinTbAtividades> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int id;
  final int idClube;
  final String titulo;
  final String? descricao;
  final int idAutor;
  final int dataCriacao;
  final int? dataLiberacao;
  final int? dataEncerramento;
  LinTbAtividades(
      {required this.dataModificacao,
      required this.id,
      required this.idClube,
      required this.titulo,
      this.descricao,
      required this.idAutor,
      required this.dataCriacao,
      this.dataLiberacao,
      this.dataEncerramento});
  factory LinTbAtividades.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbAtividades(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      idClube: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_clube'])!,
      titulo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}titulo'])!,
      descricao: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descricao']),
      idAutor: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_autor'])!,
      dataCriacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_criacao'])!,
      dataLiberacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_liberacao']),
      dataEncerramento: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_encerramento']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id'] = Variable<int>(id);
    map['id_clube'] = Variable<int>(idClube);
    map['titulo'] = Variable<String>(titulo);
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String?>(descricao);
    }
    map['id_autor'] = Variable<int>(idAutor);
    map['data_criacao'] = Variable<int>(dataCriacao);
    if (!nullToAbsent || dataLiberacao != null) {
      map['data_liberacao'] = Variable<int?>(dataLiberacao);
    }
    if (!nullToAbsent || dataEncerramento != null) {
      map['data_encerramento'] = Variable<int?>(dataEncerramento);
    }
    return map;
  }

  TbAtividadesCompanion toCompanion(bool nullToAbsent) {
    return TbAtividadesCompanion(
      dataModificacao: Value(dataModificacao),
      id: Value(id),
      idClube: Value(idClube),
      titulo: Value(titulo),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
      idAutor: Value(idAutor),
      dataCriacao: Value(dataCriacao),
      dataLiberacao: dataLiberacao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataLiberacao),
      dataEncerramento: dataEncerramento == null && nullToAbsent
          ? const Value.absent()
          : Value(dataEncerramento),
    );
  }

  factory LinTbAtividades.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbAtividades(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      id: serializer.fromJson<int>(json['id']),
      idClube: serializer.fromJson<int>(json['idClube']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descricao: serializer.fromJson<String?>(json['descricao']),
      idAutor: serializer.fromJson<int>(json['idAutor']),
      dataCriacao: serializer.fromJson<int>(json['dataCriacao']),
      dataLiberacao: serializer.fromJson<int?>(json['dataLiberacao']),
      dataEncerramento: serializer.fromJson<int?>(json['dataEncerramento']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'id': serializer.toJson<int>(id),
      'idClube': serializer.toJson<int>(idClube),
      'titulo': serializer.toJson<String>(titulo),
      'descricao': serializer.toJson<String?>(descricao),
      'idAutor': serializer.toJson<int>(idAutor),
      'dataCriacao': serializer.toJson<int>(dataCriacao),
      'dataLiberacao': serializer.toJson<int?>(dataLiberacao),
      'dataEncerramento': serializer.toJson<int?>(dataEncerramento),
    };
  }

  LinTbAtividades copyWith(
          {int? dataModificacao,
          int? id,
          int? idClube,
          String? titulo,
          String? descricao,
          int? idAutor,
          int? dataCriacao,
          int? dataLiberacao,
          int? dataEncerramento}) =>
      LinTbAtividades(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        id: id ?? this.id,
        idClube: idClube ?? this.idClube,
        titulo: titulo ?? this.titulo,
        descricao: descricao ?? this.descricao,
        idAutor: idAutor ?? this.idAutor,
        dataCriacao: dataCriacao ?? this.dataCriacao,
        dataLiberacao: dataLiberacao ?? this.dataLiberacao,
        dataEncerramento: dataEncerramento ?? this.dataEncerramento,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbAtividades(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('idClube: $idClube, ')
          ..write('titulo: $titulo, ')
          ..write('descricao: $descricao, ')
          ..write('idAutor: $idAutor, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataLiberacao: $dataLiberacao, ')
          ..write('dataEncerramento: $dataEncerramento')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dataModificacao, id, idClube, titulo,
      descricao, idAutor, dataCriacao, dataLiberacao, dataEncerramento);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbAtividades &&
          other.dataModificacao == this.dataModificacao &&
          other.id == this.id &&
          other.idClube == this.idClube &&
          other.titulo == this.titulo &&
          other.descricao == this.descricao &&
          other.idAutor == this.idAutor &&
          other.dataCriacao == this.dataCriacao &&
          other.dataLiberacao == this.dataLiberacao &&
          other.dataEncerramento == this.dataEncerramento);
}

class TbAtividadesCompanion extends UpdateCompanion<LinTbAtividades> {
  final Value<int> dataModificacao;
  final Value<int> id;
  final Value<int> idClube;
  final Value<String> titulo;
  final Value<String?> descricao;
  final Value<int> idAutor;
  final Value<int> dataCriacao;
  final Value<int?> dataLiberacao;
  final Value<int?> dataEncerramento;
  const TbAtividadesCompanion({
    this.dataModificacao = const Value.absent(),
    this.id = const Value.absent(),
    this.idClube = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descricao = const Value.absent(),
    this.idAutor = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataLiberacao = const Value.absent(),
    this.dataEncerramento = const Value.absent(),
  });
  TbAtividadesCompanion.insert({
    required int dataModificacao,
    this.id = const Value.absent(),
    required int idClube,
    required String titulo,
    this.descricao = const Value.absent(),
    required int idAutor,
    required int dataCriacao,
    this.dataLiberacao = const Value.absent(),
    this.dataEncerramento = const Value.absent(),
  })  : dataModificacao = Value(dataModificacao),
        idClube = Value(idClube),
        titulo = Value(titulo),
        idAutor = Value(idAutor),
        dataCriacao = Value(dataCriacao);
  static Insertable<LinTbAtividades> custom({
    Expression<int>? dataModificacao,
    Expression<int>? id,
    Expression<int>? idClube,
    Expression<String>? titulo,
    Expression<String?>? descricao,
    Expression<int>? idAutor,
    Expression<int>? dataCriacao,
    Expression<int?>? dataLiberacao,
    Expression<int?>? dataEncerramento,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (id != null) 'id': id,
      if (idClube != null) 'id_clube': idClube,
      if (titulo != null) 'titulo': titulo,
      if (descricao != null) 'descricao': descricao,
      if (idAutor != null) 'id_autor': idAutor,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataLiberacao != null) 'data_liberacao': dataLiberacao,
      if (dataEncerramento != null) 'data_encerramento': dataEncerramento,
    });
  }

  TbAtividadesCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? id,
      Value<int>? idClube,
      Value<String>? titulo,
      Value<String?>? descricao,
      Value<int>? idAutor,
      Value<int>? dataCriacao,
      Value<int?>? dataLiberacao,
      Value<int?>? dataEncerramento}) {
    return TbAtividadesCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      id: id ?? this.id,
      idClube: idClube ?? this.idClube,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      idAutor: idAutor ?? this.idAutor,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataLiberacao: dataLiberacao ?? this.dataLiberacao,
      dataEncerramento: dataEncerramento ?? this.dataEncerramento,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idClube.present) {
      map['id_clube'] = Variable<int>(idClube.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String?>(descricao.value);
    }
    if (idAutor.present) {
      map['id_autor'] = Variable<int>(idAutor.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<int>(dataCriacao.value);
    }
    if (dataLiberacao.present) {
      map['data_liberacao'] = Variable<int?>(dataLiberacao.value);
    }
    if (dataEncerramento.present) {
      map['data_encerramento'] = Variable<int?>(dataEncerramento.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbAtividadesCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('idClube: $idClube, ')
          ..write('titulo: $titulo, ')
          ..write('descricao: $descricao, ')
          ..write('idAutor: $idAutor, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataLiberacao: $dataLiberacao, ')
          ..write('dataEncerramento: $dataEncerramento')
          ..write(')'))
        .toString();
  }
}

class $TbAtividadesTable extends TbAtividades
    with TableInfo<$TbAtividadesTable, LinTbAtividades> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbAtividadesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _idClubeMeta = const VerificationMeta('idClube');
  @override
  late final GeneratedColumn<int?> idClube = GeneratedColumn<int?>(
      'id_clube', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String?> titulo = GeneratedColumn<String?>(
      'titulo', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _descricaoMeta = const VerificationMeta('descricao');
  @override
  late final GeneratedColumn<String?> descricao = GeneratedColumn<String?>(
      'descricao', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _idAutorMeta = const VerificationMeta('idAutor');
  @override
  late final GeneratedColumn<int?> idAutor = GeneratedColumn<int?>(
      'id_autor', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dataCriacaoMeta =
      const VerificationMeta('dataCriacao');
  @override
  late final GeneratedColumn<int?> dataCriacao = GeneratedColumn<int?>(
      'data_criacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dataLiberacaoMeta =
      const VerificationMeta('dataLiberacao');
  @override
  late final GeneratedColumn<int?> dataLiberacao = GeneratedColumn<int?>(
      'data_liberacao', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _dataEncerramentoMeta =
      const VerificationMeta('dataEncerramento');
  @override
  late final GeneratedColumn<int?> dataEncerramento = GeneratedColumn<int?>(
      'data_encerramento', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        dataModificacao,
        id,
        idClube,
        titulo,
        descricao,
        idAutor,
        dataCriacao,
        dataLiberacao,
        dataEncerramento
      ];
  @override
  String get aliasedName => _alias ?? 'atividades';
  @override
  String get actualTableName => 'atividades';
  @override
  VerificationContext validateIntegrity(Insertable<LinTbAtividades> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_clube')) {
      context.handle(_idClubeMeta,
          idClube.isAcceptableOrUnknown(data['id_clube']!, _idClubeMeta));
    } else if (isInserting) {
      context.missing(_idClubeMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta));
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(_descricaoMeta,
          descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta));
    }
    if (data.containsKey('id_autor')) {
      context.handle(_idAutorMeta,
          idAutor.isAcceptableOrUnknown(data['id_autor']!, _idAutorMeta));
    } else if (isInserting) {
      context.missing(_idAutorMeta);
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
          _dataCriacaoMeta,
          dataCriacao.isAcceptableOrUnknown(
              data['data_criacao']!, _dataCriacaoMeta));
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('data_liberacao')) {
      context.handle(
          _dataLiberacaoMeta,
          dataLiberacao.isAcceptableOrUnknown(
              data['data_liberacao']!, _dataLiberacaoMeta));
    }
    if (data.containsKey('data_encerramento')) {
      context.handle(
          _dataEncerramentoMeta,
          dataEncerramento.isAcceptableOrUnknown(
              data['data_encerramento']!, _dataEncerramentoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinTbAtividades map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbAtividades.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbAtividadesTable createAlias(String alias) {
    return $TbAtividadesTable(attachedDatabase, alias);
  }
}

class LinTbQuestaoAtividade extends DataClass
    implements Insertable<LinTbQuestaoAtividade> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int id;
  final String idQuestaoCaderno;
  final int idAtividade;
  LinTbQuestaoAtividade(
      {required this.dataModificacao,
      required this.id,
      required this.idQuestaoCaderno,
      required this.idAtividade});
  factory LinTbQuestaoAtividade.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbQuestaoAtividade(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      idQuestaoCaderno: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}id_questao_caderno'])!,
      idAtividade: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_atividade'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id'] = Variable<int>(id);
    map['id_questao_caderno'] = Variable<String>(idQuestaoCaderno);
    map['id_atividade'] = Variable<int>(idAtividade);
    return map;
  }

  TbQuestaoAtividadeCompanion toCompanion(bool nullToAbsent) {
    return TbQuestaoAtividadeCompanion(
      dataModificacao: Value(dataModificacao),
      id: Value(id),
      idQuestaoCaderno: Value(idQuestaoCaderno),
      idAtividade: Value(idAtividade),
    );
  }

  factory LinTbQuestaoAtividade.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbQuestaoAtividade(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      id: serializer.fromJson<int>(json['id']),
      idQuestaoCaderno: serializer.fromJson<String>(json['idQuestaoCaderno']),
      idAtividade: serializer.fromJson<int>(json['idAtividade']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'id': serializer.toJson<int>(id),
      'idQuestaoCaderno': serializer.toJson<String>(idQuestaoCaderno),
      'idAtividade': serializer.toJson<int>(idAtividade),
    };
  }

  LinTbQuestaoAtividade copyWith(
          {int? dataModificacao,
          int? id,
          String? idQuestaoCaderno,
          int? idAtividade}) =>
      LinTbQuestaoAtividade(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        id: id ?? this.id,
        idQuestaoCaderno: idQuestaoCaderno ?? this.idQuestaoCaderno,
        idAtividade: idAtividade ?? this.idAtividade,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbQuestaoAtividade(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('idQuestaoCaderno: $idQuestaoCaderno, ')
          ..write('idAtividade: $idAtividade')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dataModificacao, id, idQuestaoCaderno, idAtividade);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbQuestaoAtividade &&
          other.dataModificacao == this.dataModificacao &&
          other.id == this.id &&
          other.idQuestaoCaderno == this.idQuestaoCaderno &&
          other.idAtividade == this.idAtividade);
}

class TbQuestaoAtividadeCompanion
    extends UpdateCompanion<LinTbQuestaoAtividade> {
  final Value<int> dataModificacao;
  final Value<int> id;
  final Value<String> idQuestaoCaderno;
  final Value<int> idAtividade;
  const TbQuestaoAtividadeCompanion({
    this.dataModificacao = const Value.absent(),
    this.id = const Value.absent(),
    this.idQuestaoCaderno = const Value.absent(),
    this.idAtividade = const Value.absent(),
  });
  TbQuestaoAtividadeCompanion.insert({
    required int dataModificacao,
    this.id = const Value.absent(),
    required String idQuestaoCaderno,
    required int idAtividade,
  })  : dataModificacao = Value(dataModificacao),
        idQuestaoCaderno = Value(idQuestaoCaderno),
        idAtividade = Value(idAtividade);
  static Insertable<LinTbQuestaoAtividade> custom({
    Expression<int>? dataModificacao,
    Expression<int>? id,
    Expression<String>? idQuestaoCaderno,
    Expression<int>? idAtividade,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (id != null) 'id': id,
      if (idQuestaoCaderno != null) 'id_questao_caderno': idQuestaoCaderno,
      if (idAtividade != null) 'id_atividade': idAtividade,
    });
  }

  TbQuestaoAtividadeCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? id,
      Value<String>? idQuestaoCaderno,
      Value<int>? idAtividade}) {
    return TbQuestaoAtividadeCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      id: id ?? this.id,
      idQuestaoCaderno: idQuestaoCaderno ?? this.idQuestaoCaderno,
      idAtividade: idAtividade ?? this.idAtividade,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idQuestaoCaderno.present) {
      map['id_questao_caderno'] = Variable<String>(idQuestaoCaderno.value);
    }
    if (idAtividade.present) {
      map['id_atividade'] = Variable<int>(idAtividade.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbQuestaoAtividadeCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('id: $id, ')
          ..write('idQuestaoCaderno: $idQuestaoCaderno, ')
          ..write('idAtividade: $idAtividade')
          ..write(')'))
        .toString();
  }
}

class $TbQuestaoAtividadeTable extends TbQuestaoAtividade
    with TableInfo<$TbQuestaoAtividadeTable, LinTbQuestaoAtividade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbQuestaoAtividadeTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _idQuestaoCadernoMeta =
      const VerificationMeta('idQuestaoCaderno');
  @override
  late final GeneratedColumn<String?> idQuestaoCaderno =
      GeneratedColumn<String?>('id_questao_caderno', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _idAtividadeMeta =
      const VerificationMeta('idAtividade');
  @override
  late final GeneratedColumn<int?> idAtividade = GeneratedColumn<int?>(
      'id_atividade', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [dataModificacao, id, idQuestaoCaderno, idAtividade];
  @override
  String get aliasedName => _alias ?? 'questao_x_atividade';
  @override
  String get actualTableName => 'questao_x_atividade';
  @override
  VerificationContext validateIntegrity(
      Insertable<LinTbQuestaoAtividade> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_questao_caderno')) {
      context.handle(
          _idQuestaoCadernoMeta,
          idQuestaoCaderno.isAcceptableOrUnknown(
              data['id_questao_caderno']!, _idQuestaoCadernoMeta));
    } else if (isInserting) {
      context.missing(_idQuestaoCadernoMeta);
    }
    if (data.containsKey('id_atividade')) {
      context.handle(
          _idAtividadeMeta,
          idAtividade.isAcceptableOrUnknown(
              data['id_atividade']!, _idAtividadeMeta));
    } else if (isInserting) {
      context.missing(_idAtividadeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LinTbQuestaoAtividade map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbQuestaoAtividade.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbQuestaoAtividadeTable createAlias(String alias) {
    return $TbQuestaoAtividadeTable(attachedDatabase, alias);
  }
}

class LinTbRespostaQuestaoAtividade extends DataClass
    implements Insertable<LinTbRespostaQuestaoAtividade> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int idQuestaoAtividade;
  final int idUsuario;
  final int? resposta;
  final bool sincronizar;
  LinTbRespostaQuestaoAtividade(
      {required this.dataModificacao,
      required this.idQuestaoAtividade,
      required this.idUsuario,
      this.resposta,
      required this.sincronizar});
  factory LinTbRespostaQuestaoAtividade.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbRespostaQuestaoAtividade(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      idQuestaoAtividade: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}id_questao_x_atividade'])!,
      idUsuario: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_usuario'])!,
      resposta: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}resposta']),
      sincronizar: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sincronizar'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id_questao_x_atividade'] = Variable<int>(idQuestaoAtividade);
    map['id_usuario'] = Variable<int>(idUsuario);
    if (!nullToAbsent || resposta != null) {
      map['resposta'] = Variable<int?>(resposta);
    }
    map['sincronizar'] = Variable<bool>(sincronizar);
    return map;
  }

  TbRespostaQuestaoAtividadeCompanion toCompanion(bool nullToAbsent) {
    return TbRespostaQuestaoAtividadeCompanion(
      dataModificacao: Value(dataModificacao),
      idQuestaoAtividade: Value(idQuestaoAtividade),
      idUsuario: Value(idUsuario),
      resposta: resposta == null && nullToAbsent
          ? const Value.absent()
          : Value(resposta),
      sincronizar: Value(sincronizar),
    );
  }

  factory LinTbRespostaQuestaoAtividade.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbRespostaQuestaoAtividade(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      idQuestaoAtividade: serializer.fromJson<int>(json['idQuestaoAtividade']),
      idUsuario: serializer.fromJson<int>(json['idUsuario']),
      resposta: serializer.fromJson<int?>(json['resposta']),
      sincronizar: serializer.fromJson<bool>(json['sincronizar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'idQuestaoAtividade': serializer.toJson<int>(idQuestaoAtividade),
      'idUsuario': serializer.toJson<int>(idUsuario),
      'resposta': serializer.toJson<int?>(resposta),
      'sincronizar': serializer.toJson<bool>(sincronizar),
    };
  }

  LinTbRespostaQuestaoAtividade copyWith(
          {int? dataModificacao,
          int? idQuestaoAtividade,
          int? idUsuario,
          int? resposta,
          bool? sincronizar}) =>
      LinTbRespostaQuestaoAtividade(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        idQuestaoAtividade: idQuestaoAtividade ?? this.idQuestaoAtividade,
        idUsuario: idUsuario ?? this.idUsuario,
        resposta: resposta ?? this.resposta,
        sincronizar: sincronizar ?? this.sincronizar,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbRespostaQuestaoAtividade(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('idQuestaoAtividade: $idQuestaoAtividade, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('resposta: $resposta, ')
          ..write('sincronizar: $sincronizar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      dataModificacao, idQuestaoAtividade, idUsuario, resposta, sincronizar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbRespostaQuestaoAtividade &&
          other.dataModificacao == this.dataModificacao &&
          other.idQuestaoAtividade == this.idQuestaoAtividade &&
          other.idUsuario == this.idUsuario &&
          other.resposta == this.resposta &&
          other.sincronizar == this.sincronizar);
}

class TbRespostaQuestaoAtividadeCompanion
    extends UpdateCompanion<LinTbRespostaQuestaoAtividade> {
  final Value<int> dataModificacao;
  final Value<int> idQuestaoAtividade;
  final Value<int> idUsuario;
  final Value<int?> resposta;
  final Value<bool> sincronizar;
  const TbRespostaQuestaoAtividadeCompanion({
    this.dataModificacao = const Value.absent(),
    this.idQuestaoAtividade = const Value.absent(),
    this.idUsuario = const Value.absent(),
    this.resposta = const Value.absent(),
    this.sincronizar = const Value.absent(),
  });
  TbRespostaQuestaoAtividadeCompanion.insert({
    required int dataModificacao,
    required int idQuestaoAtividade,
    required int idUsuario,
    this.resposta = const Value.absent(),
    this.sincronizar = const Value.absent(),
  })  : dataModificacao = Value(dataModificacao),
        idQuestaoAtividade = Value(idQuestaoAtividade),
        idUsuario = Value(idUsuario);
  static Insertable<LinTbRespostaQuestaoAtividade> custom({
    Expression<int>? dataModificacao,
    Expression<int>? idQuestaoAtividade,
    Expression<int>? idUsuario,
    Expression<int?>? resposta,
    Expression<bool>? sincronizar,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (idQuestaoAtividade != null)
        'id_questao_x_atividade': idQuestaoAtividade,
      if (idUsuario != null) 'id_usuario': idUsuario,
      if (resposta != null) 'resposta': resposta,
      if (sincronizar != null) 'sincronizar': sincronizar,
    });
  }

  TbRespostaQuestaoAtividadeCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? idQuestaoAtividade,
      Value<int>? idUsuario,
      Value<int?>? resposta,
      Value<bool>? sincronizar}) {
    return TbRespostaQuestaoAtividadeCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      idQuestaoAtividade: idQuestaoAtividade ?? this.idQuestaoAtividade,
      idUsuario: idUsuario ?? this.idUsuario,
      resposta: resposta ?? this.resposta,
      sincronizar: sincronizar ?? this.sincronizar,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (idQuestaoAtividade.present) {
      map['id_questao_x_atividade'] = Variable<int>(idQuestaoAtividade.value);
    }
    if (idUsuario.present) {
      map['id_usuario'] = Variable<int>(idUsuario.value);
    }
    if (resposta.present) {
      map['resposta'] = Variable<int?>(resposta.value);
    }
    if (sincronizar.present) {
      map['sincronizar'] = Variable<bool>(sincronizar.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbRespostaQuestaoAtividadeCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('idQuestaoAtividade: $idQuestaoAtividade, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('resposta: $resposta, ')
          ..write('sincronizar: $sincronizar')
          ..write(')'))
        .toString();
  }
}

class $TbRespostaQuestaoAtividadeTable extends TbRespostaQuestaoAtividade
    with
        TableInfo<$TbRespostaQuestaoAtividadeTable,
            LinTbRespostaQuestaoAtividade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbRespostaQuestaoAtividadeTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idQuestaoAtividadeMeta =
      const VerificationMeta('idQuestaoAtividade');
  @override
  late final GeneratedColumn<int?> idQuestaoAtividade = GeneratedColumn<int?>(
      'id_questao_x_atividade', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idUsuarioMeta = const VerificationMeta('idUsuario');
  @override
  late final GeneratedColumn<int?> idUsuario = GeneratedColumn<int?>(
      'id_usuario', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _respostaMeta = const VerificationMeta('resposta');
  @override
  late final GeneratedColumn<int?> resposta = GeneratedColumn<int?>(
      'resposta', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _sincronizarMeta =
      const VerificationMeta('sincronizar');
  @override
  late final GeneratedColumn<bool?> sincronizar = GeneratedColumn<bool?>(
      'sincronizar', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (sincronizar IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [dataModificacao, idQuestaoAtividade, idUsuario, resposta, sincronizar];
  @override
  String get aliasedName => _alias ?? 'resposta_x_questao_x_atividade';
  @override
  String get actualTableName => 'resposta_x_questao_x_atividade';
  @override
  VerificationContext validateIntegrity(
      Insertable<LinTbRespostaQuestaoAtividade> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id_questao_x_atividade')) {
      context.handle(
          _idQuestaoAtividadeMeta,
          idQuestaoAtividade.isAcceptableOrUnknown(
              data['id_questao_x_atividade']!, _idQuestaoAtividadeMeta));
    } else if (isInserting) {
      context.missing(_idQuestaoAtividadeMeta);
    }
    if (data.containsKey('id_usuario')) {
      context.handle(_idUsuarioMeta,
          idUsuario.isAcceptableOrUnknown(data['id_usuario']!, _idUsuarioMeta));
    } else if (isInserting) {
      context.missing(_idUsuarioMeta);
    }
    if (data.containsKey('resposta')) {
      context.handle(_respostaMeta,
          resposta.isAcceptableOrUnknown(data['resposta']!, _respostaMeta));
    }
    if (data.containsKey('sincronizar')) {
      context.handle(
          _sincronizarMeta,
          sincronizar.isAcceptableOrUnknown(
              data['sincronizar']!, _sincronizarMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idQuestaoAtividade, idUsuario};
  @override
  LinTbRespostaQuestaoAtividade map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    return LinTbRespostaQuestaoAtividade.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbRespostaQuestaoAtividadeTable createAlias(String alias) {
    return $TbRespostaQuestaoAtividadeTable(attachedDatabase, alias);
  }
}

class LinTbRespostaQuestao extends DataClass
    implements Insertable<LinTbRespostaQuestao> {
  /// Número de milisegundos desde a época Unix (no fuso horário UTC).
  final int dataModificacao;
  final int idQuestao;
  final int? idUsuario;
  final int? resposta;
  final bool sincronizar;
  LinTbRespostaQuestao(
      {required this.dataModificacao,
      required this.idQuestao,
      this.idUsuario,
      this.resposta,
      required this.sincronizar});
  factory LinTbRespostaQuestao.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LinTbRespostaQuestao(
      dataModificacao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data_modificacao'])!,
      idQuestao: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_questao'])!,
      idUsuario: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_usuario']),
      resposta: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}resposta']),
      sincronizar: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sincronizar'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_modificacao'] = Variable<int>(dataModificacao);
    map['id_questao'] = Variable<int>(idQuestao);
    if (!nullToAbsent || idUsuario != null) {
      map['id_usuario'] = Variable<int?>(idUsuario);
    }
    if (!nullToAbsent || resposta != null) {
      map['resposta'] = Variable<int?>(resposta);
    }
    map['sincronizar'] = Variable<bool>(sincronizar);
    return map;
  }

  TbRespostaQuestaoCompanion toCompanion(bool nullToAbsent) {
    return TbRespostaQuestaoCompanion(
      dataModificacao: Value(dataModificacao),
      idQuestao: Value(idQuestao),
      idUsuario: idUsuario == null && nullToAbsent
          ? const Value.absent()
          : Value(idUsuario),
      resposta: resposta == null && nullToAbsent
          ? const Value.absent()
          : Value(resposta),
      sincronizar: Value(sincronizar),
    );
  }

  factory LinTbRespostaQuestao.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LinTbRespostaQuestao(
      dataModificacao: serializer.fromJson<int>(json['dataModificacao']),
      idQuestao: serializer.fromJson<int>(json['idQuestao']),
      idUsuario: serializer.fromJson<int?>(json['idUsuario']),
      resposta: serializer.fromJson<int?>(json['resposta']),
      sincronizar: serializer.fromJson<bool>(json['sincronizar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataModificacao': serializer.toJson<int>(dataModificacao),
      'idQuestao': serializer.toJson<int>(idQuestao),
      'idUsuario': serializer.toJson<int?>(idUsuario),
      'resposta': serializer.toJson<int?>(resposta),
      'sincronizar': serializer.toJson<bool>(sincronizar),
    };
  }

  LinTbRespostaQuestao copyWith(
          {int? dataModificacao,
          int? idQuestao,
          int? idUsuario,
          int? resposta,
          bool? sincronizar}) =>
      LinTbRespostaQuestao(
        dataModificacao: dataModificacao ?? this.dataModificacao,
        idQuestao: idQuestao ?? this.idQuestao,
        idUsuario: idUsuario ?? this.idUsuario,
        resposta: resposta ?? this.resposta,
        sincronizar: sincronizar ?? this.sincronizar,
      );
  @override
  String toString() {
    return (StringBuffer('LinTbRespostaQuestao(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('idQuestao: $idQuestao, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('resposta: $resposta, ')
          ..write('sincronizar: $sincronizar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dataModificacao, idQuestao, idUsuario, resposta, sincronizar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LinTbRespostaQuestao &&
          other.dataModificacao == this.dataModificacao &&
          other.idQuestao == this.idQuestao &&
          other.idUsuario == this.idUsuario &&
          other.resposta == this.resposta &&
          other.sincronizar == this.sincronizar);
}

class TbRespostaQuestaoCompanion extends UpdateCompanion<LinTbRespostaQuestao> {
  final Value<int> dataModificacao;
  final Value<int> idQuestao;
  final Value<int?> idUsuario;
  final Value<int?> resposta;
  final Value<bool> sincronizar;
  const TbRespostaQuestaoCompanion({
    this.dataModificacao = const Value.absent(),
    this.idQuestao = const Value.absent(),
    this.idUsuario = const Value.absent(),
    this.resposta = const Value.absent(),
    this.sincronizar = const Value.absent(),
  });
  TbRespostaQuestaoCompanion.insert({
    required int dataModificacao,
    this.idQuestao = const Value.absent(),
    this.idUsuario = const Value.absent(),
    this.resposta = const Value.absent(),
    this.sincronizar = const Value.absent(),
  }) : dataModificacao = Value(dataModificacao);
  static Insertable<LinTbRespostaQuestao> custom({
    Expression<int>? dataModificacao,
    Expression<int>? idQuestao,
    Expression<int?>? idUsuario,
    Expression<int?>? resposta,
    Expression<bool>? sincronizar,
  }) {
    return RawValuesInsertable({
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (idQuestao != null) 'id_questao': idQuestao,
      if (idUsuario != null) 'id_usuario': idUsuario,
      if (resposta != null) 'resposta': resposta,
      if (sincronizar != null) 'sincronizar': sincronizar,
    });
  }

  TbRespostaQuestaoCompanion copyWith(
      {Value<int>? dataModificacao,
      Value<int>? idQuestao,
      Value<int?>? idUsuario,
      Value<int?>? resposta,
      Value<bool>? sincronizar}) {
    return TbRespostaQuestaoCompanion(
      dataModificacao: dataModificacao ?? this.dataModificacao,
      idQuestao: idQuestao ?? this.idQuestao,
      idUsuario: idUsuario ?? this.idUsuario,
      resposta: resposta ?? this.resposta,
      sincronizar: sincronizar ?? this.sincronizar,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<int>(dataModificacao.value);
    }
    if (idQuestao.present) {
      map['id_questao'] = Variable<int>(idQuestao.value);
    }
    if (idUsuario.present) {
      map['id_usuario'] = Variable<int?>(idUsuario.value);
    }
    if (resposta.present) {
      map['resposta'] = Variable<int?>(resposta.value);
    }
    if (sincronizar.present) {
      map['sincronizar'] = Variable<bool>(sincronizar.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TbRespostaQuestaoCompanion(')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('idQuestao: $idQuestao, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('resposta: $resposta, ')
          ..write('sincronizar: $sincronizar')
          ..write(')'))
        .toString();
  }
}

class $TbRespostaQuestaoTable extends TbRespostaQuestao
    with TableInfo<$TbRespostaQuestaoTable, LinTbRespostaQuestao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TbRespostaQuestaoTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _dataModificacaoMeta =
      const VerificationMeta('dataModificacao');
  @override
  late final GeneratedColumn<int?> dataModificacao = GeneratedColumn<int?>(
      'data_modificacao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _idQuestaoMeta = const VerificationMeta('idQuestao');
  @override
  late final GeneratedColumn<int?> idQuestao = GeneratedColumn<int?>(
      'id_questao', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _idUsuarioMeta = const VerificationMeta('idUsuario');
  @override
  late final GeneratedColumn<int?> idUsuario = GeneratedColumn<int?>(
      'id_usuario', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _respostaMeta = const VerificationMeta('resposta');
  @override
  late final GeneratedColumn<int?> resposta = GeneratedColumn<int?>(
      'resposta', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _sincronizarMeta =
      const VerificationMeta('sincronizar');
  @override
  late final GeneratedColumn<bool?> sincronizar = GeneratedColumn<bool?>(
      'sincronizar', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (sincronizar IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [dataModificacao, idQuestao, idUsuario, resposta, sincronizar];
  @override
  String get aliasedName => _alias ?? 'resposta_x_questao';
  @override
  String get actualTableName => 'resposta_x_questao';
  @override
  VerificationContext validateIntegrity(
      Insertable<LinTbRespostaQuestao> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_modificacao')) {
      context.handle(
          _dataModificacaoMeta,
          dataModificacao.isAcceptableOrUnknown(
              data['data_modificacao']!, _dataModificacaoMeta));
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('id_questao')) {
      context.handle(_idQuestaoMeta,
          idQuestao.isAcceptableOrUnknown(data['id_questao']!, _idQuestaoMeta));
    }
    if (data.containsKey('id_usuario')) {
      context.handle(_idUsuarioMeta,
          idUsuario.isAcceptableOrUnknown(data['id_usuario']!, _idUsuarioMeta));
    }
    if (data.containsKey('resposta')) {
      context.handle(_respostaMeta,
          resposta.isAcceptableOrUnknown(data['resposta']!, _respostaMeta));
    }
    if (data.containsKey('sincronizar')) {
      context.handle(
          _sincronizarMeta,
          sincronizar.isAcceptableOrUnknown(
              data['sincronizar']!, _sincronizarMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idQuestao};
  @override
  LinTbRespostaQuestao map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LinTbRespostaQuestao.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TbRespostaQuestaoTable createAlias(String alias) {
    return $TbRespostaQuestaoTable(attachedDatabase, alias);
  }
}

abstract class _$DriftDb extends GeneratedDatabase {
  _$DriftDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TbQuestoesTable tbQuestoes = $TbQuestoesTable(this);
  late final $TbAssuntosTable tbAssuntos = $TbAssuntosTable(this);
  late final $TbQuestaoAssuntoTable tbQuestaoAssunto =
      $TbQuestaoAssuntoTable(this);
  late final $TbTiposAlternativaTable tbTiposAlternativa =
      $TbTiposAlternativaTable(this);
  late final $TbAlternativasTable tbAlternativas = $TbAlternativasTable(this);
  late final $TbQuestoesCadernoTable tbQuestoesCaderno =
      $TbQuestoesCadernoTable(this);
  late final $TbUsuariosTable tbUsuarios = $TbUsuariosTable(this);
  late final $TbClubesTable tbClubes = $TbClubesTable(this);
  late final $TbTiposPermissaoTable tbTiposPermissao =
      $TbTiposPermissaoTable(this);
  late final $TbClubeUsuarioTable tbClubeUsuario = $TbClubeUsuarioTable(this);
  late final $TbAtividadesTable tbAtividades = $TbAtividadesTable(this);
  late final $TbQuestaoAtividadeTable tbQuestaoAtividade =
      $TbQuestaoAtividadeTable(this);
  late final $TbRespostaQuestaoAtividadeTable tbRespostaQuestaoAtividade =
      $TbRespostaQuestaoAtividadeTable(this);
  late final $TbRespostaQuestaoTable tbRespostaQuestao =
      $TbRespostaQuestaoTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        tbQuestoes,
        tbAssuntos,
        tbQuestaoAssunto,
        tbTiposAlternativa,
        tbAlternativas,
        tbQuestoesCaderno,
        tbUsuarios,
        tbClubes,
        tbTiposPermissao,
        tbClubeUsuario,
        tbAtividades,
        tbQuestaoAtividade,
        tbRespostaQuestaoAtividade,
        tbRespostaQuestao
      ];
}

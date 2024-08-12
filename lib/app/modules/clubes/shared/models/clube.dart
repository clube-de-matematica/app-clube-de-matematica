import 'dart:convert';

import 'package:flutter/painting.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/utils/db/codificacao.dart';
import '../../../../shared/utils/strings_db.dart';
import '../../modules/atividades/models/atividade.dart';
import '../utils/random_colors.dart';
import 'usuario_clube.dart';

part 'clube.g.dart';

/// Permissões de acesso do usuário aos clubes.
class PermissoesClube {
  const PermissoesClube._(this.id);

  /// Id da permissão no banco de dados, exceto para [PermissoesClube.externo] que não
  /// existe no banco de dados.
  final int id;

  /// O usuário atual não pertence ao clube. Não pode acessar as informações do clube.
  static const externo = PermissoesClube._(-1);

  /// O usuário atual é o propriietário do clube.
  static const proprietario =
      PermissoesClube._(DbConst.kDbDataUserClubeKeyIdPermissaoProprietario);

  /// O usuário atual é o administrador do clube.
  static const administrador =
      PermissoesClube._(DbConst.kDbDataUserClubeKeyIdPermissaoAdministrador);

  /// O usuário atual não é proprietário nem administrador, mas pertence ao clube.
  static const membro =
      PermissoesClube._(DbConst.kDbDataUserClubeKeyIdPermissaoMembro);

  static const values = [externo, proprietario, administrador, membro];

  static const _dados = {
    externo: 'externo',
    proprietario: 'proprietario',
    administrador: 'administrador',
    membro: 'membro',
  };

  /// Retorna `null` se [nome] não tiver um valor correspondente.
  static PermissoesClube? parse(String nome) =>
      _dados.map((valor, nome) => MapEntry(nome, valor))[nome];

  /// Retorna `null` se [id] não tiver um valor correspondente.
  static PermissoesClube? obter(int id) {
    return values
        .cast<PermissoesClube?>()
        .firstWhere((valor) => valor?.id == id, orElse: () => null);
  }

  @override
  String toString() {
    return 'PermissoesClube.${_dados[this]}';
  }
}

class Clube extends _ClubeBase with _$Clube {
  Clube({
    required super.id,
    required super.nome,
    super.descricao,
    super.usuarios,
    super.capa,
    required super.codigo,
    required super.privado,
    super.atividades,
  });

  /// Cria um objeto [Clube] a partir do [DataClube] [map].
  factory Clube.fromDataClube(DataClube map) {
    final usuarios = (map[DbConst.kDbDataClubeKeyUsuarios] as List)
        .cast<DataUsuarioClube>()
        .map((dados) => UsuarioClube.fromDataUsuarioClube(dados));

    return Clube(
      id: map[DbConst.kDbDataClubeKeyId],
      nome: map[DbConst.kDbDataClubeKeyNome],
      descricao: map[DbConst.kDbDataClubeKeyDescricao],
      usuarios: usuarios,
      capa: DbRemoto.decodificarCapaClube(
          map[DbConst.kDbDataClubeKeyCapa].toString()),
      codigo: map[DbConst.kDbDataClubeKeyCodigo],
      privado: map[DbConst.kDbDataClubeKeyPrivado],
    );
  }

  factory Clube.fromJsonDataClube(String source) =>
      Clube.fromDataClube(json.decode(source));

  Clube copyWith({
    int? id,
    String? nome,
    String? descricao,
    Iterable<UsuarioClube>? usuarios,
    Color? capa,
    String? codigo,
    bool? privado,
    Iterable<Atividade>? atividades,
  }) {
    return Clube(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      usuarios: usuarios ?? this.usuarios,
      capa: capa ?? this.capa,
      codigo: codigo ?? this.codigo,
      privado: privado ?? this.privado,
      atividades: atividades ?? this.atividades,
    );
  }
}

abstract class _ClubeBase with Store {
  _ClubeBase({
    required this.id,
    required this.nome,
    this.descricao,
    Iterable<UsuarioClube>? usuarios,
    Color? capa,
    required this.codigo,
    required this.privado,
    Iterable<Atividade>? atividades,
  })  : capa = capa ?? RandomColor(),
        atividades = ObservableSetAtividades(idClube: id)
          ..addAll(atividades ?? []),
        usuarios = ObservableSetUsuariosClube(idClube: id)
          ..addAll(usuarios ?? []);

  /// ID do clube.
  final int id;

  /// Nome do clube.
  @observable
  String nome;

  /// Uma pequena descrição do clube.
  @observable
  String? descricao;

  /// Cor do tema do clube.
  @observable
  Color capa;

  /// O ID base62 para acesso ao clube.
  @observable
  String codigo;

  /// Define o nível de privacidade do clube.
  /// * Se `false`, o clube é público. Qualquer usuário com o código de acesso pode ingressar.
  /// * Se `true`, o clube é privado. O ingresso depende da permissão de um administrador.
  bool privado;

  /// Conjunto com todos os participantes do deste clube.
  final ObservableSetUsuariosClube usuarios;

  /// Conjunto com as atividades do clube.
  final ObservableSetAtividades atividades;

  /// Objeto [UsuarioClube] do proprietário do clube.
  UsuarioClube? get proprietario => usuarios.cast<UsuarioClube?>().firstWhere(
        (usuario) => usuario!.proprietario,
        orElse: () => null,
      );

  /// Uma coleção com o objeto [UsuarioClube] de cada administrador deste clube.
  @computed
  Iterable<UsuarioClube> get administradores =>
      usuarios.where((usuario) => usuario.administrador);

  /// Uma coleção com o objeto [UsuarioClube] de cada membro (exclui-se
  /// proprietário e administradores) deste clube.
  @computed
  Iterable<UsuarioClube> get membros =>
      usuarios.where((usuario) => usuario.permissao == PermissoesClube.membro);

  /// Retorna o usuário correspondente ao [id].
  /// Retorns `null` se o usuário não for encontrado.
  UsuarioClube? getUsuario(int id) {
    try {
      return usuarios.firstWhere((usuario) => usuario.id == id);
    } on StateError catch (_) {
      return null;
    }
  }

  /// Retorna a permissão de acesso, do usuário correspondente ao [id], aos dados do clube.
  PermissoesClube permissao(int id) {
    return getUsuario(id)?.permissao ?? PermissoesClube.externo;
  }

  /// Retorna `true` se o usuário correspondente ao [id] tiver permissão para criar atividade.
  bool permissaoCriarAtividade(int id) {
    final permissaoClube = getUsuario(id)?.permissao;
    return permissaoClube == PermissoesClube.proprietario ||
        permissaoClube == PermissoesClube.administrador;
  }

  /// Sobrescreve os campos modificáveis deste clube com os respectivos
  /// valores em [outro], desde que os tenham o mesmo ID.
  void mesclar(Clube outro) {
    if (id == outro.id) {
      nome = outro.nome;
      descricao = outro.descricao;
      capa = outro.capa;
      codigo = outro.codigo;
      privado = outro.privado;
      usuarios
        ..removeAll(usuarios.difference(outro.usuarios))
        ..addAll(outro.usuarios);
      atividades
        ..removeAll(atividades.difference(outro.atividades))
        ..addAll(outro.atividades);
    }
  }
}

/// Usada para preencher parcialmente os dados de um clube.
class RawClube {
  RawClube({
    this.id,
    this.capa,
    this.codigo,
    this.descricao,
    this.nome,
    this.privado,
    this.usuarios,
    this.atividades,
  });

  final int? id;
  final Color? capa;
  final String? codigo;
  final String? descricao;
  final String? nome;
  final bool? privado;
  final List<RawUsuarioClube>? usuarios;
  final List<Atividade>? atividades;

  DataClube toDataClube() {
    final usuarios =
        this.usuarios?.map((usuario) => usuario.toDataUsuarioClube()).toList();
    return {
      DbConst.kDbDataClubeKeyId: id,
      DbConst.kDbDataClubeKeyNome: nome,
      DbConst.kDbDataClubeKeyDescricao: descricao,
      DbConst.kDbDataClubeKeyUsuarios: usuarios,
      DbConst.kDbDataClubeKeyCapa:
          capa != null ? DbRemoto.codificarCapaClube(capa!) : null,
      DbConst.kDbDataClubeKeyCodigo: codigo,
      DbConst.kDbDataClubeKeyPrivado: privado,
    };
  }

  String toJsonDataClube() => json.encode(toDataClube());

  RawClube copyWith({
    int? id,
    Color? capa,
    String? codigo,
    String? descricao,
    String? nome,
    bool? privado,
    Iterable<RawUsuarioClube>? usuarios,
    List<Atividade>? atividades,
  }) {
    return RawClube(
      id: id ?? this.id,
      capa: capa ?? this.capa,
      codigo: codigo ?? this.codigo,
      descricao: descricao ?? this.descricao,
      nome: nome ?? this.nome,
      privado: privado ?? this.privado,
      usuarios: usuarios?.toList() ?? this.usuarios,
      atividades: atividades ?? this.atividades,
    );
  }
}

/// Conjunto com os [UsuarioClube] de um clube.
class ObservableSetUsuariosClube extends ObservableSet<UsuarioClube> {
  ObservableSetUsuariosClube({
    required this.idClube,
  });

  final int idClube;

  @override
  bool contains(Object? element) {
    if (element is UsuarioClube) {
      if (element.idClube != idClube) return false;
      return where((e) => e.id == element.id).isNotEmpty;
    }
    return false;
  }

  @override
  bool add(UsuarioClube value) => _add(value);

  @action
  bool _add(UsuarioClube usuario) {
    if (usuario.idClube != idClube) return false;
    try {
      firstWhere((e) => e.id == usuario.id).mesclar(usuario);
      return true;
    } on StateError catch (_) {
      return super.add(usuario);
    }
  }

  @override
  bool remove(Object? value) {
    if (value is UsuarioClube) return _remove(value);
    return false;
  }

  @action
  bool _remove(UsuarioClube usuario) {
    try {
      return super.remove(firstWhere((e) => e.id == usuario.id));
    } on StateError catch (_) {
      return false;
    }
  }

  @override
  Set<UsuarioClube> intersection(Set<Object?> other) {
    Set<UsuarioClube> resultado = toSet();
    resultado.removeWhere(
      (usuario) => !other.any((e) => e is UsuarioClube && e.id == usuario.id),
    );
    return resultado;
  }

  @override
  Set<UsuarioClube> difference(Set<Object?> other) {
    Set<UsuarioClube> resultado = toSet();
    resultado.removeWhere(
      (usuario) => other.any((e) => e is UsuarioClube && e.id == usuario.id),
    );
    return resultado;
  }
}

/// Conjunto com os [Atividade] de um clube.
class ObservableSetAtividades extends ObservableSet<Atividade> {
  ObservableSetAtividades({
    required this.idClube,
  });

  final int idClube;

  @override
  bool contains(Object? element) {
    if (element is Atividade) {
      if (element.idClube != idClube) return false;
      return where((e) => e.id == element.id).isNotEmpty;
    }
    return false;
  }

  @override
  bool add(Atividade value) => _add(value);

  @action
  bool _add(Atividade atividade) {
    if (atividade.idClube != idClube) return false;
    try {
      firstWhere((e) => e.id == atividade.id).mesclar(atividade);
      return true;
    } on StateError catch (_) {
      return super.add(atividade);
    }
  }

  @override
  bool remove(Object? value) {
    if (value is Atividade) return _remove(value);
    return false;
  }

  @action
  bool _remove(Atividade atividade) {
    try {
      return super.remove(firstWhere((e) => e.id == atividade.id));
    } on StateError catch (_) {
      return false;
    }
  }

  @override
  Set<Atividade> intersection(Set<Object?> other) {
    Set<Atividade> resultado = toSet();
    resultado.removeWhere(
      (atividade) => !other.any((e) => e is Atividade && e.id == atividade.id),
    );
    return resultado;
  }

  @override
  Set<Atividade> difference(Set<Object?> other) {
    Set<Atividade> resultado = toSet();
    resultado.removeWhere(
      (atividade) => other.any((e) => e is Atividade && e.id == atividade.id),
    );
    return resultado;
  }
}

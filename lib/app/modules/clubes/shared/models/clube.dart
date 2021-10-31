import 'dart:convert';

import 'package:flutter/painting.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/models/debug.dart';
import '../../../../shared/utils/strings_db.dart';
import '../utils/random_colors.dart';
import 'atividade.dart';
import 'usuario_clube.dart';

part 'clube.g.dart';

/// Permissões de acesso do usuário aos clubes.
enum PermissoesClube {
  /// O usuário atual é o propriietário do clube.
  proprietario,

  /// O usuário atual é o administrador do clube.
  administrador,

  /// O usuário atual não é proprietário nem administrador, mas pertence ao clube.
  membro,

  /// O usuário atual não pertence ao clube. Não pode acessar as informações do clube.
  externo,
}

extension PermissoesClubeExtension on PermissoesClube {
  /// Retorna o ID da permissão no banco de dados.
  /// Retorna -1 se a permissão não estiver registrada no banco de dados.
  int get id {
    switch (this) {
      case PermissoesClube.proprietario:
        return 0;
      case PermissoesClube.administrador:
        return 1;
      case PermissoesClube.membro:
        return 2;
      case PermissoesClube.externo:
        return -1;
    }
  }
}

class Clube extends _ClubeBase with _$Clube {
  Clube({
    required int id,
    required String nome,
    String? descricao,
    required UsuarioClube proprietario,
    Iterable<UsuarioClube>? usuarios,
    Color? capa,
    required String codigo,
    required bool privado,
    List<Atividade> atividades = const [],
  }) : super(
          id: id,
          nome: nome,
          descricao: descricao,
          proprietario: proprietario,
          usuarios: usuarios,
          capa: capa,
          codigo: codigo,
          privado: privado,
          atividades: atividades,
        );

  /// Cria um objeto [Clube] a partir do [DataClube] [map].
  factory Clube.fromDataClube(DataClube map) {
    final _idClube = map[DbConst.kDbDataClubeKeyId] as int;

    final _proprietario = UsuarioClube(
      id: map[DbConst.kDbDataClubeKeyProprietario] as int,
      idClube: _idClube,
      permissao: PermissoesClube.proprietario,
    );

    final _administradores =
        (map[DbConst.kDbDataClubeKeyAdministradores] as List)
            .cast<int>()
            .map((idUsuario) => UsuarioClube(
                  id: idUsuario,
                  idClube: _idClube,
                  permissao: PermissoesClube.administrador,
                ));

    final _membros = (map[DbConst.kDbDataClubeKeyMembros] as List)
        .cast<int>()
        .map((idUsuario) => UsuarioClube(
              id: idUsuario,
              idClube: _idClube,
              permissao: PermissoesClube.membro,
            ));

    final _usuarios = _membros.toList()
      ..addAll(_administradores)
      ..add(_proprietario);

    Color? _capa;
    try {
      _capa = Color(int.parse(map[DbConst.kDbDataClubeKeyCapa]));
    } catch (_) {
      assert(Debug.print(
          '[ATTENTION] Não foi possível gerar a cor da capa a partir de '
          '${map[DbConst.kDbDataClubeKeyCapa]}.'));
    }

    return Clube(
      id: _idClube,
      nome: map[DbConst.kDbDataClubeKeyNome],
      descricao: map[DbConst.kDbDataClubeKeyDescricao],
      proprietario: _proprietario,
      usuarios: _usuarios,
      capa: _capa,
      codigo: map[DbConst.kDbDataClubeKeyCodigo],
      privado: map[DbConst.kDbDataClubeKeyPrivado],
    );
  }

  factory Clube.fromJsonDataClube(String source) =>
      Clube.fromDataClube(json.decode(source));
}

abstract class _ClubeBase with Store {
  /// ID do clube.
  final int id;

  /// Nome do clube.
  @observable
  String nome;

  /// Uma pequena descrição do clube.
  @observable
  String? descricao;

  /// Objeto [UsuarioClube] do proprietário do clube.
  final UsuarioClube proprietario;

  /// Conjunto com todos os participantes do deste clube.
  @observable
  ObservableSet<UsuarioClube> _usuarios;

  /// Cor de fundo do [Card] e do avatar do clube.
  @observable
  Color capa;

  /// O ID base62 para acesso ao clube.
  String codigo;

  /// Define o nível de privacidade do clube.
  /// * Se `false`, o clube é público. Qualquer usuário com o código de acesso pode ingressar.
  /// * Se `true`, o clube é privado. O ingresso depende da permissão de um administrador.
  bool privado;

  /// Lista com as atividades do clube.
  final List<Atividade> atividades;

  /// Uma lista com o objeto [UsuarioClube] de cada participantes do deste clube.
  ///
  /// ***ATENÇÃO!*** *Esta lista não deve ser alterada.*
  @computed
  ObservableList<UsuarioClube> get usuarios => ObservableList.of(_usuarios);

  /// Uma lista com o objeto [UsuarioClube] de cada administrador do clube.
  ///
  /// ***ATENÇÃO!*** *Esta lista não deve ser alterada.*
  @computed
  ObservableList<UsuarioClube> get administradores =>
      ObservableList.of(_usuarios.where((usuario) => usuario.administrador));

  /// Uma lista com o objeto [UsuarioClube] de cada membro (excluindo-se
  /// proprietário e administradores) do clube.
  ///
  /// ***ATENÇÃO!*** *Esta lista não deve ser alterada.*
  @computed
  ObservableList<UsuarioClube> get membros => ObservableList.of(_usuarios
      .where((usuario) => usuario.permissao == PermissoesClube.membro));

  _ClubeBase({
    required this.id,
    required this.nome,
    this.descricao,
    required UsuarioClube proprietario,
    Iterable<UsuarioClube>? usuarios,
    Color? capa,
    required this.codigo,
    required this.privado,
    this.atividades = const [],
  })  : this.capa = capa ?? RandomColor(),
        this.proprietario = proprietario,
        this._usuarios = ObservableSet<UsuarioClube>()
          ..add(proprietario)
          ..addAll(usuarios?.where((usuario) => !usuario.proprietario) ?? []);
  /* 
  {
    if (usuarios?.contains(proprietario) ?? false) {
      addUsuarios(usuarios!);
    } else {
      if (usuarios != null) _usuarios.addAll(usuarios);
      addUsuarios([proprietario]);
    }
  }
   */

  DataClube toDataClube() {
    final administradores =
        this.administradores.map((usuario) => usuario.id).toList();
    final membros = this.membros.map((usuario) => usuario.id).toList();
    return {
      DbConst.kDbDataClubeKeyId: id,
      DbConst.kDbDataClubeKeyNome: nome,
      DbConst.kDbDataClubeKeyDescricao: descricao,
      DbConst.kDbDataClubeKeyProprietario: proprietario.id,
      DbConst.kDbDataClubeKeyAdministradores: administradores,
      DbConst.kDbDataClubeKeyMembros: membros,
      DbConst.kDbDataClubeKeyCapa: '${capa.value}',
      DbConst.kDbDataClubeKeyCodigo: codigo,
      DbConst.kDbDataClubeKeyPrivado: privado,
    };
  }

  String toJsonDataClube() => json.encode(toDataClube());

  /// Sobrescreve os campos deste clube com os respectivos valores em [outro], desde que
  /// tenham o mesmo ID.
  @action
  void sobrescrever(Clube outro) {
    if (this.id == outro.id) {
      nome = outro.nome;
      descricao = outro.descricao;
      capa = outro.capa;
      codigo = outro.codigo;
      privado = outro.privado;
      proprietario.sobrescrever(outro.proprietario);
      _usuarios.removeWhere((usuario) => !usuario.proprietario);
      _usuarios
          .addAll(outro._usuarios.where((usuario) => !usuario.proprietario));
    }
  }

  @action
  void addUsuarios(Iterable<UsuarioClube> usuarios, {bool verificar = false}) {
    if (verificar) {
      usuarios.forEach((usuario) {
        try {
          _usuarios
              .firstWhere((_usuario) => _usuario.id == usuario.id)
              .sobrescrever(usuario);
        } catch (_) {
          _usuarios.add(usuario);
        }
      });
      return;
    }
    _usuarios.addAll(usuarios);
  }

  /// Remove deste clube os elementos de [usuarios].
  @action
  void removerUsuarios(Iterable<UsuarioClube> usuarios) {
    usuarios.forEach((usuario) {
      _usuarios.removeWhere((_usuario) => usuario.id == _usuario.id);
    });
  }

  /// Retorna o usuário correspondente ao [id].
  /// Retorns `null` se o usuário não for encontrado.
  UsuarioClube? getUsuario(int id) {
    try {
      return _usuarios.firstWhere((usuario) => usuario.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Retorna a permissão de acesso, do usuário correspondente ao [id], aos dados do clube.
  PermissoesClube permissao(int id) {
    return getUsuario(id)?.permissao ?? PermissoesClube.externo;
  }
}

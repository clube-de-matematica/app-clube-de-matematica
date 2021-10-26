import 'dart:convert';

import 'package:clubedematematica/app/modules/clubes/shared/models/usuario_clube.dart';
import 'package:flutter/painting.dart';

import '../../../../shared/models/debug.dart';
import '../../../../shared/utils/strings_db.dart';
import '../utils/random_colors.dart';

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

class Clube {
  /// ID do clube.
  final int id;

  /// Nome do clube.
  String nome;

  /// Uma pequena descrição do clube.
  String? descricao;

  /// Objeto [UsuarioClube] do proprietário do clube.
  final UsuarioClube proprietario;

  /// Conjunto com todos os participantes do deste clube.
  final Set<UsuarioClube> _usuarios;

  /// Cor de fundo do [Card] e do avatar do clube.
  Color capa;

  /// O ID base62 para acesso ao clube.
  String codigo;

  /// Define o nível de privacidade do clube.
  /// * Se `false`, o clube é público. Qualquer usuário com o código de acesso pode ingressar.
  /// * Se `true`, o clube é privado. O ingresso depende da permissão de um administrador.
  bool privado;

  /// Uma lista inalterável com o objeto [UsuarioClube] de cada participantes do deste clube.
  List<UsuarioClube> get usuarios => List.unmodifiable(_usuarios);

  /// Uma lista inalterável com o objeto [UsuarioClube] de cada administrador do clube.
  List<UsuarioClube> get administradores =>
      List.unmodifiable(_usuarios.where((usuario) => usuario.administrador));

  /// Uma lista inalterável com o objeto [UsuarioClube] de cada membro (excluindo-se
  /// proprietário e administradores) do clube.
  List<UsuarioClube> get membros => List.unmodifiable(_usuarios
      .where((usuario) => usuario.permissao == PermissoesClube.membro));

  Clube({
    required this.id,
    required this.nome,
    this.descricao,
    required UsuarioClube proprietario,
    Iterable<UsuarioClube>? usuarios,
    Color? capa,
    required this.codigo,
    required this.privado,
  })  : this.capa = capa ?? RandomColor(),
        this.proprietario = proprietario,
        this._usuarios = (usuarios?.contains(proprietario) ?? false)
            ? Set.from(usuarios!)
            : [proprietario].toSet();

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
      assert(Debug.print('Não foi possível gerar a cor da capa a partir de '
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

  factory Clube.fromJsonDataClube(String source) =>
      Clube.fromDataClube(json.decode(source));

  String toJsonDataClube() => json.encode(toDataClube());

  /// Sobrescreve os campos deste clube com os respectivos valores em [outro], desde que
  /// tenham o mesmo ID.
  void sobrescrever(Clube outro) {
    nome = outro.nome;
    descricao = outro.descricao;
    capa = outro.capa;
    codigo = outro.codigo;
    privado = outro.privado;
    proprietario.email = outro.proprietario.email;
    proprietario.nome = outro.proprietario.nome;
    proprietario.foto = outro.proprietario.foto;
    proprietario.permissao = outro.proprietario.permissao;
    _usuarios.removeWhere((usuario) => !usuario.proprietario);
    _usuarios.addAll(outro._usuarios.where((usuario) => !usuario.proprietario));
  }

  void addUsuarios(Iterable<UsuarioClube> usuarios) {
    _usuarios.addAll(usuarios);
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

// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../../shared/extensions.dart';
import '../../../shared/models/exceptions/my_exception.dart';
import '../../../shared/repositories/interface_auth_repository.dart';
import '../../../shared/repositories/local_storage_repository.dart';
import '../../../shared/utils/strings_db.dart';

part 'userapp.g.dart';

/// A Key para a propriedade `id` no json de [UserApp.fromJson(json)].
const ID = "id";

/// A Key para a propriedade `name` no json de [UserApp.fromJson(json)].
const NOME = "name";

/// A Key para a propriedade `email` no json de [UserApp.fromJson(json)].
const EMAIL = "email";

/// A Key para a propriedade `pathAvatar` no json de [UserApp.fromJson(json)].
const PATH_AVATAR = "pathAvatar";

/// A Key para a propriedade `urlAvatar` no json de [UserApp.fromJson(json)].
const URL_AVATAR = "urlAvatar";

/// Modelo para o usuário do App.
class UserApp extends _UserAppBase with _$UserApp {
  static final _instance = UserApp._();
  static UserApp get instance => _instance;

  UserApp._() : super();

  factory UserApp({
    int? id,
    String? name,
    String? email,
    String? pathAvatar,
    String? urlAvatar,
  }) {
    return instance..set(id, name, email, pathAvatar, urlAvatar);
  }

  factory UserApp.fromJson(Map<String, dynamic> json) {
    return instance
      ..set(
        json[ID],
        json[NOME],
        json[EMAIL],
        json[PATH_AVATAR],
        json[URL_AVATAR],
      );
  }
}

abstract class _UserAppBase extends ChangeNotifier with Store {
  /// ID do usuário no banco de dados.
  @observable
  int? _id;

  /// Nome do usuário.
  @observable
  String? _name;

  /// Email do usuário.
  String? _email;

  /// Path da imágem do avatar do usuário.
  /// Para a Web é uma URL.
  String? _pathAvatar;

  /// URL da imágem do avatar do usuário.
  String? _urlAvatar;

  /// A instância de [IAuthRepository].
  //IAuthRepository get _auth => Modular.get<IAuthRepository>();

  /// Retorna `true` se houver um usuário amônimo conectado.
  bool get isAnonymous => _id == null;

  _UserAppBase({
    int? id,
    String? name,
    String? email,
    String? pathAvatar,
    String? urlAvatar,
  }) {
    _id = id;
    FirebaseCrashlytics.instance.setUserIdentifier('$id');
    _name = name;
    _email = email;
    _pathAvatar = pathAvatar;
    _urlAvatar = urlAvatar;
  }

  @action
  Future<void> set(
    int? id,
    String? name,
    String? email,
    String? pathAvatar,
    String? urlAvatar,
  ) async {
    _id = id;
    FirebaseCrashlytics.instance.setUserIdentifier('$id');
    _name = name;
    _email = email;
    _urlAvatar = urlAvatar;
    if (pathAvatar == null && !kIsWeb) await _deleteImageAvatar();
    _pathAvatar = pathAvatar;
    notifyListeners();
  }

  /// Define [_id], [_name], [_email], [_urlAvatar] e [_pathAvatar] para `null`.
  Future<void> reset() => set(null, null, null, null, null);

  /// O nome do arquivo da imagem do avatar do usuário sem a extensão.
  static const _AVATAR_IMAGE_NAME = "user_app";

  /// ID do usuário.
  @computed
  int? get id => _id;

  /// ID do usuário.
  set id(int? id) => _setId(id);

  /// Definir o ID do usuário.
  @action
  void _setId(int? id) {
    if (id != _id) {
      _id = id;
      FirebaseCrashlytics.instance.setUserIdentifier('$id');
      notifyListeners();
    }
  }

  /// Nome do usuário.
  @computed
  String? get name => _name;

  /// Nome do usuário.
  set name(String? name) => _setName(name);

  /// Definir o nome do usuário.
  @action
  void _setName(String? name) {
    final condition = name?.isNotEmpty ?? true;
    assert(condition);
    if (condition) {
      _name = name;
      notifyListeners();
    }
  }

  /// Email do usuário.
  String? get email => _email;

  /// Email do usuário.
  set email(String? email) {
    final condition = email?.isNotEmpty ?? true;
    assert(condition);
    if (condition) {
      _email = email;
      notifyListeners();
    }
  }

  /// Path da imágem do avatar do usuário.
  /// Para a Web é uma URL.
  String? get pathAvatar => _pathAvatar;

  /// Path da imágem do avatar do usuário.
  /// Para a Web é uma URL.
  set pathAvatar(String? pathAvatar) {
    final condition = pathAvatar?.isNotEmpty ?? true;
    assert(condition);
    if (condition) {
      if (kIsWeb) {
        _pathAvatar = pathAvatar;
      } else {
        if (pathAvatar != null) {
          _saveImageAvatar(pathAvatar).then((file) {
            if (file != null) {
              _pathAvatar = file.path;
            } else {
              _pathAvatar = pathAvatar;
            }
            notifyListeners();
          });
        }
      }
    }
  }

  /// URL da imágem do avatar do usuário.
  String? get urlAvatar => _urlAvatar;

  /// URL da imágem do avatar do usuário.
  set urlAvatar(String? urlAvatar) {
    final condition = urlAvatar?.isNotEmpty ?? true;
    assert(condition);
    if (condition) {
      _urlAvatar = urlAvatar;
      notifyListeners();
    }
  }

  /// Apenas para Android e IOS.
  /// Path do diretório do arquivos da imagem do avatar do usuário.
  static const _DIR_AVATAR =
      LocalStorageRepository.DIR_PROFILE_PHOTOS_RELATIVE_PATH;

  /// Apenas para Android e IOS.
  /// Salva o arquivo da imagem do avatar do usuário no diretório do aplicativo.
  /// [path] é o path da origem do arquivo.
  /// Retorna `null` se o arquivo em [path] não for salvo com sucesso.
  Future<File?> _saveImageAvatar(String path) async {
    if (kIsWeb) {
      throw MyException(
          "Salvar localmente a imagem do usúário não está disponível na verção web.");
    } else {
      final newRelativePath =
          _DIR_AVATAR + _AVATAR_IMAGE_NAME + File(path).extension();
      _deleteImageAvatar();
      return LocalStorageRepository.copyFile(
        path: path,
        newRelativePath: newRelativePath,
      );
    }
  }

  /// Apenas para Android e IOS.
  /// Se existir, exclui o arquivo com a imágem usada no avatar.
  /// Retorna, assincronamente, `false` se o arquivo não for encontrado ou se ocorrer um erro.
  Future<bool> _deleteImageAvatar() async {
    if (kIsWeb) {
      throw MyException(
          "Deletar localmente a imagem do usúário não está disponível na verção web.");
    } else {
      final images = await LocalStorageRepository.find(
          relativePath: "$_DIR_AVATAR$_AVATAR_IMAGE_NAME.*");
      return LocalStorageRepository.delete(fileList: images);
    }
  }

  DataUsuario toDataUsuario() {
    return {
      DbConst.kDbDataUserKeyId: id,
      DbConst.kDbDataUserKeyNome: name,
      DbConst.kDbDataUserKeyFoto: urlAvatar,
      DbConst.kDbDataUserKeyEmail: email,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ID] = _id ?? "";
    data[NOME] = _name ?? "";
    data[EMAIL] = _email ?? "";
    data[PATH_AVATAR] = _pathAvatar ?? "";
    data[URL_AVATAR] = _urlAvatar ?? "";
    return data;
  }

  @override
  String toString() {
    return '_UserAppBase(_id: $_id, _name: $_name, _email: $_email, _pathAvatar: $_pathAvatar, _urlAvatar: $_urlAvatar)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is _UserAppBase &&
        o._id == _id &&
        o._name == _name &&
        o._email == _email &&
        o._pathAvatar == _pathAvatar &&
        o._urlAvatar == _urlAvatar;
  }

  @override
  int get hashCode {
    return _id.hashCode ^
        _name.hashCode ^
        _email.hashCode ^
        _pathAvatar.hashCode ^
        _urlAvatar.hashCode;
  }
}

class RawUserApp {
  final int? id;
  final String? name;
  final String? email;
  final String? urlAvatar;

  RawUserApp({
    this.id,
    this.name,
    this.email,
    this.urlAvatar,
  });

  RawUserApp.fromDataUsuario(DataUsuario dados)
      : id = dados[DbConst.kDbDataUserKeyId],
        name = dados[DbConst.kDbDataUserKeyNome],
        urlAvatar = dados[DbConst.kDbDataUserKeyFoto],
        email = dados[DbConst.kDbDataUserKeyEmail];

  DataUsuario toDataUsuario() {
    return {
      DbConst.kDbDataUserKeyId: id,
      DbConst.kDbDataUserKeyNome: name,
      DbConst.kDbDataUserKeyFoto: urlAvatar,
      DbConst.kDbDataUserKeyEmail: email,
    };
  }

  RawUserApp copyWith({
    int? id,
    String? name,
    String? email,
    String? urlAvatar,
  }) {
    return RawUserApp(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      urlAvatar: urlAvatar ?? this.urlAvatar,
    );
  }
}

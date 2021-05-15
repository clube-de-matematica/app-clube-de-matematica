import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../../shared/extensions.dart';
import '../../../shared/models/exceptions/my_exception.dart';
import '../../../shared/repositories/local_storage_repository.dart';

part 'userapp.g.dart';

///A Key para a propriedade `name` no json de [UserApp.fromJson(json)].
const NOME = "name";

///A Key para a propriedade `email` no json de [UserApp.fromJson(json)].
const EMAIL = "email";

///A Key para a propriedade `pathAvatar` no json de [UserApp.fromJson(json)].
const PATH_AVATAR = "pathAvatar";

///A Key para a propriedade `urlAvatar` no json de [UserApp.fromJson(json)].
const URL_AVATAR = "urlAvatar";

///Modelo para o usuário do App.
class UserApp extends _UserAppBase with _$UserApp {
  UserApp({
    String? name,
    String? email,
    String? pathAvatar,
    String? urlAvatar,
  }) : super(
          name: name,
          email: email,
          pathAvatar: pathAvatar,
          urlAvatar: urlAvatar,
        );

  UserApp.fromJson(Map<String, dynamic> json)
      : super(
          name: json[NOME],
          email: json[EMAIL],
          pathAvatar: json[PATH_AVATAR],
          urlAvatar: json[URL_AVATAR],
        );
}

abstract class _UserAppBase extends ChangeNotifier with Store {
  ///Nome do usuário.
  @observable
  String? _name;

  ///Email do usuário.
  String? _email;

  ///Path da imágem do avatar do usuário.
  ///Para a Web é uma URL.
  String? _pathAvatar;

  ///URL da imágem do avatar do usuário.
  String? _urlAvatar;

  _UserAppBase({
    String? name,
    String? email,
    String? pathAvatar,
    String? urlAvatar,
  }) {
    this._name = name;
    this._email = email;
    this._pathAvatar = pathAvatar;
    this._urlAvatar = urlAvatar;
  }

  ///O nome do arquivo da imagem do avatar do usuário sem a extensão.
  static const _AVATAR_IMAGE_NAME = "user_app";

  ///Nome do usuário.
  @computed
  String? get name => _name;

  ///Nome do usuário.
  set name(String? name) => _setName(name);

  ///Definir o nome do usuário.
  @action
  void _setName(String? name) {
    final condition = name?.isNotEmpty ?? true;
    assert(condition);
    if (condition) {
      _name = name;
      notifyListeners();
    }
  }

  ///Email do usuário.
  String? get email => _email;

  ///Email do usuário.
  set email(String? email) {
    final condition = email?.isNotEmpty ?? true;
    assert(condition);
    if (condition) {
      _email = email;
      notifyListeners();
    }
  }

  ///Path da imágem do avatar do usuário.
  ///Para a Web é uma URL.
  String? get pathAvatar => _pathAvatar;

  ///Path da imágem do avatar do usuário.
  ///Para a Web é uma URL.
  set pathAvatar(String? pathAvatar) {
    final condition = pathAvatar?.isNotEmpty ?? true;
    assert(condition);
    if (condition) {
      if (kIsWeb)
        _pathAvatar = pathAvatar;
      else
        _saveImageAvatar(pathAvatar!).then((file) {
          if (file != null)
            _pathAvatar = file.path;
          else
            _pathAvatar = pathAvatar;
        });
      notifyListeners();
    }
  }

  ///URL da imágem do avatar do usuário.
  String? get urlAvatar => _urlAvatar;

  ///URL da imágem do avatar do usuário.
  set urlAvatar(String? urlAvatar) {
    final condition = urlAvatar?.isNotEmpty ?? true;
    assert(condition);
    if (condition) {
      _urlAvatar = urlAvatar;
      notifyListeners();
    }
  }

  ///Apenas para Android e IOS.
  ///Path do diretório do arquivos da imagem do avatar do usuário.
  static const _DIR_AVATAR =
      LocalStorageRepository.DIR_PROFILE_PHOTOS_RELATIVE_PATH;

  ///Apenas para Android e IOS.
  ///Salva o arquivo da imagem do avatar do usuário no diretório do aplicativo.
  ///[path] é o path da origem do arquivo.
  Future<File?> _saveImageAvatar(String path) async {
    if (kIsWeb)
      throw MyException(
          "Salvar localmente a imagem do usúário não está disponível na verção web.");
    else {
      final newRelativePath =
          _DIR_AVATAR + _AVATAR_IMAGE_NAME + File(path).extension();
      _deleteImageAvatar();
      return LocalStorageRepository.copyFile(
        path: path,
        newRelativePath: newRelativePath,
      );
    }
  }

  ///Apenas para Android e IOS.
  ///Se existir, exclui o arquivo com a imágem usada no avatar.
  ///Retorna, assincronamente, `false` se o arquivo não for encontrado ou se ocorrer um erro.
  Future<bool> _deleteImageAvatar() async {
    if (kIsWeb)
      throw MyException(
          "Deletar localmente a imagem do usúário não está disponível na verção web.");
    else {
      final images = await LocalStorageRepository.find(
          relativePath: _DIR_AVATAR + _AVATAR_IMAGE_NAME + ".*");
      return LocalStorageRepository.delete(fileList: images);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[NOME] = this._name;
    data[EMAIL] = this._email;
    data[PATH_AVATAR] = this._pathAvatar;
    data[URL_AVATAR] = this._urlAvatar;
    return data;
  }

  @override
  String toString() {
    return '_UserAppBase(_name: $_name, _email: $_email, _pathAvatar: $_pathAvatar, _urlAvatar: $_urlAvatar)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is _UserAppBase &&
        o._name == _name &&
        o._email == _email &&
        o._pathAvatar == _pathAvatar &&
        o._urlAvatar == _urlAvatar;
  }

  @override
  int get hashCode {
    return _name.hashCode ^
        _email.hashCode ^
        _pathAvatar.hashCode ^
        _urlAvatar.hashCode;
  }
}

import 'dart:async';
import 'dart:io';

import 'package:file_utils/file_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../extensions.dart';
import '../models/exceptions/my_exception.dart';

///Gerencia as operações com o armazenamento local.
///Não disponível para a versão web.
abstract class LocalStorageRepository {
  static get _className => "LocalStorageRepository";

  ///O nome do diretório de mídias.
  static const DIR_MEDIA = "Media";

  ///O path do diretório de mídias relativo a [appDocDir].
  static const DIR_MEDIA_RELATIVE_PATH = DIR_MEDIA + "/";

  ///O nome do diretório de fotos de perfil.
  static const DIR_PROFILE_PHOTOS = "Profile Photos";

  ///O path do diretório de fotos de perfil relativo a [appDocDir].
  static const DIR_PROFILE_PHOTOS_RELATIVE_PATH =
      DIR_MEDIA + "/" + DIR_PROFILE_PHOTOS + "/";

  ///No Android: Retorna assincronamente o diretório reservado aos arquivos do aplicativo no armazenamento local.
  ///Se não for possível, fáz o mesmo que para o IOS.
  ///No IOS: Retorna assincronamente o diretório onde o aplicativo pode colocar dados gerados pelo usuário ou que não
  ///podem ser recriados pelo aplicativo.
  static Future<Directory> get appDocDir async {
    if (kIsWeb)
      throw MyExceptionNoWebSupport(
        originClass: _className,
        originField: "get appDocDir",
      );

    if (Platform.isAndroid)
      return (await getExternalStorageDirectory()) ??
          await getApplicationDocumentsDirectory();
    else
      return getApplicationDocumentsDirectory();
  }

  ///Retorna assincronamente o path do diretório reservado ao aplicativo.
  static Future<String> get appDocDirPath async {
    if (kIsWeb)
      throw MyExceptionNoWebSupport(
        originClass: _className,
        originField: "get appDocDirPath",
      );

    return (await appDocDir).path;
  }

  ///Retorna o path completo para [relativePath].
  static Future<String> getFullPath(String relativePath,
      {FutureOr<String>? parent}) async {
    assert(relativePath.isNotEmpty);

    if (kIsWeb)
      throw MyExceptionNoWebSupport(
        originClass: _className,
        originField: "getFullPath()",
      );

    if (relativePath.isEmpty)
      throw MyException(
        "Path relativo não especificado.",
        originClass: _className,
        originField: "getFullPath()",
        causeError: "[relativePath] não pode ser uma String vazia.",
      );

    parent ??= appDocDirPath;
    final pathParent = await parent;
    if (pathParent.isEmpty)
      throw MyException(
        "O diretório pai não pode ser determinado.",
        originClass: _className,
        originField: "getFullPath()",
        causeError: "[parent] não pode completar com uma String vazia.",
      );

    //Caso exista, remover "/" do início de `relativePath`.
    if (relativePath.substring(0, 0) == "/")
      relativePath = relativePath.substring(1);
    return "$pathParent/$relativePath";
  }

  ///Retorna assincronamente o diretório de fotos de perfil do aplicativo.
  static Future<Directory> get profilePhotos async {
    if (kIsWeb)
      throw MyExceptionNoWebSupport(
        originClass: _className,
        originField: "get profilePhotos",
      );

    return Directory(await getFullPath(DIR_PROFILE_PHOTOS_RELATIVE_PATH));
  }

  ///Retorna assincronamente uma instância de [File] em [relativePath] relativo a [appDocDir].
  static Future<File> getFile(String relativePath) async {
    assert(relativePath.isNotEmpty);
    if (relativePath.isEmpty)
      throw MyExceptionNoWebSupport(
        originClass: _className,
        originField: "getFile()",
        causeError: "[relativePath] não pode ser uma String vazia.",
      );

    return File(await getFullPath(relativePath));
  }

  ///Copia o arquivo em [path] ou [relativePath] para [newPath] ou [newRelativePath] e retorna a nova cópia.
  ///[path] é o path absoluto do arquivo a ser copiado.
  ///[relativePath] é o path relativo a [appDocDir] do arquivo a ser copiado.
  ///[newPath] é o path absoluto da cópia do arquivo.
  ///[newRelativePath] é o path relativo a [appDocDir] da cópia do arquivo.
  ///Se existir um arquivo no path especificado, esse arquivo será substituído se [replace] for `true`. Se [replace] for
  ///`false` será retornado `null`.
  ///Será retornado `null` caso ocorra qualquer erro no processo de cópia.
  static Future<File?> copyFile({
    FutureOr<String>? path,
    String? relativePath,
    FutureOr<String>? newPath,
    String? newRelativePath,
    bool replace = true,
  }) async {
    String? _path = await path;
    String? _newPath = await newPath;

    if (_path != null && _path.isEmpty) _path = null;
    if (relativePath != null && relativePath.isEmpty) relativePath = null;
    if (_newPath != null && _newPath.isEmpty) _newPath = null;
    if (newRelativePath != null && newRelativePath.isEmpty)
      newRelativePath = null;

    final validation1 = (_path == null) != /* significa um XOR */
        (relativePath == null);
    final validation2 = (_newPath == null) != /* significa um XOR */
        (newRelativePath == null);

    assert(validation1);
    assert(validation2);

    if (kIsWeb)
      throw MyExceptionNoWebSupport(
        originClass: _className,
        originField: "copyFile()",
      );

    if (validation1 && validation2) {
      _path ??= await getFullPath(relativePath!);
      _newPath ??= await getFullPath(newRelativePath!);
      final file = File(_path);

      if (file.existsSync() && !replace) return null;

      try {
        await File(_newPath).create(recursive: true);
        final newFile = file.copy(_newPath);
        return newFile;
      } catch (_) {
        return null;
      }
    } else
      return null;
  }

  ///Localiza arquivos e diretórios com base em [path] ou [relativePth].
  ///[path] é o path absoluto para a busca.
  ///[relativePath] é o path relativo a [appDocDir] para a busca.
  ///Há suporte para padrões com os caracteres curingas "*" e "?" que representam, respectivamente, uma sequência de
  ///caracteres e um único caracter.
  static Future<FileList> find({
    FutureOr<String>? path,
    String? relativePath,
  }) async {
    String? _path = await path;

    if (_path != null && _path.isEmpty) _path = null;
    if (relativePath != null && relativePath.isEmpty) relativePath = null;

    final validation =
        (_path == null) != /* significa um XOR */ (relativePath == null);

    assert(validation);

    if (kIsWeb)
      throw MyExceptionNoWebSupport(
        originClass: _className,
        originField: "find()",
      );

    if (validation) {
      _path ??= await getFullPath(relativePath!);
      return FileUtils.glob(_path) as FutureOr<FileList>;
    } else
      throw MyException(
        "Não foi possível determinar o path.",
        originClass: _className,
        originField: "find()",
        fieldDetails:
            "(await path) retorna ${_path.toString()}, relativePath retorna ${relativePath.toString()}",
        causeError: "A condição para os parâmetros foi violada.",
      );
  }

  ///Remove o(s) arquivo(s) e diretório(s) especificado(s) em [path], [relativePth] ou [fileList] e retorna `true`
  ///se a operação for bem-sucedida; caso contrário, `false`.
  ///Apenas um desses parâmetros deve ser fornecido.
  ///[path] é o path absoluto do arquivo a ser deletado.
  ///[relativePath] é o path relativo a [appDocDir] do arquivo a ser deletado.
  ///[fileList] é a lista do(s) arquivo(s) e diretório(s) a ser(em) deletado(s).
  ///Por padrão, ele não remove diretórios.
  ///Se [directory] for definido como `true`, remove os diretórios se estiverem vazios.
  ///Se [force] for definido como `true`, ignora arquivos inexistentes.
  ///Se [recursive] for definido como `true`, remove os diretórios e seus conteúdos recursivamente.
  static Future<bool> delete({
    FutureOr<String>? path,
    String? relativePath,
    List<String>? fileList,
    bool directory = false,
    bool force = false,
    bool recursive = false,
  }) async {
    if (kIsWeb)
      throw MyExceptionNoWebSupport(
        originClass: _className,
        originField: "delete()",
      );

    String? _path = await path;
    if (fileList != null && fileList.isEmpty) fileList = null;
    if (_path != null && _path.isEmpty) _path = null;
    if (relativePath != null && relativePath.isEmpty) relativePath = null;
    final validation = (_path != null)
        .xor(others: [(relativePath != null), (fileList != null)]);

    if (validation) {
      fileList ??= <String>[];
      if (_path != null) fileList.add(_path);
      if (relativePath != null) fileList.add(await getFullPath(relativePath));
      final result = _rm(fileList,
          directory: directory, force: force, recursive: recursive);
      return result;
    } else
      return false;
  }

  ///Remove o(s) arquivo(s) e diretório(s) especificado(s) em [paths] e retorna `true` se a operação for bem-sucedida;
  ///caso contrário, `false`.
  ///Por padrão, ele não remove diretórios.
  ///Se [directory] for definido como `true`, remove os diretórios se estiverem vazios.
  ///Se [force] for definido como `true`, ignora arquivos inexistentes e não aborta se ocorrer algum erro.
  ///Se [recursive] for definido como `true`, remove os diretórios e seus conteúdos recursivamente.
  ///Adaptado de [FileUtils.rm(files)].
  static bool _rm(
    List<String> paths, {
    bool directory = false,
    bool force = false,
    bool recursive = false,
  }) {
    if (kIsWeb)
      throw MyExceptionNoWebSupport(
        originClass: _className,
        originField: "_rm()",
      );

    if (paths.isEmpty) {
      return false;
    }

    var result = true;
    for (final name in paths) {
      if (name.isEmpty) {
        if (!force) {
          return false;
        }
        continue;
      }

      FileSystemEntity? entity;
      var isDirectory = false;
      if (FileUtils.testfile(name, 'link') ?? false) {
        entity = Link(name);
      } else if (FileUtils.testfile(name, 'file') ?? false) {
        entity = File(name);
      } else if (FileUtils.testfile(name, 'directory') ?? false) {
        entity = Directory(name);
        isDirectory = true;
      }

      if (entity == null) {
        if (!force) {
          return false;
        }
        continue;
      } else {
        if (isDirectory) {
          if (recursive) {
            try {
              entity.deleteSync(recursive: recursive);
            } catch (_) {
              if (!force) {
                return false;
              }
              continue;
            }
          } else if (directory) {
            result = FileUtils.rmdir([entity.path], parents: true);
          } else {
            if (!force) {
              return false;
            }
            continue;
          }
        } else {
          try {
            entity.deleteSync();
          } catch (_) {
            if (!force) {
              return false;
            }
            continue;
          }
        }
      }
    }

    return result;
  }
}

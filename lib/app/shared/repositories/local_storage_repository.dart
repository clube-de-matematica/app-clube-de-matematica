import 'dart:io';

import 'package:path_provider/path_provider.dart';

///Gerencia as operações com o armazenamento local.
abstract class LocalStorageRepository {
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
  ///No IOS: Retorna assincronamente o diretório onde o aplicativo pode colocar dados gerados pelo usuário ou que não
  ///podem ser recriados pelo aplicativo.
  static Future<Directory> get appDocDir => Platform.isAndroid
      ? getExternalStorageDirectory()
      : getApplicationDocumentsDirectory();

  ///Retorna assincronamente o path do diretório reservado ao aplicativo.
  static Future<String> get appDocDirPath async => (await appDocDir).path;

  ///Retorna assincronamente o diretório de fotos de perfil do aplicativo.
  static Future<Directory> get profilePhotos async =>
      Directory((await appDocDir).path + DIR_PROFILE_PHOTOS_RELATIVE_PATH);

  ///Retorna assincronamente uma instância de [File] em [relativePath] relativo a [appDocDir].
  static Future<File> getFile(String relativePath) async {
    assert(relativePath != null && relativePath.isNotEmpty);
    //Caso exista, remover "/" do início de `relativePath`.
    if (relativePath.substring(0, 0) == "/")
      relativePath = relativePath.substring(1);
    final path = (await appDocDir).path;
    final file = File('$path/$relativePath');
    return file;
  }

  ///Copia o arquivo em [path] ou [relativePath] para [newPath] ou [newRelativePath] e retorna a nova cópia.
  ///[path] é o path absoluto do arquivo a ser copiado.
  ///[relativePath] é o path relativo a [appDocDir] do arquivo a ser copiado.
  ///[newPath] é o path absoluto da cópia do arquivo.
  ///[newRelativePath] é o path relativo a [appDocDir] da cópia do arquivo.
  ///Se existir um arquivo no path especificado, esse arquivo será substituído se [replace] for `true`. Se [replace] for
  ///`false` será retornado `null`.
  ///Será retornado `null` caso ocorra qualquer erro no processo de cópia.
  static Future<File> copyFile({
    String path,
    String relativePath,
    String newPath,
    String newRelativePath,
    bool replace = true,
  }) async {
    assert((path != null && path.isNotEmpty) !=
        (relativePath != null && relativePath.isNotEmpty));
    assert((newPath != null && newPath.isNotEmpty) !=
        (newRelativePath != null && newRelativePath.isNotEmpty));
    final _path = path ??
        (await appDocDirPath) +
            (relativePath.substring(0, 0) == "/" ? "" : "/") +
            relativePath;
    final _newPath = newPath ??
        (await appDocDirPath) +
            (newRelativePath.substring(0, 0) == "/" ? "" : "/") +
            newRelativePath;
    final file = File(_path);

    if (file.existsSync() && !replace) return null;
    //try {
    await File(_newPath).create(recursive: true);
    final newFile = file.copy(_newPath);
    return newFile;
    /* } catch (_) {
      return null;
    } */
  }
}

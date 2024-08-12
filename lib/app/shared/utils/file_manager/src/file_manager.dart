part of '../file_manager.dart';

abstract class FileManager {
  static String get _className => "FileManager";

  /// Se [path] corresponde a [FileSystemEntityType.directory], [FileSystemEntityType.file]
  /// ou [FileSystemEntityType.link], retorna o [FileSystemEntity] correspondente.
  ///
  /// Nos demais casos, retorna `null`.
  /// 
  /// Se [path] não corresponder a um FileSystemEntity existente, retorna `null`.
  /// 
  /// {@template file_manager.FileManager.unsuported_globs}
  /// **ATENÇÃO**: não suporta padrões glob. Neste caso, use [FileManager.glob] para localiazar o [path] correspondente.
  /// {@endtemplate}
  static FileSystemEntity? entity(String path) {
    final entityType = FileStat.statSync(path).type;
    switch (entityType) {
      case FileSystemEntityType.directory:
        return Directory(path);
      case FileSystemEntityType.file:
        return File(path);
      case FileSystemEntityType.link:
        return Link(path);
      case FileSystemEntityType.notFound:
        break;
      case FileSystemEntityType.pipe:
        break;
      case FileSystemEntityType.unixDomainSock:
        break;
    }
    return null;
  }

  /// Cria um novo arquivo.
  /// 
  /// {@macro file_manager.FileManager.unsuported_globs}
  static Future<File?> createFile(
    String path, {
    bool recursive = false,
  }) async {
    final file = File(path);
    try {
      return await file.create(recursive: recursive);
    } catch (e) {
      throw MyException(
        "Falha ao criar arquivo",
        originClass: _className,
        originField: "createFile()",
        error: e,
        fieldDetails: "path == $path; recursive == $recursive",
      );
    }
  }

  /// Cria um novo diretório.
  /// 
  /// {@macro file_manager.FileManager.unsuported_globs}
  static Future<Directory?> createDirectory(
    String path, {
    bool recursive = false,
  }) async {
    final dir = Directory(path);
    try {
      return await dir.create(recursive: recursive);
    } catch (e) {
      throw MyException(
        "Falha ao criar diretório",
        originClass: _className,
        originField: "createDirectory()",
        error: e,
        fieldDetails: "path == $path; recursive == $recursive",
      );
    }
  }

  /// Lê o conteúdo de um arquivo.
  /// 
  /// {@macro file_manager.FileManager.unsuported_globs}
  static Future<String?> readFile(String path) async {
    final entity = FileManager.entity(path);
    if (entity is File) {
      try {
        return await entity.readAsString();
      } catch (e) {
        throw MyException(
          "Falha ao ler arquivo",
          originClass: _className,
          originField: "readFile()",
          error: e,
          fieldDetails: "path == $path",
        );
      }
    } else {
      return null;
    }
  }

  /// Grava [content] no arquivo correspondente a [path].
  ///
  /// Abre o arquivo, grava a string na codificação fornecida e fecha o arquivo. Retorna um `Future<File?>` que é concluído com o objeto [File] gravado assim que toda a operação for concluída. Retorna `null` se ocorrer algum erro na operação.
  ///
  /// Cria o arquivo para gravação e trunca o arquivo se ele já existir.
  /// 
  /// {@macro file_manager.FileManager.unsuported_globs}
  static Future<File?> writeFile(String path, String content) async {
    final file = File(path);
    try {
      return await file.writeAsString(content);
    } catch (e) {
      throw MyException(
        "Falha ao escrever dados em um arquivo",
        originClass: _className,
        originField: "writeFile()",
        error: e,
        fieldDetails: "path == $path",
      );
    }
  }

  /// Exclui, assincronamente, o arquivo ou diretório correspondente a [path]
  /// e retorna `true` se a operação for bem sucedida.
  ///
  /// Os detalhes exatos variam de acordo com a [FileSystemEntity]:
  ///
  /// * [Directory.delete]
  /// * [File.delete]
  /// * [Link.delete].
  /// 
  /// {@macro file_manager.FileManager.unsuported_globs}
  static Future<bool> delete(String path, {bool recursive = false}) async {
    final entity = FileManager.entity(path);
    if (entity == null) {
      return false;
    }
    try {
      await entity.delete(recursive: recursive);
      return true;
    } catch (e) {
      assert(Debug.print(e));
      return false;
    }
  }

  /// Verifica se um arquivo ou diretório existe.
  /// 
  /// {@macro file_manager.FileManager.unsuported_globs}
  static Future<bool> exists(String path) async {
    final entity = FileManager.entity(path);
    if (entity == null) {
      return false;
    } else {
      return entity.exists();
    }
  }

  /// Lista os arquivos e subdiretórios de um diretório, suportando padrões glob.
  ///
  /// Se [globPattern] for relativo, [root] deve ser fornecido.
  static Future<List<FileSystemEntity>> glob({
    required String? root,
    required String globPattern,
    bool recursive = false,
  }) async {
    final condition = () {
      if (pathos.isRelative(globPattern)) {
        return root != null && !pathos.isRelative(root);
      } else {
        return true;
      }
    }();
    assert(condition);

    if (!condition) {
      throw MyException(
        'Diretório raiz inválido',
        originClass: _className,
        originField: "glob()",
        fieldDetails: "root == $root; globPattern == $globPattern",
      );
    }
    final glob = Glob(
      globPattern,
      recursive: recursive,
    );
    return glob.listSync(root: root);
  }
}

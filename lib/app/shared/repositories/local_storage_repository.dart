import 'dart:io';
import 'package:path_provider/path_provider.dart';

///Gerencia as operações com o armazenamento local.
abstract class LocalStorageRepository {
  static Future<Directory> get appDocDir => getApplicationDocumentsDirectory();

  static Future<String> _getPath(Future<Directory> fDir) async {
    return (await fDir).path;
  }

  //static bool fileExist(String nome);

  static Future<File> getFile(String nome) async {
    final path = await _getPath(appDocDir);
    final file = File('$path/$nome');
    return file;
  }
}
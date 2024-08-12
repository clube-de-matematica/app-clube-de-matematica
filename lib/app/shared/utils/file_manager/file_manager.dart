library file_manager;

import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart' as pathos;

import '../../models/debug.dart';
import '../../models/exceptions/my_exception.dart';

part 'src/file_manager.dart';

/// Uma lista de strings que são caminhos para diretórios, arquivos ou links
typedef PathList = List<String>;

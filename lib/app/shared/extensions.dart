import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as pathPackage;

import 'models/exceptions/my_exception.dart';

///Adiciona novos métodos à classe [TextStyle].
extension MyExtensionTextStyle on TextStyle {
  ///Retorna um novo [TextStyle] com base nesta instância, com a fonte em negrito.
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  ///Retorna um novo [TextStyle] com base nesta instância, com `FontWeight.normal`.
  TextStyle get normal => copyWith(fontWeight: FontWeight.normal);

  ///Retorna um novo [TextStyle] com base nesta instância, com o espaçamento entre caracteres
  ///que será usado nos botões.
  TextStyle get letterSpacingForButton => copyWith(letterSpacing: 1.2);
}

///Adiciona novos métodos à classe [File].
extension MyExtensionFile on File {
  ///Retorna o nome do arquivo, incluindo a extensão.
  String get name => pathPackage.basename(this.path);

  ///Retorna a extensão do arquivo. É uma substring de [name] que inicia no [level]ésimo ponto antes do final de [name],
  ///desconsiderando pontos consecutivos e pontos no início ou no final de [name].
  ///     `File("/dir/.file.ext1.ext2").getExtension(level: 2) => ".ext1.ext2"`
  ///Se o número de pontos em [name] for menor que [level], desconsiderando pontos consecutivos e pontos no início ou no
  ///final de [name], retorna tudo a partir do primeiro ponto considerado.
  ///     `File("/dir/.file..ext").getExtension(level: 2) => ".ext"`
  ///Retorna uma `""` se o arquivo não tiver extensão.
  ///[level] deve ser maior que zero.
  String extension({int level = 1}) {
    assert(level > 0);

    if (level <= 0)
      throw MyException(
          "MyExtensionFile: extension(): Erro: level deve ser maior que zero.");
    return pathPackage.extension(this.path, level);
  }
}

///Extensão para a class `bool`.
extension MyExtensionBool on bool {
  ///Converte para inteiro.
  ///Retorna 1 se `this` for `true` e 0 se for `false`.
  int toInt() => this ? 1 : 0;

  ///Retorna o valor da disjunção exclusiva entre `this` e [other] ou entre `this` e os valores de [others].
  bool xor({bool? other, List<bool>? others}) {
    final validation = ((other !=
        null) != /*Significa um XOR*/ (others != null && others.isNotEmpty));
    assert(validation);

    others ??= <bool>[];
    if (other != null) others.add(other);
    if (others.isNotEmpty) {
      final contTrue = others.where((element) => element).length;
      return (this && contTrue == 0) || (!this && contTrue == 1);
    } else
      throw MyException(
          "MyExtensionBool: xor(): Erro: Algum dos valores não pode ser testado.");
  }
}

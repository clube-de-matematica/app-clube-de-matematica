import 'dart:convert';

import 'package:flutter/painting.dart';

import '../strings_db.dart';

abstract class DbRemoto {
  static String codificarData(DateTime data) {
    return data.toUtc().toIso8601String();
  }

  static DateTime? decodificarData(String iso8601String) {
    // As datas salvas no Supabase estão sem fuso horário, no entanto,
    // estão em UTC. A rotina a seguir inclui o marcador do fuso horário UTC.
    if (iso8601String.length == 23) iso8601String += 'Z';
    try {
      return DateTime.parse(iso8601String).toUtc();
    } on FormatException catch (_) {
      return null;
    }
  }

  static List<int> codificarHierarquia(DataHierarquia hierarquia) => hierarquia;

  static DataHierarquia decodificarHierarquia(List<int> hierarquia) =>
      hierarquia;

  List<DataImagem> decodificarImagensEnunciado(
    List<Map<String, dynamic>> imagensEnunciado, {
    String? nome,
  }) =>
      imagensEnunciado;

  static String codificarCapaClube(Color capa) => capa.value.toString();

  static Color? decodificarCapaClube(String capa) {
    try {
      return Color(int.parse(capa));
    } /* on FormatException */ catch (_) {
      return null;
    }
  }
}

abstract class DbLocal {
  static int codificarData(DateTime data) {
    return data.toUtc().millisecondsSinceEpoch;
  }

  static DateTime decodificarData(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch,
      isUtc: true,
    ).toUtc();
  }

  static String codificarLista(List lista) => jsonEncode(lista);

  static List<T>? decodificarLista<T>(String jsonArray) {
    final resultado = jsonDecode(jsonArray);
    return resultado is List ? resultado.cast<T>() : null;
  }

  static String codificarHierarquia(DataHierarquia hierarquia) =>
      jsonEncode(hierarquia);

  static DataHierarquia? decodificarHierarquia(String hierarquia) {
    final resultado = jsonDecode(hierarquia);
    return resultado is List ? resultado.cast() : null;
  }

  static String codificarEnunciado(List<String> enunciado) =>
      jsonEncode(enunciado);

  static List<String>? decodificarEnunciado(String enunciado) {
    final resultado = jsonDecode(enunciado);
    return resultado is List ? resultado.cast() : null;
  }

  static String codificarImagensEnunciado(List<DataImagem> imagens) {
    return jsonEncode(imagens);
  }

  static List<DataImagem>? decodificarImagensEnunciado(String imagens) {
    final resultado = jsonDecode(imagens);
    return (resultado is List?) ? resultado?.cast() : null;
  }

  static List<DataUsuarioClube>? decodificarUsuariosClube(String usuarios) {
    final resultado = jsonDecode(usuarios);
    return (resultado is List?) ? resultado?.cast() : null;
  }

  static int codificarBooleano(bool valor) => valor ? 1 : 0;

  static bool decodificarBooleano(int valor) => valor == 1;

  static String codificarCapaClube(Color capa) => capa.value.toString();

  static Color? decodificarCapaClube(String capa) {
    try {
      return Color(int.parse(capa));
    } /* on FormatException */ catch (_) {
      return null;
    }
  }
}

import 'dart:convert';

import 'package:clubedematematica/app/shared/utils/strings_db.dart';

import '../../../modules/quiz/shared/models/imagem_questao_model.dart';

abstract class DbRemoto {
  static String codificarData(DateTime data) {
    return data.toUtc().toIso8601String();
  }

  static DateTime decodificarData(String iso8601String) {
    return DateTime.parse(iso8601String).toUtc();
  }

  static List<int> codificarHierarquia(DataHierarquia hierarquia) => hierarquia;

  static DataHierarquia decodificarHierarquia(List<int> hierarquia) =>
      hierarquia;

  List<DataImagem> decodificarImagensEnunciado(
    List<Map<String, dynamic>> imagensEnunciado, {
    String? nome,
  }) =>
      imagensEnunciado;
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
}

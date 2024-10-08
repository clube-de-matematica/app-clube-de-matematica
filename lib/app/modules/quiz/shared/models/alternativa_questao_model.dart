import 'dart:convert';

import '../../../../shared/models/exceptions/my_exception.dart';
import '../../../../shared/utils/strings_db.dart';
import 'imagem_questao_model.dart';

/// Tipos de alternativas.
enum TypeAlternativa {
  texto,
  imagem,
}

extension ExtensionTypeAlternativa on TypeAlternativa {
  /// Retorna o ID correspondente ao tipo no banco de dados.
  int get id {
    switch (this) {
      case TypeAlternativa.texto:
        return 0;
      case TypeAlternativa.imagem:
        return 1;
    }
  }
}

/// Contém as propriedades de uma alternativa do questao.
class Alternativa {
  final int idQuestao;
  final int sequencial;
  final TypeAlternativa tipo;
  final dynamic conteudo;

  Alternativa({
    required this.idQuestao,
    required this.sequencial,
    required this.tipo,
    required this.conteudo,
  }) : assert(conteudo is String || conteudo is ImagemQuestao);

  /// Retorna uma Instância de [Alternativa] a partir de um `Map<String, dynamic>`.
  factory Alternativa.fromJson(DataAlternativa json) {
    final idQuestao = json[DbConst.kDbDataAlternativaKeyIdQuestao] as int;
    final sequencial = json[DbConst.kDbDataAlternativaKeySequencial] as int;
    final dynamic conteudo;
    if (json[DbConst.kDbDataAlternativaKeyTipo] as int ==
        DbConst.kDbDataAlternativaKeyTipoValTexto) {
      conteudo = json[DbConst.kDbDataAlternativaKeyConteudo];
    } else {
      final dataImagem =
          jsonDecode(json[DbConst.kDbDataAlternativaKeyConteudo]) as DataImagem;
      dataImagem[ImagemQuestao.kKeyName] =
          '${idQuestao}_alternativa_$sequencial.png';
      conteudo = ImagemQuestao.fromMap(dataImagem);
    }

    return Alternativa(
      idQuestao: idQuestao,
      sequencial: sequencial,
      tipo:
          parseTypeAlternativa(json[DbConst.kDbDataAlternativaKeyTipo] as int),
      conteudo: conteudo,
    );
  }

  /// Verdadeiro se esta alternativa corresponder a [gabarito].
  bool verificar(int gabarito) => gabarito == sequencial;

  /// Retorna um [TypeAlternativa] com base em [tipo].
  static TypeAlternativa parseTypeAlternativa(int tipo) {
    if (tipo == DbConst.kDbDataAlternativaKeyTipoValTexto) {
      return TypeAlternativa.texto;
    }
    if (tipo == DbConst.kDbDataAlternativaKeyTipoValImagem) {
      return TypeAlternativa.imagem;
    }
    throw MyException(
      "Tipo inválido!",
      originClass: "Alternativa",
      originField: "parseTypeAlternativa()",
      fieldDetails: "tipo == $tipo",
    );
  }

  /// Retorna `true` se a alternativa for do tipo "texto".
  bool get isTipoTexto => tipo == TypeAlternativa.texto;

  /// Retorna `true` se a alternativa for do tipo "imagem".
  bool get isTipoImagem => tipo == TypeAlternativa.imagem;

  /// Retorna o identificador da alternativa ("A", "B", "C", "D" ou "E").
  String get identificador => 'ABCDE'.substring(sequencial, sequencial + 1);

  /// Retorna um json com os dados da alternativa.
  Map<String, dynamic> toJson() {
    final DataAlternativa data = DataAlternativa();
    data[DbConst.kDbDataAlternativaKeyIdQuestao] = idQuestao;
    data[DbConst.kDbDataAlternativaKeySequencial] = sequencial;
    data[DbConst.kDbDataAlternativaKeyTipo] = tipo.id;
    data[DbConst.kDbDataAlternativaKeyConteudo] = isTipoTexto
        ? conteudo
        : jsonEncode((conteudo as ImagemQuestao).toMap());
    return data;
  }
}

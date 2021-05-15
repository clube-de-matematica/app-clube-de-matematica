import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../shared/theme/tema.dart';

///Cria um [Text] a partir das partes fornecidas no argumento [blocosDeTexto].
class QuizTextFromBlocs extends Text {
  QuizTextFromBlocs({
    Key? key,
    required this.blocosDeTexto,
    required this.alinhamento,
  }) : super.rich(
          TextSpan(
              children: blocosDeTexto,
              style: Modular.get<MeuTema>().temaClaro.textTheme.bodyText1),
          textAlign: alinhamento,
          key: key,
        );

  ///As partes usadas para criar o [Text].
  final List<InlineSpan> blocosDeTexto;

  ///O alinhamento do texto.
  final TextAlign alinhamento;
}

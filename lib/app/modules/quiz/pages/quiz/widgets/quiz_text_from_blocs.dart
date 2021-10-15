import 'package:flutter/material.dart';

import '../../../../../shared/theme/appTheme.dart';

///Cria um [Text] a partir das partes fornecidas no argumento [blocosDeTexto].
class QuizTextFromBlocs extends Text {
  QuizTextFromBlocs({
    Key? key,
    required this.blocosDeTexto,
    required this.alinhamento,
  }) : super.rich(
          TextSpan(
              children: blocosDeTexto,
              style: AppTheme.instance.temaClaro.textTheme.bodyText1),
          textAlign: alinhamento,
          key: key,
        );

  ///As partes usadas para criar o [Text].
  final List<InlineSpan> blocosDeTexto;

  ///O alinhamento do texto.
  final TextAlign alinhamento;
}

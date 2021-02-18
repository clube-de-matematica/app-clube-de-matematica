import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../shared/theme/tema.dart';

///Cria um [Text] a partir das partes fornecidas no argumento [blocosDeTexto].
class QuizTextFromBlocs extends StatelessWidget {
  const QuizTextFromBlocs(
    this.blocosDeTexto,
    this.alinhamento,
    {Key key}
  ) : super(key: key);

  ///As partes usadas para criar o [Text].
  final List<InlineSpan> blocosDeTexto;

  ///O alinhamento do texto.
  final TextAlign alinhamento;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: blocosDeTexto,
        style: Modular.get<MeuTema>().temaClaro.textTheme.bodyText1
      ),
      textAlign: alinhamento,
    );
  }
}

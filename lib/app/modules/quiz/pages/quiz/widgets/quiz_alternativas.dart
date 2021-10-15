import 'package:clubedematematica/app/modules/quiz/shared/models/imagem_questao_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../shared/theme/appTheme.dart';
import '../../../shared/models/alternativa_questao_model.dart';
import '../quiz_controller.dart';
import 'katex_flutter.dart';
import 'quiz_componente_imagem.dart';
import 'quiz_text_from_blocs.dart';

///Alternativas de resposta do item.
class QuizAlternativas extends StatelessWidget {
  QuizAlternativas(this.controller, {Key? key}) : super(key: key);

  final QuizController controller;

  ThemeData get tema => AppTheme.instance.temaClaro;
  TextStyle? get textStyle => tema.textTheme.bodyText1;

  @override
  Widget build(_) {
    return Observer(builder: (_) {
      final List<Widget> lista = <Widget>[];
      controller.questao.alternativas.forEach((alternativa) {
        lista.add(GestureDetector(
          onTap: () => controller.onTapAlternativa(alternativa),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: controller.alternativaSelecionada == alternativa.sequencial
                  ? tema.colorScheme.background.withOpacity(0.5)
                  : tema.colorScheme.onSurface.withOpacity(0.07),
              borderRadius: const BorderRadius.all(const Radius.circular(4)),
            ),
            //Estrutura do item.
            child: _gerarAlternatica(alternativa),
          ),
        ));
      });
      return Column(children: lista);
    });
  }

  ///Retorna o componente para uma alternativa de resposta.
  Row _gerarAlternatica(Alternativa alternativa) {
    return Row(
      children: <Widget>[
        //Estrutura do indicador do item.
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 15,
              backgroundColor: tema.scaffoldBackgroundColor,
              child: Text(alternativa.identificador, style: textStyle),
            ),
          ],
        ),
        //Estrutura do conteúdo da alternativa.
        Expanded(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Builder(builder: (_) {
                  //Caso o conteúdo da alternativa seja texto.
                  if (alternativa.isTipoTexto) {
                    KaTeX tex = KaTeX(
                      laTeXCode: alternativa.conteudo as String,
                      /* laTeXCode: Text(alternativa.conteudo as String,
                          textAlign: TextAlign.justify, style: textStyle), */
                    );
                    return QuizTextFromBlocs(
                      blocosDeTexto: tex.blocosDoTexto,
                      alinhamento: tex.temLaTex == true
                          ? TextAlign.start
                          : TextAlign.justify,
                    );
                  }
                  //Caso o conteúdo da alternativa seja imágem.
                  else if (alternativa.isTipoImagem) {
                    return QuizComponenteImagem(alternativa.conteudo as ImagemQuestao);
                  } else
                    return const SizedBox();
                }))
          ],
        )),
      ],
    );
  }
}

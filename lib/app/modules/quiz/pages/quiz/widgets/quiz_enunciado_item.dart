import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../shared/models/questao_model.dart';
import '../quiz_controller.dart';
import 'katex_flutter.dart';
import 'quiz_componente_imagem.dart';
import 'quiz_text_from_blocs.dart';

///Enunciado do item formatado com imágem e texto Latex, quando houver.
class EnunciadoItem extends StatelessWidget {
  const EnunciadoItem(
    this.controller, {
    Key? key,
  }) : super(key: key);

  final QuizController controller;

  Questao get item => controller.questao;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      if (controller.itensFiltrados.isEmpty)
        return const SizedBox();
      else {
        ///Lista para armazenar temporariamente as partes do enunciado que vão sendo montadas.
        List<Widget> lista = [];

        ///Lista com as partes do texto que ainda não foram montadas.
        List<InlineSpan> blocosDeTexto = [];

        ///Indica o índice da imágem na lista de imágens do enunciado.
        int contador = 0;

        ///Indica se o texto será justificado quando for montado.
        ///Será `true` se em `blocosDeTexto` não houver texto Latex
        ///nem imágem nas linhas do texto.
        TextAlign textAlign = TextAlign.justify;

        ///Percorre as partes do enunciado do item.
        item.enunciado.forEach((texto) {
          ///Verificar se `texto` corresponde ao identificador de imágem em nova linha.
          if (controller.isImageNewLine(texto)) {
            if (blocosDeTexto.isNotEmpty) {
              ///Montar as partes já percorridas pelo `forEach`.
              lista.add(QuizTextFromBlocs(
                blocosDeTexto: blocosDeTexto,
                alinhamento: textAlign,
              ));
              blocosDeTexto = [];
              textAlign = TextAlign.justify;
            }
            lista.add(

                ///Estrutura que conterá a imagem.
                Center(
                    child:
                        QuizComponenteImagem(item.imagensEnunciado[contador])));
            contador++;
          }

          ///Verificar se [texto] corresponde ao identificador de imágem em linha.
          else if (controller.isImageInLine(texto)) {
            textAlign = TextAlign.start;
            blocosDeTexto.add(

                ///Estrutura que conterá a imagem.
                WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Container(
                      //height: 24,
                      //margin: const EdgeInsets.only(top: 4, bottom: 4),
                      child:
                          QuizComponenteImagem(item.imagensEnunciado[contador]),
                    )));
            contador++;
          }

          ///Se `texto` não indicar um ponto de inserção de imágem cria-se um `Katex`
          ///com base em `texto`.
          ///`Katex` pesquisará em `texto` pelos marcadores de texto Latex "$" e "$$".
          else {
            final tex = KaTeX(laTeXCode: texto);
            if (tex.temLaTex == true) textAlign = TextAlign.start;
            blocosDeTexto.addAll(tex.blocosDoTexto);
          }
        });

        ///Fazer a montagem do restante das partes do texto que não foram montadas.
        if (blocosDeTexto.isNotEmpty)
          lista.add(QuizTextFromBlocs(
            blocosDeTexto: blocosDeTexto,
            alinhamento: textAlign,
          ));

        ///Retornar o enunciado completo.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lista,
        );
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../shared/widgets/myShimmer.dart';
import '../../../shared/models/imagem_questao_model.dart';

///Estrutura que conterá uma imagem do enunciado ou da alternativa.
class QuizComponenteImagem extends StatelessWidget {
  const QuizComponenteImagem(this.imagem, {Key? key}) : super(key: key);

  final ImagemQuestao imagem;

  @override
  Widget build(BuildContext context) {
    final placeHolder = MyShimmer(
      width: imagem.width,
      height: imagem.height,
    );
    return Observer(builder: (_) {
      //imagem.provider é observável.
      if (imagem.provider == null) {
        return placeHolder;
      } else {
        return Image(
          image: imagem.provider!,
          width: imagem.width,
          height: imagem.height,
          frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            } else {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: frame != null ? child : placeHolder,
              );
            }
          },
        );
      }

      /* 
        ProgressiveImage(
          placeholder: MemoryImage(kTransparentImage), 
          thumbnail: MemoryImage(kTransparentImage), 
          /* image: NetworkImage(
            "http;})s://firebasestorage.googleapis.com/v0/b/clube-de-matematica.appspot.com/o/questoes%2F2019pf1n1q1.png?alt=media&token=d67825b8-1c12-48e6-b4c3-f23bd5912055",
            scale: 0.99
          ),  */
          //image: FileImage(File("/data/user/0/com.sslourenco.clubedematematica/app_flutter/2019pf1n1q8.png")),
          image: item.imagensEnunciado[contador].provider ?? MemoryImage(kTransparentImage), 
          width: item.imagensEnunciado[contador].width, 
          height: item.imagensEnunciado[contador].height,
        ), 
        */
    });
  }
}

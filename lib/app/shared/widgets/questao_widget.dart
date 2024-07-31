import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../modules/quiz/shared/models/alternativa_questao_model.dart';
import '../../modules/quiz/shared/models/imagem_questao_model.dart';
import '../../modules/quiz/shared/models/questao_model.dart';
import '../theme/appTheme.dart';
import '../utils/strings_db.dart';
import 'appShimmer.dart';
import 'katex_flutter.dart';

/// Se [selecionavel] for `false`, [alterandoAlternativa] e [alternativaSelecionada]
/// serão ignorados.
class QuestaoWidget extends StatelessWidget {
  const QuestaoWidget({
    Key? key,
    required this.questao,
    this.selecionavel = true,
    this.alternativaSelecionada,
    this.alterandoAlternativa,
    this.verificar = false,
    this.barraOpcoes,
    this.rolavel = true,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  })  : assert(selecionavel || alterandoAlternativa == null),
        assert(!(verificar && selecionavel)),
        super(key: key);

  final Questao questao;

  /// Indica se as alternativas são selecionáveis.
  final bool selecionavel;

  /// O sequencial da alternativa selecionada.
  final int? alternativaSelecionada;

  /// {@template app.QuestaoWidget.verificar}
  /// Indica se a alternativa selecionada e o gabarito devem ser destacados.
  /// {@endtemplate}
  final bool verificar;

  /// Chamado quando a alternativa selecionada é modificada.
  final void Function(Alternativa?)? alterandoAlternativa;

  /// Um widget colocado acima do corpo da questão.
  final Widget? barraOpcoes;

  /// Se verdadeiro, o corpo da questão (não inclui [barraOpcoes]) será incluído em um
  /// [SingleChildScrollView].
  final bool rolavel;

  final EdgeInsetsGeometry padding;

  Widget _corpo() {
    return Column(
      children: [
        if (barraOpcoes != null) barraOpcoes!,
        if (barraOpcoes != null) Divider(height: 4.0),
        Container(
          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
          child: Column(children: [
            // Enunciado da questão.
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _Enunciado(questao),
            ),

            // Opções de resposta.
            _Alternativas(
              alternativas: questao.alternativas,
              alternativaSelecionada: alternativaSelecionada,
              alterando: alterandoAlternativa,
              selecionavel: selecionavel,
              verificar: verificar,
              gabarito: questao.gabarito,
            ),
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: !rolavel ? _corpo() : SingleChildScrollView(child: _corpo()),
    );
  }
}

/// Enunciado da questão formatado com imágem e texto Latex, quando houver.
class _Enunciado extends StatelessWidget {
  const _Enunciado(
    this.questao, {
    Key? key,
  }) : super(key: key);

  final Questao questao;

  @override
  Widget build(BuildContext context) {
    // Lista para armazenar temporariamente as partes do enunciado que vão sendo montadas.
    List<Widget> lista = [];

    // Lista com as partes do texto que ainda não foram montadas.
    List<InlineSpan> blocosDeTexto = [
      TextSpan(text: '(OBMEP ${questao.ano}) ')
    ];

    // Indica o índice da imágem na lista de imágens do enunciado.
    int contador = 0;

    // Indica se o texto será justificado quando for montado.
    // Será `true` se em `blocosDeTexto` não houver texto Latex
    // nem imágem nas linhas do texto.
    TextAlign textAlign = TextAlign.justify;

    // Percorre as partes do enunciado do item.
    questao.enunciado.forEach((texto) {
      // Verificar se `texto` corresponde ao identificador de imágem em nova linha.
      if (texto == DbConst.kDbStringImagemDestacada) {
        if (blocosDeTexto.isNotEmpty) {
          // Montar as partes já percorridas pelo `forEach`.
          lista.add(_Text(
            blocosDeTexto: blocosDeTexto,
            alinhamento: textAlign,
          ));
          blocosDeTexto = [];
          textAlign = TextAlign.justify;
        }
        lista.add(
          /// Estrutura que conterá a imagem.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: ImagemQuestaoWidget(questao.imagensEnunciado[contador]),
            ),
          ),
        );
        contador++;
      }

      // Verificar se [texto] corresponde ao identificador de imágem em linha.
      else if (texto == DbConst.kDbStringImagemNaoDestacada) {
        textAlign = TextAlign.start;
        blocosDeTexto.add(
          // Estrutura que conterá a imagem.
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              //height: 24,
              //margin: const EdgeInsets.only(top: 4, bottom: 4),
              child: ImagemQuestaoWidget(questao.imagensEnunciado[contador]),
            ),
          ),
        );
        contador++;
      }

      // Se `texto` não indicar um ponto de inserção de imágem cria-se um `Katex`
      // com base em `texto`.
      // `Katex` pesquisará em `texto` pelos marcadores de texto Latex "$" e "$$".
      else {
        final tex = KaTeX(laTeXCode: texto);
        if (tex.temLaTex == true) textAlign = TextAlign.start;
        blocosDeTexto.addAll(tex.blocosDoTexto);
      }
    });

    // Fazer a montagem do restante das partes do texto que não foram montadas.
    if (blocosDeTexto.isNotEmpty)
      lista.add(_Text(
        blocosDeTexto: blocosDeTexto,
        alinhamento: textAlign,
      ));

    // Retornar o enunciado completo.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lista,
    );
  }
}

/// Alternativas de resposta da questão.
/// Se [selecionavel] for falso, [alterando] e [alternativaSelecionada] serão ignorados.
class _Alternativas extends StatefulWidget {
  _Alternativas({
    Key? key,
    required this.alternativas,
    this.alterando,
    this.alternativaSelecionada,
    this.selecionavel = true,
    this.verificar = false,
    required this.gabarito,
  }) : super(key: key);

  final List<Alternativa> alternativas;

  /// Chamado quando a alternativa selecionada é modificada.
  final void Function(Alternativa? alternativa)? alterando;

  /// O sequencial da alternativa selecionada.
  final int? alternativaSelecionada;

  /// Indica se as alternativas são selecionáveis.
  final bool selecionavel;

  /// {@macro app.QuestaoWidget.verificar}
  final bool verificar;

  final int gabarito;

  @override
  State<_Alternativas> createState() => _AlternativasState();
}

class _AlternativasState extends State<_Alternativas> {
  int? alternativaSelecionada;
  late final corSelecionada = tema.colorScheme.primary.withOpacity(0.5);
  late final corNaoSelecionada = tema.colorScheme.onSurface.withOpacity(0.07);

  ThemeData get tema => Theme.of(context);

  TextStyle? get textStyle => tema.textTheme.bodyLarge;

  bool get selecionavel => widget.selecionavel;

  @override
  void initState() {
    super.initState();
    alternativaSelecionada = widget.alternativaSelecionada;
  }

  @override
  void didUpdateWidget(covariant _Alternativas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.alternativaSelecionada != widget.alternativaSelecionada) {
      alternativaSelecionada = widget.alternativaSelecionada;
    }
  }

  /// Retorna `true` se [alternativa] estiver selecionada.
  bool _selecionada(Alternativa alternativa) =>
      alternativaSelecionada == alternativa.sequencial;

  void _alterarAlternativaSelecionada(Alternativa alternativa) {
    if (selecionavel) {
      if (_selecionada(alternativa)) {
        setState(() => alternativaSelecionada = null);
        widget.alterando?.call(null);
      } else {
        setState(() => alternativaSelecionada = alternativa.sequencial);
        widget.alterando?.call(alternativa);
      }
    }
  }

  @override
  Widget build(_) {
    final List<Widget> lista = <Widget>[];
    widget.alternativas.forEach((alternativa) {
      lista.add(_construirAlternativa(alternativa));
    });
    return Column(children: lista);
  }

  /// Retorna o componente para uma alternativa de resposta.
  Widget _construirAlternativa(Alternativa alternativa) {
    final margin = const EdgeInsets.only(bottom: 8);
    final padding = const EdgeInsets.all(8);
    final decoration = BoxDecoration(
      borderRadius: const BorderRadius.all(const Radius.circular(4)),
      color: () {
        final selecionada = _selecionada(alternativa);
    
        if (widget.verificar) {
          if (alternativa.verificar(widget.gabarito)) return AppTheme.corAcerto;
          return selecionada ? AppTheme.corErro : corNaoSelecionada;
        }

        return selecionada ? corSelecionada : corNaoSelecionada;
      }(),
    );

    if (selecionavel) {
      return GestureDetector(
        onTap: () {
          if (mounted) _alterarAlternativaSelecionada(alternativa);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: margin,
          padding: padding,
          decoration: decoration,
          child: _construirEstruturaAlternativa(alternativa),
        ),
      );
    }

    return Container(
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: _construirEstruturaAlternativa(alternativa),
    );
  }

  Row _construirEstruturaAlternativa(Alternativa alternativa) {
    return Row(
      children: <Widget>[
        // Estrutura do indicador da alternativa.
        CircleAvatar(
          radius: 15,
          backgroundColor: tema.scaffoldBackgroundColor,
          child: Text(alternativa.identificador, style: textStyle),
        ),
        // Estrutura do conteúdo da alternativa.
        Expanded(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Builder(builder: (_) {
                  // Caso o conteúdo da alternativa seja texto.
                  if (alternativa.isTipoTexto) {
                    KaTeX tex = KaTeX(
                      laTeXCode: alternativa.conteudo as String,
                      /* laTeXCode: Text(alternativa.conteudo as String,
                          textAlign: TextAlign.justify, style: textStyle), */
                    );
                    return _Text(
                      blocosDeTexto: tex.blocosDoTexto,
                      alinhamento: tex.temLaTex == true
                          ? TextAlign.start
                          : TextAlign.justify,
                    );
                  }
                  // Caso o conteúdo da alternativa seja imágem.
                  else if (alternativa.isTipoImagem) {
                    return ImagemQuestaoWidget(
                        alternativa.conteudo as ImagemQuestao);
                  } else
                    return const SizedBox();
                }))
          ],
        )),
      ],
    );
  }
}

/// Cria um [Text] a partir das partes fornecidas no argumento [blocosDeTexto].
class _Text extends Text {
  _Text({
    Key? key,
    required this.blocosDeTexto,
    required this.alinhamento,
  }) : super.rich(
          TextSpan(
              children: blocosDeTexto,
              style: AppTheme.instance.light.textTheme.bodyLarge),
          textAlign: alinhamento,
          key: key,
        );

  /// As partes usadas para criar o [Text].
  final List<InlineSpan> blocosDeTexto;

  /// O alinhamento do texto.
  final TextAlign alinhamento;
}

/// Estrutura que conterá uma imagem do enunciado ou da alternativa.
class ImagemQuestaoWidget extends StatelessWidget {
  const ImagemQuestaoWidget(this.imagem, {Key? key}) : super(key: key);

  final ImagemQuestao imagem;

  @override
  Widget build(BuildContext context) {
    final placeHolder = AppShimmer(
      width: imagem.width,
      height: imagem.height,
    );
    return Observer(builder: (_) {
      //imagem.provider é observável.
      if (imagem.provider == null) {
        return placeHolder;
      } else {
        return Image(
          fit: BoxFit.scaleDown,
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

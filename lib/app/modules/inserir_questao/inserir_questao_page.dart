import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../shared/utils/strings_db.dart';
import '../../shared/widgets/appBottomSheet.dart';
import '../../shared/widgets/botoes.dart';
import '../../shared/widgets/katex_flutter.dart';
import '../../shared/widgets/questao_widget.dart';
import '../quiz/shared/models/imagem_questao_model.dart';
import '../quiz/shared/models/questao_model.dart';
import 'assuntos/selecionar_assuntos_controller.dart';
import 'assuntos/selecionar_assuntos_page.dart';
import 'inserir_questao_controller.dart';

class InserirQuestaoPage extends StatefulWidget {
  const InserirQuestaoPage({super.key});

  @override
  State<InserirQuestaoPage> createState() => _InserirQuestaoPageState();
}

class _InserirQuestaoPageState extends State<InserirQuestaoPage> {
  final controle = InserirQuestaoController();
  late final controleAno = TextEditingController(
    text: controle.ano == null ? null : '${controle.ano}',
  );

  bool inserindo = false;

  @override
  void dispose() {
    controleAno.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    diviver() => const Divider();

    onPressedInsert(Questao questao) async {
      if (inserindo) return;
      inserindo = true;
      final futuro = controle.inserirQuestao(questao);
      await BottomSheetCarregando(future: futuro).showModal(context);
      final questaoInserida = await futuro;
      if (questaoInserida != null) {
        if (context.mounted) {
          await AppBottomSheet(
            isScrollControlled: true,
            maximize: true,
            content: QuestaoWidget(
              questao: questaoInserida,
              selecionavel: false,
              rolavel: false,
              verificar: true,
            ),
          ).showModal(context);
        }
        controleAno.text = '';
        if (context.mounted) {
          setState(() {});
        }
      }
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      inserindo = false;
    }

    onPressedView() async {
      final questao = await controle.questao();
      if (questao != null) {
        if (context.mounted) {
          AppBottomSheet(
            isScrollControlled: true,
            maximize: true,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QuestaoWidget(
                  questao: questao,
                  selecionavel: false,
                  rolavel: false,
                  verificar: true,
                ),
                BotaoPrimario(
                  label: 'Inserir',
                  onPressed: () => onPressedInsert(questao),
                )
              ],
            ),
          ).showModal(context);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: controleAno,
            decoration: const InputDecoration(
              labelText: 'Ano',
              hintText: 'Ano de aplicação da questão',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            onChanged: (valor) => controle.ano = int.tryParse(valor),
          ),
          diviver(),
          _NivelIndice(
            controle: controle,
            referencia: false,
          ),
          diviver(),
          Observer(builder: (_) {
            return SwitchListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text('Faz referência a outra questão?'),
              value: controle.referencia,
              onChanged: (valor) => controle.referencia = valor,
            );
          }),
          diviver(),
          Observer(builder: (_) {
            if (controle.referencia) {
              return _NivelIndice(
                controle: controle,
                referencia: true,
              );
            }
            return _AssuntosEnunciadoAlternativas(controle: controle);
          }),
          diviver(),
          BotaoPrimario(
            label: 'Visualizar',
            onPressed: onPressedView,
          )
        ],
      ),
    );
  }
}

class _NivelIndice extends StatefulWidget {
  const _NivelIndice({
    required this.controle,
    this.referencia = false,
  });

  final InserirQuestaoController controle;
  final bool referencia;

  @override
  State<_NivelIndice> createState() => _NivelIndiceState();
}

class _NivelIndiceState extends State<_NivelIndice> {
  final controleIndice = TextEditingController();
  String? _textoIndice() {
    final indice = widget.referencia
        ? widget.controle.indiceReferencia
        : widget.controle.indice;
    return indice == null ? null : '$indice';
  }

  @override
  void dispose() {
    controleIndice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controleIndice.text = _textoIndice() ?? '';
    diviver() => const Divider();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(widget.referencia ? 'Nível da referência:' : 'Nível:'),
        ),
        Observer(builder: (_) {
          return Row(
            children: () {
              final niveis = [1, 2, 3];
              if (widget.referencia) niveis.remove(widget.controle.nivel);
              return niveis.map((nivel) {
                return Column(
                  children: [
                    Text('$nivel'),
                    Radio<int>(
                      value: nivel,
                      groupValue: widget.referencia
                          ? widget.controle.nivelReferencia
                          : widget.controle.nivel,
                      onChanged: (valor) {
                        if (widget.referencia) {
                          widget.controle.nivelReferencia = valor;
                        } else {
                          widget.controle.nivel = valor;
                          if (widget.controle.nivelReferencia == valor) {
                            widget.controle.nivelReferencia = null;
                          }
                        }
                      },
                    ),
                  ],
                );
              }).toList();
            }(),
          );
        }),
        diviver(),
        TextField(
          keyboardType: TextInputType.number,
          controller: controleIndice,
          decoration: InputDecoration(
            labelText: widget.referencia ? 'Índice da referência' : 'Índice',
            hintText: 'De 1 a 20',
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          onChanged: (valor) => widget.referencia
              ? widget.controle.indiceReferencia = int.tryParse(valor)
              : widget.controle.indice = int.tryParse(valor),
        ),
      ],
    );
  }
}

class _AssuntosEnunciadoAlternativas extends StatelessWidget {
  const _AssuntosEnunciadoAlternativas({
    required this.controle,
  });

  final InserirQuestaoController controle;

  @override
  Widget build(BuildContext context) {
    diviver() => const Divider();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Assuntos(controle: controle),
        diviver(),
        _Enunciado(controle: controle),
        diviver(),
        _Alternativas(controle: controle),
        diviver(),
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text('Gabarito:'),
        ),
        Row(
          children: [0, 1, 2, 3, 4].map((sequencial) {
            return Observer(builder: (_) {
              return Column(
                children: [
                  Text('ABCDE'.substring(sequencial, sequencial + 1)),
                  Radio<int>(
                    value: sequencial,
                    groupValue: controle.gabarito,
                    onChanged: (valor) => controle.gabarito = valor,
                  ),
                ],
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}

class _Alternativas extends StatefulWidget {
  const _Alternativas({
    required this.controle,
  });

  final InserirQuestaoController controle;

  @override
  State<_Alternativas> createState() => _AlternativasState();
}

class _AlternativasState extends State<_Alternativas> {
  final controlesTexto = <int, TextEditingController>{};

  @override
  void dispose() {
    controlesTexto.forEach((_, controle) => controle.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    alternativa(int sequencial) {
      const keyConteudo = DbConst.kDbDataAlternativaKeyConteudo;
      const keyTipo = DbConst.kDbDataAlternativaKeyTipo;
      const idTexto = DbConst.kDbDataAlternativaKeyTipoValTexto;
      const idImagem = DbConst.kDbDataAlternativaKeyTipoValImagem;

      idTipo() => widget.controle.alternativas[sequencial][keyTipo] as int?;

      onPressedGetImagem() async {
        widget.controle.alternativas[sequencial][keyTipo] = idImagem;
        final imagem = await widget.controle.getImagemAlternativa(sequencial);
        if (imagem != null) setState(() {});
      }

      onPressedFechar() {
        widget.controle.alternativas[sequencial].remove(keyTipo);
        widget.controle.alternativas[sequencial].remove(keyConteudo);
        setState(() {});
      }

      final valorTitulo = ValueNotifier<String?>(
          widget.controle.alternativas[sequencial][keyConteudo]);

      titulo() {
        if (idTipo() != idImagem) {
          widget.controle.alternativas[sequencial][keyTipo] = idTexto;
          final textControle = controlesTexto[sequencial] ??
              TextEditingController(
                text: valorTitulo.value,
              );
          return TextField(
            controller: textControle,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: r'Use "$" ou "$$" para delimitar LaTex',
            ),
            onChanged: (valor) {
              valorTitulo.value = valor;
              widget.controle.alternativas[sequencial][keyConteudo] = valor;
            },
          );
        } else {
          final conteudo =
              widget.controle.alternativas[sequencial][keyConteudo] as String?;
          if (conteudo != null) {
            final dados = jsonDecode(conteudo) as Map;
            dados[ImagemQuestao.kKeyName] =
                'imagem_alternativa_$sequencial.temp';
            return ImagemQuestaoWidget(ImagemQuestao.fromMap(dados.cast()));
          }
        }
        return null;
      }

      subTitulo() {
        if (idTipo() == idImagem) return null;
        return Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: ValueListenableBuilder(
            valueListenable: valorTitulo,
            builder: (_, String? valor, __) {
              return KaTeX(laTeXCode: valor ?? '');
            },
          ),
        );
      }

      return ListTile(
        contentPadding: const EdgeInsets.all(.0),
        leading: CircleAvatar(
          child: Text('ABCDE'.substring(sequencial, sequencial + 1)),
        ),
        trailing: IconButton(
          icon: Icon(idTipo() != idImagem ? Icons.camera_alt : Icons.close),
          onPressed:
              idTipo() != idImagem ? onPressedGetImagem : onPressedFechar,
        ),
        title: titulo(),
        subtitle: subTitulo(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Alternativas:'),
        ...widget.controle.alternativas.map((dados) {
          final sequencial =
              dados[DbConst.kDbDataAlternativaKeySequencial] as int;
          return alternativa(sequencial);
        }),
      ],
    );
  }
}

class _Assuntos extends StatelessWidget {
  const _Assuntos({
    required this.controle,
  });

  final InserirQuestaoController controle;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Assunto(s):'),
          ...controle.assuntos.toList().map((e) {
            return ListTile(
              contentPadding: const EdgeInsets.all(.0),
              title: Text(e.assunto.titulo),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controle.assuntos.remove(e);
                },
              ),
            );
          }),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final arvore = await Navigator.of(context).push<ArvoreAssuntos>(
                MaterialPageRoute(
                    builder: (_) => SelecionarAssuntosPage(controle.assuntos)),
              );
              if (arvore != null) controle.assuntos.add(arvore);
            },
          ),
        ],
      );
    });
  }
}

class _Enunciado extends StatefulWidget {
  const _Enunciado({
    required this.controle,
  });

  final InserirQuestaoController controle;

  @override
  State<_Enunciado> createState() => _EnunciadoState();
}

class _EnunciadoState extends State<_Enunciado> {
  final controlesTexto = <int, TextEditingController>{};

  @override
  void dispose() {
    controlesTexto.forEach((_, controle) => controle.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text('Enunciado:'),
        ),
        ..._construirPartes(),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            final opcao = await showDialog<int>(
              context: context,
              builder: (context) => SimpleDialog(
                children: [
                  SimpleDialogOption(
                    child: const Text('Parágrafo'),
                    onPressed: () => Navigator.of(context).pop(0),
                  ),
                  SimpleDialogOption(
                    child: const Text('Imagem no parágrafo'),
                    onPressed: () => Navigator.of(context).pop(1),
                  ),
                  SimpleDialogOption(
                    child: const Text('Imagem destacada'),
                    onPressed: () => Navigator.of(context).pop(2),
                  ),
                ],
              ),
            );

            if (opcao == 0) {
              widget.controle.enunciado.add('');
            } else if (opcao == 1) {
              await widget.controle.getImagemEnunciado(false);
            } else if (opcao == 2) {
              await widget.controle.getImagemEnunciado(true);
            }
            setState(() {});
          },
        ),
      ],
    );
  }

  Iterable<Widget> _construirPartes() {
    int indice = -1;
    int indiceImaggem = -1;
    final enunciado = widget.controle.enunciado.toList();

    parte(String texto) {
      if (texto == DbConst.kDbStringImagemNaoDestacada ||
          texto == DbConst.kDbStringImagemDestacada) {
        indiceImaggem++;
        final imagem = widget.controle.imagensEnunciado[indiceImaggem];
        return ListTile(
          contentPadding: const EdgeInsets.all(.0),
          title: ImagemQuestaoWidget(imagem),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.controle.enunciado.removeAt(indice);
              widget.controle.imagensEnunciado.remove(imagem);
              setState(() {});
            },
          ),
        );
      } else {
        final textControle =
            controlesTexto[indice] ?? TextEditingController(text: texto);
        final valorTexto = ValueNotifier<String?>(textControle.text);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textControle,
              maxLines: null,
              decoration: InputDecoration(
                hintText: r'Use "$" ou "$$" para delimitar LaTex',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.controle.enunciado.removeAt(indice);
                    setState(() {});
                  },
                ),
              ),
              onChanged: (valor) {
                valorTexto.value = valor;
                widget.controle.enunciado[indice] = valor;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ValueListenableBuilder(
                valueListenable: valorTexto,
                builder: (_, String? valor, __) {
                  return KaTeX(laTeXCode: valor ?? '');
                },
              ),
            ),
          ],
        );
      }
    }

    return enunciado.map((e) {
      indice++;
      return parte(e);
    });
  }
}

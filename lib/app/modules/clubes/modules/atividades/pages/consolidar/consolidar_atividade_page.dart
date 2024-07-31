import 'package:clubedematematica/app/shared/widgets/katex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../shared/theme/appTheme.dart';
import '../../../../../../shared/utils/strings_db.dart';
import '../../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../../shared/widgets/questao_widget.dart';
import '../../../../shared/models/clube.dart';
import '../../../../shared/models/usuario_clube.dart';
import '../../../../shared/utils/tema_clube.dart';
import '../../models/argumentos_atividade_page.dart';
import '../../models/atividade.dart';
import '../../models/questao_atividade.dart';
import 'consolidar_atividade_controller.dart';

/// Página destinada a responder às questões de uma atividade.
class ConsolidarAtividadePage extends StatefulWidget {
  ConsolidarAtividadePage(ArgumentosAtividadePage args, {Key? key})
      : atividade = args.atividade,
        clube = args.clube,
        super(key: key);

  final Atividade atividade;
  final Clube clube;

  @override
  State<ConsolidarAtividadePage> createState() =>
      _ConsolidarAtividadePageState();
}

class _ConsolidarAtividadePageState extends State<ConsolidarAtividadePage> {
  late final controle = ConsolidarAtividadeController(
    atividade: widget.atividade,
    clube: widget.clube,
  );

  @override
  void dispose() {
    super.dispose();
  }

  _editarAtividade(BuildContext context, Atividade atividade) async {
    if (atividade.encerrada) {
      final editar = await _abrirPaginaInferior(
          context, 'EDITAR', 'A atividade já foi encerrada');
      if (!editar) return;
    } else if (atividade.liberada) {
      final editar = await _abrirPaginaInferior(context, 'EDITAR',
          'A atividade já foi liberada. Algum membro pode estar resolvendo-a');
      if (!editar) return;
    }
    controle.abrirPaginaEditarAtividade(context);
  }

  Future<bool> _abrirPaginaInferior(
      BuildContext context, String rotulo, String mensagem) async {
    return (await BottomSheetAcoes<bool>(
          labelActionFirst: rotulo,
          labelActionLast: 'FECHAR',
          resultActionFirst: true,
          resultActionLast: false,
          actionFirstIsPrimary: false,
          actionLastIsPrimary: false,
          title: Text(mensagem),
        ).showModal<bool>(context)) ??
        false;
  }

  _liberarAtividade(BuildContext context) async {
    final futuro = controle.liberarAtividade();
    await BottomSheetCarregando(future: futuro).showModal(context);
    final sucesso = await futuro;
    if (!sucesso) {
      await BottomSheetErro('A atividade não foi enviada').showModal(context);
    }
  }

  _excluirAtividade(BuildContext context) async {
    if (controle.atividade.encerrada) {
      final excluir = await _abrirPaginaInferior(
          context, 'EXCLUIR', 'A atividade já foi encerrada');
      if (!excluir) return;
    } else if (controle.atividade.liberada) {
      final excluir = await _abrirPaginaInferior(context, 'EXCLUIR',
          'A atividade já foi liberada. Algum membro pode estar resolvendo-a');
      if (!excluir) return;
    }
    final futuro = controle.excluirAtividade();
    await BottomSheetCarregando(future: futuro).showModal(context);
    final sucesso = await futuro;
    if (mounted) {
      if (sucesso) {
        Navigator.of(context).pop();
      } else {
        await BottomSheetErro('A atividade não foi excluída')
            .showModal(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final temaClube = Modular.get<TemaClube>();
    return Theme(
      data: temaClube.tema,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Observer(builder: (_) {
            return AppBar(
              title: Text(controle.atividade.titulo),
              actions: [
                if (controle.podeLiberar)
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _liberarAtividade(context),
                  ),
                if (controle.podeEditar)
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () =>
                        _editarAtividade(context, controle.atividade),
                  ),
                if (controle.podeExcluir)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _excluirAtividade(context),
                  ),
              ],
            );
          }),
        ),
        body: RefreshIndicator(
          backgroundColor: temaClube.primaria,
          color: temaClube.sobrePrimaria,
          onRefresh: () async {
            await controle.sincronizar();
            //if (mounted) setState(() {});
          },
          child: _Membros(controle),
        ),
      ),
    );
  }
}

class _Membros extends StatefulWidget {
  const _Membros(
    this.controle, {
    Key? key,
  }) : super(key: key);

  final ConsolidarAtividadeController controle;

  @override
  State<_Membros> createState() => _MembrosState();
}

class _MembrosState extends State<_Membros> {
  ConsolidarAtividadeController get controle => widget.controle;
  List<UsuarioClube> get membros => controle.clube.membros.toList();
  Atividade get atividade => controle.atividade;
  final Duration duracaoAnimacao = kThemeAnimationDuration;
  late final estados = membros.map((_) => false).toList();
  final temaClube = Modular.get<TemaClube>();
  final corAcertos = AppTheme.corAcerto;
  final corErros = AppTheme.corErro;
  final corBrancos = Colors.grey[200]!;

  List<ExpansionPanel> _construirMembros() {
    return List.generate(
      membros.length,
      (index) => _construirMembro(estados[index], membros[index]),
    );
  }

  ExpansionPanel _construirMembro(bool expandir, UsuarioClube membro) {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: expandir,
      //backgroundColor: Colors.transparent,
      headerBuilder: (context, expandido) {
        return AnimatedPadding(
          duration: duracaoAnimacao,
          padding: expandido
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(vertical: 16.0),
          child: ListTile(
            title:
                Text(membro.nome ?? membro.email ?? 'Membro não identificado'),
            leading: CircleAvatar(
              child: Icon(
                Icons.person,
                color: temaClube.enfaseSobreSuperficie,
              ),
              backgroundColor: temaClube.primaria.withOpacity(0.3),
            ),
            trailing: _construirIndicadorErrosAcertos(membro),
          ),
        );
      },
      body: _construirQuestoesMembro(membro),
    );
  }

  Widget _construirIndicadorErrosAcertos(UsuarioClube membro) {
    return Observer(builder: (_) {
      final acertos = controle.acertos(membro).value;
      final erros = controle.erros(membro).value;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (acertos > 0)
            Chip(
              label: Text('$acertos'),
              backgroundColor: corAcertos,
            ),
          if (erros > 0)
            Chip(
              label: Text('$erros'),
              backgroundColor: corErros,
            ),
        ],
      );
    });
  }

  Widget _construirQuestoesMembro(UsuarioClube membro) {
    return Observer(builder: (_) {
      return Column(
        children: [
          for (var questao in atividade.questoes)
            Builder(builder: (context) {
              final resultado = questao.resultado(membro.id);
              final alternativaSelecionada =
                  questao.resposta(membro.id)?.sequencial;
              final identificador = alternativaSelecionada == null
                  ? '—'
                  : 'ABCDE'.characters.elementAt(alternativaSelecionada);
              final Color enfase;
              final Widget? trailing;

              switch (resultado) {
                case EstadoResposta.correta:
                  enfase = corAcertos;
                  trailing = Icon(Icons.check, color: enfase);
                  break;
                case EstadoResposta.incorreta:
                  enfase = corErros;
                  trailing = Icon(Icons.close, color: enfase);
                  break;
                case EstadoResposta.emBranco:
                  enfase = corBrancos;
                  trailing = null;
                  break;
              }

              return ListTile(
                title: Text.rich(
                  TextSpan(
                    children: KaTeX(
                      laTeXCode: [
                        ...questao.enunciado.where((e) =>
                            e != DbConst.kDbStringImagemNaoDestacada &&
                            e != DbConst.kDbStringImagemDestacada)
                      ].join(' '),
                    ).blocosDoTexto,
                  ),
                  //maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: CircleAvatar(
                  child: Text(
                    identificador,
                    style: TextStyle(color: temaClube.sobreSuperficie),
                  ),
                  backgroundColor: enfase,
                ),
                trailing: trailing,
                onTap: () {
                  AppBottomSheet(
                    isScrollControlled: true,
                    maximize: true,
                    contentPadding: const EdgeInsets.all(0),
                    content: QuestaoWidget(
                      questao: questao,
                      selecionavel: false,
                      rolavel: false,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alternativaSelecionada: alternativaSelecionada,
                      verificar: true,
                    ),
                  ).showModal(context);
                },
              );
            })
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Observer(builder: (_) {
          return ExpansionPanelList(
            animationDuration: duracaoAnimacao,
            elevation: 0,
            //dividerColor: Colors.transparent,
            children: controle.clube.membros.isEmpty ? [] : _construirMembros(),
            expansionCallback: (indice, expandido) {
              for (var i = 0; i < estados.length; i++) estados[i] = false;
              setState(() {
                estados[indice] = expandido;
              });
            },
          );
        }),
      ],
    );
  }
}

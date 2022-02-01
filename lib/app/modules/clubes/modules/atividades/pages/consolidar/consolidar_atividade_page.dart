import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../shared/theme/appTheme.dart';
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

  @override
  Widget build(BuildContext context) {
    final temaClube = Modular.get<TemaClube>();
    final corPrimaria = temaClube.primaria;
    final corTextoPrimaria = temaClube.sobrePrimaria;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: corTextoPrimaria),
        backgroundColor: corPrimaria,
        title: Text(
          controle.atividade.titulo,
          style: TextStyle(color: corTextoPrimaria),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: _Membros(controle),
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

  List<ExpansionPanel> _construirMembros(BuildContext context) {
    return List.generate(
      membros.length,
      (index) => _construirMembro(estados[index], membros[index], context),
    );
  }

  ExpansionPanel _construirMembro(
      bool expandir, UsuarioClube membro, BuildContext context) {
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
            title: Text(
                membro.nome ?? membro.email ?? membro.id.toString()), //TODO
            leading: CircleAvatar(
              child: Icon(
                Icons.person,
                color: temaClube.enfaseSobreSuperficie,
              ),
              backgroundColor: temaClube.primaria.withOpacity(0.3),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: _construirChips(membro),
            ),
          ),
        );
      },
      body: _construirQuestoesMembro(membro),
    );
  }

  List<Widget> _construirChips(UsuarioClube membro) {
    final acertos = controle.acertos(membro);
    final erros = controle.erros(membro);
    return [
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
    ];
  }

  Widget _construirQuestoesMembro(UsuarioClube membro) {
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
              title: Text(questao.id), //TODO
              leading: CircleAvatar(
                child: Text(
                  identificador,
                  style: TextStyle(color: temaClube.enfaseSobreSuperficie),
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
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionPanelList(
          animationDuration: duracaoAnimacao,
          elevation: 0,
          //dividerColor: Colors.transparent,
          children: membros.isEmpty ? [] : _construirMembros(context),
          expansionCallback: (indice, expandido) {
            for (var i = 0; i < estados.length; i++) estados[i] = false;
            setState(() {
              estados[indice] = !expandido;
            });
          },
        ),
      ],
    );
  }
}

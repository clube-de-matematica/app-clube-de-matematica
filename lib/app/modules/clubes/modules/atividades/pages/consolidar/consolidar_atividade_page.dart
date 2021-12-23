import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../shared/widgets/appBottomSheet.dart';
import '../../../../../../shared/widgets/questao_widget.dart';
import '../../../../shared/models/clube.dart';
import '../../../../shared/models/usuario_clube.dart';
import '../../../../shared/utils/tema_clube.dart';
import '../../models/argumentos_atividade_page.dart';
import '../../models/atividade.dart';
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
  late final controle = ConsolidarAtividadeController(widget.atividade);

  @override
  void dispose() {
    //controle.dispose();//TODO
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final temaClube = Modular.get<TemaClube>();
    final corPrimaria = temaClube.primaria;
    final corTextoPrimaria = temaClube.textoPrimaria;
    final corTexto = temaClube.texto;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: corTextoPrimaria),
        backgroundColor: corPrimaria,
        title: Text(
          widget.atividade.titulo,
          style: TextStyle(color: corTextoPrimaria),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {},
          ),
        ],
      ),
      body: _Membros(
        clube: widget.clube,
        atividade: widget.atividade,
      ),
    );
  }
}

class _Membros extends StatefulWidget {
  const _Membros({
    Key? key,
    required this.clube,
    required this.atividade,
  }) : super(key: key);

  final Clube clube;
  final Atividade atividade;

  @override
  State<_Membros> createState() => _MembrosState();
}

class _MembrosState extends State<_Membros> {
  List<UsuarioClube> get membros => widget.clube.membros;
  late final estados = membros.map((_) => false).toList();
  final temaClube = Modular.get<TemaClube>();

  List<ExpansionPanel> _construirMembros(BuildContext context) {
    final corPrimaria = temaClube.primaria;
    final corTextoPrimaria = temaClube.textoPrimaria;
    final corTexto = temaClube.texto;
    return List.generate(
      membros.length,
      (index) {
        final membro = membros[index];
        return ExpansionPanel(
          canTapOnHeader: true,
          isExpanded: estados[index],
          backgroundColor: Colors.transparent,
          headerBuilder: (context, expandido) {
            return ListTile(
              title: Text(
                  membro.nome ?? membro.email ?? membro.id.toString()), //TODO
              leading: CircleAvatar(
                child: Icon(
                  Icons.person,
                  color: corTexto,
                ),
                backgroundColor: corPrimaria.withOpacity(0.3),
              ),
            );
          },
          body: _construirQuestoesMembro(context),
        );
      },
    );
  }

  Widget _construirQuestoesMembro(BuildContext context) {
    final corPrimaria = temaClube.primaria;
    final corTextoPrimaria = temaClube.textoPrimaria;
    final corTexto = temaClube.texto;
    return Column(
      children: [
        for (var questao in widget.atividade.questoes)
          ListTile(
            title: Text(questao.id), //TODO
            leading: CircleAvatar(
              child: Icon(
                Icons.check,
                color: corTexto,
              ),
              backgroundColor: corPrimaria.withOpacity(0.3),
            ),
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
                ),
              ).showModal(context);
            },
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionPanelList(
          elevation: 0,
          dividerColor: Colors.transparent,
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

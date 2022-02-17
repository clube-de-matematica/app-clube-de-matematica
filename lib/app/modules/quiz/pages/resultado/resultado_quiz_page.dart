import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../shared/repositories/questoes/questoes_repository.dart';
import '../../../../shared/theme/appTheme.dart';
import '../../../../shared/utils/strings_db.dart';
import '../../../../shared/widgets/questao_widget.dart';
import '../../shared/models/questao_model.dart';
import 'resultado_quiz_controller.dart';

/// Página destinada a responder às questões de uma atividade.
class ResultadoQuizPage extends StatefulWidget {
  ResultadoQuizPage({
    Key? key,
    required this.repositorio,
  }) : super(key: key);

  final QuestoesRepository repositorio;

  @override
  State<ResultadoQuizPage> createState() => _ResultadoQuizPageState();
}

class _ResultadoQuizPageState extends State<ResultadoQuizPage> {
  late final controle =
      ResultadoQuizController(repositorio: widget.repositorio);
  final Duration duracaoAnimacao = kThemeAnimationDuration;
  List<bool> estados = [];

  @override
  void dispose() {
    super.dispose();
  }

  ExpansionPanel _construirQuestao(
    bool expandir,
    Questao questao,
    int? resposta,
  ) {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: expandir,
      //backgroundColor: Colors.transparent,
      headerBuilder: (context, expandido) {
        cor() {
          if (resposta == null) return Colors.grey[200]!;
          if (resposta == questao.gabarito) return AppTheme.corAcerto;
          return AppTheme.corErro;
        }

        return AnimatedPadding(
          duration: duracaoAnimacao,
          padding: expandido
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(vertical: 16.0),
          child: ListTile(
            title: AnimatedOpacity(
              opacity: expandido ? 0 : 1,
              duration: duracaoAnimacao,
              child: Text(
                [
                  ...questao.enunciado.where((e) =>
                      e != DbConst.kDbStringImagemNaoDestacada &&
                      e != DbConst.kDbStringImagemDestacada)
                ].join(' '),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: cor(),
            ),
          ),
        );
      },
      body: QuestaoWidget(
        questao: questao,
        selecionavel: false,
        rolavel: false,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alternativaSelecionada: resposta,
        verificar: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Observer(
            builder: (_) {
              if (controle.carregando) {
                return const Text('Carregando...');
              }
              final total = controle.total;
              final acertos = controle.acertos;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$acertos de $total'),
                  if (total != 0)
                    Text('${(100 * acertos / total).toStringAsFixed(0)} %'),
                ],
              );
            },
          ),
        ),
      ),
      body: Observer(
          builder: (_) {
            if (controle.carregando) {
              return Center(child: CircularProgressIndicator());
            }
            if (estados.length != controle.total) {
              estados = List.filled(controle.total, false);
            }
            return ListView(
              children: [
                ExpansionPanelList(
                  animationDuration: duracaoAnimacao,
                  elevation: 1,
                  //dividerColor: Colors.transparent,
                  children: List.generate(
                    estados.length,
                    (indice) => _construirQuestao(
                      estados[indice],
                      controle.questao(indice)!,
                      controle.resposta(indice)?.sequencial,
                    ),
                  ),
                  expansionCallback: (indice, expandido) {
                    for (var i = 0; i < estados.length; i++) estados[i] = false;
                    setState(() {
                      estados[indice] = !expandido;
                    });
                  },
                ),
              ],
            );
          }),
    );
  }
}

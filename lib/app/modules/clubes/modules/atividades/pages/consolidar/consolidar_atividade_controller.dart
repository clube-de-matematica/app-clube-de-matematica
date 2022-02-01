import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/models/clube.dart';
import '../../../../shared/models/usuario_clube.dart';
import '../../../../shared/repositories/clubes_repository.dart';
import '../../models/atividade.dart';

class ConsolidarAtividadeController {
  ConsolidarAtividadeController({
    required this.clube,
    required this.atividade,
  }) {
    Modular.get<ClubesRepository>().carregarQuestoesAtividade(atividade);
  }

  final Atividade atividade;
  final Clube clube;

  int acertos(UsuarioClube membro) {
    return atividade.questoes
        .where((quet) => quet.resposta(membro.id)?.sequencial == quet.gabarito)
        .length;
  }

  int brancos(UsuarioClube membro) {
    return atividade.questoes
        .where((quet) => quet.resposta(membro.id)?.sequencial == null)
        .length;
  }

  int erros(UsuarioClube membro) {
    return atividade.questoes.length - acertos(membro) - brancos(membro);
  }
}

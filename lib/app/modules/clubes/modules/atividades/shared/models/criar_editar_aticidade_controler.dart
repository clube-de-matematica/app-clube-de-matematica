import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../quiz/shared/models/questao_model.dart';
import '../../../../shared/models/clube.dart';
import '../../../../shared/repositories/clubes_repository.dart';
import '../../models/atividade.dart';

abstract class CriarEditarAtividadeController {
  CriarEditarAtividadeController(this.clube);

  /// Clube vinculado à atividade.
  final Clube clube;

  /// Repositório de clubes.
  @protected
  ClubesRepository get repositorio => Modular.get<ClubesRepository>();

  /// Retorna `null` se [titulo] for um título válido, caso contrário, retorna uma
  /// mensagem de erro.
  String? validarTitulo(String? titulo) {
    if (titulo?.isEmpty ?? true) return 'Insira um título';
    return null;
  }

  /// Ação executada para salvar os dados da atividade.
  /// Retorna `null` se a ação não for bem sucedida.
  Future<Atividade?> salvar({
    String? descricao,
    DateTime? encerramento,
    required DateTime liberacao,
    required String titulo,
    List<Questao> questoes = const [],
  });
}

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../modules/quiz/shared/models/assunto_model.dart';
import '../../../services/interface_db_servicos.dart';
import '../../models/debug.dart';
import '../interface_db_repository.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere aos assuntos.
class AssuntosRepository {
  AssuntosRepository(this.dbServicos);

  final IDbServicos dbServicos;

  /// Lista assincrona com os assuntos já carregados.
  FutureOr<List<Assunto>>? _assuntos;

  /// Se [_assuntos] é `null`, o método [carregarAssuntos] será executado, pois
  /// os assuntos ainda não foram carregados.
  FutureOr<List<Assunto>> get assuntos async {
    if (_assuntos == null) {
      if (!_isLoading) await carregarAssuntos();
    }
    return _assuntos!;
  }

  /// {@template app.AssuntosRepository.isLoading}
  /// Será verdadeiro se os assuntos estiverem em pocesso de carregamento.
  /// {@endtemplate}
  bool _isLoading = false;

  /// {@macro app.AssuntosRepository.isLoading}
  bool get isLoading => _isLoading;

  /// Buscar os assuntos no banco de dados.
  Future<List<Assunto>> carregarAssuntos() async {
    _isLoading = true;
    List<Assunto> resultado;
    try {
      resultado = await dbServicos.getAssuntos();
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro a buscar os dados da coleção ${CollectionType.assuntos.name}."));
      assert(Debug.print(e));
      _isLoading = false;
      return List<Assunto>.empty();
    }
    assert(listEquals(resultado, Assunto.instancias.toList()));
    _assuntos = resultado;
    _isLoading = false;
    return resultado;
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../../modules/quiz/shared/models/assunto_model.dart';
import '../../../services/interface_db_servicos.dart';
import '../../models/debug.dart';
import '../interface_db_repository.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere aos assuntos.
class AssuntosRepository {
  AssuntosRepository(this._dbServicos);

  final IDbServicos _dbServicos;

  /// {@template app.AssuntosRepository.carregando}
  /// Será verdadeiro se os assuntos estiverem em pocesso de carregamento.
  /// {@endtemplate}
  bool _carregando = false;

  /// {@macro app.AssuntosRepository.carregando}
  bool get carregando => _carregando;

  /// Conjunto observável com as instâncias de [Assunto] já carregadas.
  ObservableSet<Assunto> get assuntos => Assunto.instancias;

  /// Retorna o assunto correspondente a [id].
  /// Retorna null se o assunto não for encontrado.
  Future<Assunto?> get(int id) => _dbServicos.assunto(id);

  /// Buscar os assuntos no banco de dados.
  Future<ObservableSet<Assunto>> carregarAssuntos() async {
    _carregando = true;
    List<Assunto> resultado;
    try {
      resultado =
          await _dbServicos.getAssuntos().lastWhere((list) => list.isNotEmpty);
    } catch (e) {
      assert(Debug.printBetweenLine(
          "Erro a buscar os dados da coleção ${CollectionType.assuntos.name}."));
      assert(Debug.print(e));
      _carregando = false;
      resultado = List<Assunto>.empty();
    }
    assert(setEquals(resultado.toSet(), assuntos));
    _carregando = false;
    return assuntos;
  }
}

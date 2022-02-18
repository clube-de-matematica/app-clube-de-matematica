import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../../modules/quiz/shared/models/assunto_model.dart';
import '../../../services/db_servicos.dart';
import '../../models/debug.dart';
import '../interface_db_repository.dart';

/// Responsável por intermediar a relação entre o aplicativo e o banco de dados no que se
/// refere aos assuntos.
class AssuntosRepository {
  AssuntosRepository(this._dbServicos);

  final DbServicos _dbServicos;

  /// {@template app.AssuntosRepository.carregando}
  /// Será verdadeiro se os assuntos estiverem em pocesso de carregamento.
  /// {@endtemplate}
  bool _carregando = false;

  /// {@macro app.AssuntosRepository.carregando}
  bool get carregando => _carregando;

  /// Conjunto observável com as instâncias de [Assunto] já carregadas.
  ObservableSet<Assunto> get assuntos => Assunto.instancias;

  /// Retorna, assincronamente, o assunto correspondente a [id].
  /// Retorna `null` se o assunto não for encontrado.
  Future<Assunto?> get(int id) => _dbServicos.assunto(id);

  /// Retorna um observável para o assunto correspondente a [id].
  ///
  /// O valor inicial será `null` se o assunto ainda não estiver em [Assunto.instancias].
  Observable<Assunto?> getSinc(int id) {
    final observavel = Observable<Assunto?>(null);
    getAsinc() {
      return get(id).then<void>((assunto) {
        try {
          observavel.value = assunto;
        } catch (_) {
          // Caso `observavel` tenha sido destruído.
        }
      });
    }
    observavel.value = Assunto.instancias.cast<Assunto?>().firstWhere(
      (assunto) => assunto?.id == id,
      orElse: () {
        // O loop de eventos do Dart garante que o futuro a seguir não será concluído antes 
        // deste método (getSinc) e consequentemente de firstWhere e orElse.
        getAsinc();
        return null;
      },
    );
    return observavel;
  }

  /// Buscar os assuntos no banco de dados.
  Future<ObservableSet<Assunto>> carregarAssuntos() async {
    _carregando = true;
    List<Assunto> resultado;
    try {
      resultado =
          await _dbServicos.obterAssuntos().lastWhere((list) => list.isNotEmpty);
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

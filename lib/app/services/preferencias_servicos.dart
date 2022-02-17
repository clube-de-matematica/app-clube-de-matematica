import 'package:clubedematematica/app/modules/filtros/shared/models/filtros_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobx/mobx.dart';

import '../modules/quiz/pages/quiz/quiz_page.dart';

late final Box _preferencias;

class Preferencias implements Disposable {
  /// Certifique-se de que uma chamada de [inicializar] tenha sido concluída.
  static final instancia = Preferencias._();
  Preferencias._();

  static Future<Preferencias> inicializar() async {
    await Hive.initFlutter();
    _preferencias = await Hive.openBox('preferencias');
    return Preferencias.instancia;
  }

  /// [DateTime] da priveira vez que o aplicativo passou da tela de login.
  DateTime? get primeiroAcesso => _preferencias.get('primeiro_acesso');

  /// [DateTime] da priveira vez que o aplicativo passou da tela de login.
  set primeiroAcesso(DateTime? primeiroAcesso) {
    _preferencias.put('primeiro_acesso', primeiroAcesso);
  }

  /// Nome do usuário.
  String? get nome => _preferencias.get('nome');

  /// Nome do usuário.
  set nome(String? nome) {
    _preferencias.put('nome', nome);
  }

  /// Conjunto com as questões respondidas em [QuizPage] cujo resultado ainda não foi visualizado.
  final cacheQuiz = _ObservableSetCacheQuiz(_preferencias);

  /// [Filtros] usado no quiz. Não há garantia do retorno da mesma instância.
  Filtros get filtrosQuiz {
    final dados = _preferencias.get('filtros_quiz') as String?;
    return dados == null ? Filtros() : Filtros.fromJson(dados);
  }

  /// [Filtros] usado no quiz.
  set filtrosQuiz(Filtros filtros) {
    _preferencias.put('filtros_quiz', filtros.toJson());
  }

  @override
  void dispose() {
    _preferencias.close();
  }
}

/// Conjunto com as questões respondidas em [QuizPage] cujo resultado ainda não foi visualizado.
class _ObservableSetCacheQuiz extends ObservableSet<String> {
  _ObservableSetCacheQuiz(this._preferencias)
      : super.of(
            (_preferencias.get('cache_quiz', defaultValue: []) as List).cast());

  final Box _preferencias;
  final List<Future> _operacoes = [];

  Future<bool> _setCacheQuiz() async {
    // Usa-se uma cópia da lista de operações para evitar erros de interação.
    await Future.wait(_operacoes.toList());

    final operacao = _preferencias.put('cache_quiz', toList());
    _operacoes.add(operacao);

    bool resultado;
    try {
      await operacao;
      resultado = true;
    } catch (_) {
      resultado = false;
    }

    _operacoes.remove(operacao);
    return resultado;
  }

  @override
  bool add(String id) {
    final resultado = super.add(id);
    if (resultado) _setCacheQuiz();
    return resultado;
  }

  @override
  bool remove(Object? id) {
    final resultado = super.remove(id);
    if (resultado) _setCacheQuiz();
    return resultado;
  }

  @override
  void clear() {
    super.clear();
    _setCacheQuiz();
  }
}

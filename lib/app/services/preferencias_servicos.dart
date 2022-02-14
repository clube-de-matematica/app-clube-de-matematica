import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/adapters.dart';

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

  String? get nome => _preferencias.get('nome');
  set nome(String? nome) {
    _preferencias.put('nome', nome);
  }

  /// [DateTime] da priveira vez que o aplicativo passou da tela de login.
  DateTime? get primeiroAcesso => _preferencias.get('primeiro_acesso');
  set primeiroAcesso(DateTime? primeiroAcesso) {
    _preferencias.put('primeiro_acesso', primeiroAcesso);
  }

  @override
  void dispose() {
    _preferencias.close();
  }
}

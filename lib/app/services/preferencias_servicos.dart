import 'package:hive_flutter/adapters.dart';

class Preferencias {
  Box _preferencias = Hive.box('preferencias');
  
  String? _nome;
  String? get nome => _preferencias.get('nome');
  set nome(String? nome) => _preferencias.put('nome', _nome);
}

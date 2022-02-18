import 'dart:async';
import 'dart:io';

import 'package:mobx/mobx.dart';

part 'conectividade.g.dart';

class Conectividade extends _ConectividadeBase with _$Conectividade {
  static final instancia = Conectividade._();

  Conectividade._() {
    verificar();
  }

  factory Conectividade() => instancia;

  static Future<void> inicializar() async {
    await Conectividade().verificar();
  }
}

abstract class _ConectividadeBase with Store {
  /// Verdadeiro se na última chamada de [verificar] o dispositivo estava conectado a internete.
  @readonly
  bool _conectado = false;

  Completer<bool> _verificando = Completer<bool>()..complete(false);

  /// {@template Conectividade.verificar}
  /// Verifica, assincronamente, se o dispositivo está conectado a internete.
  /// {@endtemplate}
  @action
  Future<bool> verificar() async {
    // Garantir que verificações desnecessárias não sejam feitas.
    if (!_verificando.isCompleted) return _verificando.future;

    _verificando = Completer<bool>();
    bool estado = _conectado;

    try {
      final enderecos = await InternetAddress.lookup('google.com');
      if (enderecos.isNotEmpty && enderecos.first.rawAddress.isNotEmpty) {
        estado = true;
      } else {
        estado = false;
      }
    } on SocketException catch (_) {
      estado = false;
    }

    if (estado != _conectado) _conectado = estado;
    if (!_verificando.isCompleted) _verificando.complete(estado);

    return _conectado;
  }
}

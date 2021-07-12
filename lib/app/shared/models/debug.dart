import 'dart:core' as core;

/// Rotinas para serem executadas apenas se não estiver na versão de lançamento.
/// Todas as rotinas retornam `true` para que possam ser usadas dentro de um assert, pois
/// este é removido na versão de lançamento.
///
/// Exemplo:
/// ```dart
///    assert(Debug.rotina);
/// ```
abstract class Debug {
  /// Determina se está sendo executado em um IDE ou em produção.
  static core.bool get inDebugger {
    var inDebugMode = false;
    // assert é removido na produção.
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Executa [callback].
  static core.bool call(core.Function callback) {
    // assert's são removidos na versão de lançamento.
    assert(() {
      callback();
      return true;
    }());
    return true;
  }

  /// Imprime [object] no console.
  /// Se [afixo] não for vazio, será repetido cinco vezes antes de [object.toString], e até
  /// a string atinja o tamanho [length], será repetido após.
  static core.bool print(
    core.Object? object, [
    core.String afixo = "",
    core.int length = 60,
  ]) {
    assert(
      call(() {
        core.String text = object.toString();
        if (afixo.isNotEmpty) {
          text = line(afixo, 5) +
              " " +
              text +
              " " +
              line(afixo, length - 7 - text.length);
        }
        core.print(text);
      }),
    );
    return true;
  }

  /// Retorna uma String com [length] [caracter].
  static core.String line([core.String caracter = "=", core.int length = 60]) {
    core.String text = "";
    assert(
      call(() {
        //if (length <= 0) return;
        for (var i = 0; i < length; i++) text += caracter;
      }),
    );
    return text;
  }

  /// Imprime no console uma String com [length] [caracter].
  static core.bool printLine([
    core.String caracter = "=",
    core.int length = 60,
  ]) {
    assert(print(line(caracter, length)));
    return true;
  }

  /// Imprime [object] no console entre dois [printLine].
  static core.bool printBetweenLine(
    core.Object? object, [
    core.String afixo = "*",
    core.String caracter = "=",
    core.int length = 60,
  ]) {
    assert(printLine(caracter, length));
    assert(print(object, afixo, length));
    assert(printLine(caracter, length));
    return true;
  }
}

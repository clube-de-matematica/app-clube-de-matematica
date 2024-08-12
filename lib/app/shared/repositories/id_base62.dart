import 'dart:math' as math;

import '../models/exceptions/my_exception.dart';

/// Classe responsável pelas operações relacionadas aos ID's dos clubes.
abstract class IdBase62 {
  /// Uma string com a sequência (em ordem crescente) de símbolos usados na codificação para
  /// a base 62.
  static const String kDictionary =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  /// Um inteiro com os milisegundos do objeto [DateTime] da ultima chamada de [generateId].
  static int _lastTime = 0;

  /// Um inteiro com os milisegundos do objeto [DateTime] da ultima chamada de [generateId].
  static int get lastTime => _lastTime;

  /// O sufíxo da ultima chamada de [generateId].
  static String _lastSuffix = kDictionary[0] + kDictionary[0];

  /// Retorna um ID base 62 aleatório de comprimento [length].
  static String randon([int length = 10]) {
    final random = math.Random.secure();
    String id = '';
    while (0 < length--) {
      id += kDictionary[random.nextInt(62)];
    }
    return id;
  }

  /// Retorna um ID com o comprimento atualmente usado pelos clubes.
  static String getIdClube() => randon(6);

  /// Retorna um sufíxo base 62 aleatório de comprimento 2.
  static String _getSuffix([int length = 2]) => randon(length);

  /// Gera, assincronamente, um ID de dez caracteres, em base 62, onde os oito primeiro caracteres correspondem
  /// a um carimbo de data/hora e os demais a um sufixo aleatório.
  ///
  /// Para garantir a ordem cronológica dos ID's gerados, caso mais de um ID seja gerado no
  /// mesmo [DateTime.millisecondsSinceEpoch], os ID's subsequentes terão o sufíxo igual ao
  /// do ID anterior incrementado em uma unidade.
  static String generateId() {
    int now = DateTime.now().toUtc().millisecondsSinceEpoch;
    String newSuffix = next(_lastSuffix);

    if (now == _lastTime) {
      // Se não for possível incrementar o último sufixo mantendo o comprimento.
      if (newSuffix.length > _lastSuffix.length) {
        newSuffix = _getSuffix();
        now++;
      }
    } else {
      newSuffix = _getSuffix();
    }
    // O carimbo de data e hora corresponderá aos oito primeiros dígitos.
    String id = encode(now, 8);

    _lastTime = now;
    _lastSuffix = newSuffix;

    return '$id$newSuffix';
  }

  /// Retorna o objeto [DateTime] (UTC) associado aos oito primeiros caracteres de [idBase62].
  static DateTime toDateTime(String idBase62) {
    final miliseconds = decode(idBase62.substring(0, 8));
    return DateTime.fromMillisecondsSinceEpoch(miliseconds, isUtc: true);
  }

  /// A string subsequente à [base62].
  static String next(String base62) {
    final chars = base62.split('');
    int i;
    for (i = chars.length - 1; i >= 0 && chars[i] == kDictionary[61]; i--) {
      chars[i] = kDictionary[0];
    }
    if (i < 0) {
      return kDictionary[1] + chars.join();
    } else {
      var newIndex = kDictionary.indexOf(chars[i]) + 1;
      chars[i] = kDictionary[newIndex];
      return chars.join();
    }
  }

  /// Retorna uma string de tamanho [numChars] com a converção de [value] para base 62
  /// usando os símbolos de [kDictionary].
  ///
  /// Se [value] for maior que o valor máximo suportado para o tamanho fornecido, que
  /// corresponde à [numChars]'ésima potência de 62, uma exceção será lançada.
  static String encode(int value, int numChars) {
    final chars = [
      for (int i = numChars - 1; i >= 0; i -= 1)
        () {
          final indexSymbol = (value % 62).toInt();
          final symbol = kDictionary[indexSymbol];
          value = (value ~/ 62);
          return symbol;
        }()
    ];
    if (value != 0) {
      throw MyException(
        'Falha na codificação para a base 62.',
        causeError:
            'O valor $value não pode ser convertido para base 62 de tamanho $numChars. '
            'O valor máximo para uma string base 62 de tamanho $numChars é '
            '${math.pow(62, numChars) - 1}.',
        originClass: 'Base62',
        originField: 'encode()',
      );
    }
    final result = chars.reversed.join();
    return result;
  }

  /// Retorna um [num] que é a converção de [base62] para base 10 usando os símbolos
  /// de [kDictionary].
  ///
  /// Por conta da implementação para a web, o comprimento máximo aceito para [base62] é
  /// de 8 caracteres, pois 62^9 supera 2^53, valor máximo para os 53 bits de precisão de
  /// inteiro.
  ///
  /// Quando for necessário ultrapassar essas limitações, esse código deve ser alterado para
  /// utilizar o tipo [BigInt]. No entanto, esse tipo deve ser usado com cuidado, pois ele
  /// geralmente resulta em códigos significativamente maiores e mais lentos.
  static int decode(String base62) {
    if (base62.length > 8) {
      throw MyException(
        'Falha na decodificação para a base 10.',
        causeError: 'O valor "$base62" não pode ser convertido para base 10. '
            'O tamanho máximo suportado para que uma string base 62 possa ser decodificada '
            'em base 10 é de 8 caracteres por conta da limitação de 53 bits de precisão de '
            'inteiro para a plataforma web.',
        originClass: 'Base62',
        originField: 'decode()',
      );
    }
    int result = 0;
    for (var i = 0; i < base62.length; i++) {
      final char = base62[i];
      final valueChar = kDictionary.indexOf(char);
      final exp = base62.length - 1 - i;
      result += (valueChar * math.pow(62, exp).toInt());
    }
    return result;
  }
}

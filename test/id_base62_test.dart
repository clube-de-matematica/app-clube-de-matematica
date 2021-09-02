import 'dart:convert';
import 'dart:math' as math;

import 'package:clubedematematica/app/shared/repositories/id_base62.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testes para IdBase62:', () {
    test(
      'A codificação de 62^8-1 deve ser "zzzzzzzz".',
      () {
        final valueBase10 = math.pow(62, 8).toInt() - 1;
        final valueBase62 = List.filled(8, IdBase62.kDictionary[61]).join();
        expect(IdBase62.encode(valueBase10, 8), equals(valueBase62));
      },
    );

    test(
      'A decodificação de "zzzzzzzz" deve ser 62^8-1.',
      () {
        final valueBase10 = math.pow(62, 8).toInt() - 1;
        final valueBase62 = List.filled(8, IdBase62.kDictionary[61]).join();
        expect(IdBase62.decode(valueBase62), equals(valueBase10));
      },
    );

    test(
      'A decodificação da codificação de um valor deve ser o próprio valor.',
      () {
        final random = math.Random.secure();
        final valueBase10 = (random.nextDouble() * math.pow(62, 8)) ~/ 1;
        final valueBase62 = IdBase62.encode(valueBase10, 8);
        expect(IdBase62.decode(valueBase62), equals(valueBase10));
      },
    );

    test(
      'O sucessor da codificação de um valor deve ser a codificação do sucessor desse valor.',
      () {
        final random = math.Random.secure();
        final valueBase10 = ((random.nextDouble() * math.pow(62, 8)) ~/ 1) - 1;
        final valueBase62 = IdBase62.encode(valueBase10, 8);
        expect(IdBase62.next(valueBase62),
            equals(IdBase62.encode(valueBase10 + 1, 8)));
      },
    );

    test(
      'O retorno de toDateTime() deve ser igual ao DateTime usado por generateId().',
      () {
        final id = IdBase62.generateId();
        final dateTime = DateTime.fromMillisecondsSinceEpoch(IdBase62.lastTime);
        expect(IdBase62.toDateTime(id), equals(dateTime));
      },
    );

    test(
      'O retorno de toDateTime() de um ID deve ser maior ou igual ao retorno desse método '
      'para outro ID anteriormente gerado.',
      () {
        final id1 = IdBase62.generateId();
        final id2 = IdBase62.generateId();
        expect(
          IdBase62.toDateTime(id2).millisecondsSinceEpoch,
          greaterThanOrEqualTo(IdBase62.toDateTime(id1).millisecondsSinceEpoch),
        );
      },
    );
  });
}

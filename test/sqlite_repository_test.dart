import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'mocks.dart';

typedef _DbAction = Future<void> Function(Transaction txn);

void main() {
  setUp(() {
    // Executado antes de cada teste
  });

  // Inicializar o Flutter.
  WidgetsFlutterBinding.ensureInitialized();

  final auth = MockAuthRepository();
/* 
  test('MyUnitTest', () async {
    assert(auth.connected);
    final repo = _TestingSqliteRepository(auth);
    repo.actions.add((txn) => repo.createTbAssuntos(txn));
    var db = await repo.db;
    repo.

    // Listar o nome das entidades criadas no banco de dados.
    final result = await db.query(
      'sqlite_master',
      where: 'type = ?',
      whereArgs: ['table'],
    );
    final list = result.map((row) => row['name'] as String).toList();
    expect(list.isNotEmpty, equals(true));
    expect(list.contains(repo.pathAssuntos), equals(true));
  });
 */
}

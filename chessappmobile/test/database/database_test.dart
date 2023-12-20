

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:chessappmobile/database/database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Test de l''initialisation de la base de données', () async {

    final testPath = join(await getDatabasesPath(), 'chess_database.db');

    DatabaseHandler databaseHandler = DatabaseHandler();
    await databaseHandler.initDb();
    expect(databaseHandler.database, isNotNull);
    await databaseHandler.database?.transaction((txn) async {
      List<String> tables = await txn.query('sqlite_master', where: 'type = ?', whereArgs: ['table']).then(
              (tables) => List<String>.from(tables.map((table) => table['name'] as String)));
      expect(tables.contains('Utilisateur'), true);
      expect(tables.contains('Role'), true);
      expect(tables.contains('Joueur'), true);
    });

    await databaseHandler.database?.close();
    await deleteDatabase(testPath);
  });
}

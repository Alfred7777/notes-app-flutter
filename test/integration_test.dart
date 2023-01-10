import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('insertNote', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    var database = await openDatabase(
      inMemoryDatabasePath, 
      version: 1, 
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, state INTEGER)');
      }
    );

    await database.transaction((transaction) async {
      int _ = await transaction.rawInsert(
        'INSERT INTO notes(title, content, date, state) VALUES("Test Title", "Test Content", "2023-01-01 00:00", 1)',
      );
    });

    var result = await database.rawQuery('SELECT * FROM notes');

    expect(result, [
      {
        'id': 1, 
        'title': 'Test Title',
        'content': 'Test Content',
        'date': '2023-01-01 00:00',
        'state': 1,
      }
    ]);

    await database.close();
  });
}

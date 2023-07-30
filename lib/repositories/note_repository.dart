import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes_app/models/note.dart';

class NoteRepository {
  final _dateFormatter = DateFormat("yyyy-MM-dd").add_Hm();
  
  Future<Database> _loadDatabase() async {
    String databasePath = '${await getDatabasesPath()}note.db';
    Database database = await openDatabase(
      databasePath, 
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, state INT(1))',
        );
      },
    );

    return database;
  }

  Future<List<Note>> getNotes(String textFilter, String dateFilter, bool stateFilter) async {
    Database database = await _loadDatabase();
    List<Map<String, dynamic>> notes = [];
    int state = stateFilter ? 1 : 0;

    notes = await database.rawQuery(
      'SELECT * FROM notes WHERE (title LIKE "%$textFilter%" OR content LIKE "%$textFilter%") AND date LIKE "%$dateFilter%" AND state = $state',
    );

    return List<Note>.from(notes.map((note) => Note.fromJson(note)));
  }

  Future<void> createNote(String title, String content) async {
    Database database = await _loadDatabase();

    String date = _dateFormatter.format(DateTime.now());
    int state = 0;

    await database.transaction((transaction) async {
      int _ = await transaction.rawInsert(
        'INSERT INTO notes(title, content, date, state) VALUES("$title", "$content", "$date", $state)',
      );
    });
  }

  Future<void> editNote(int noteID, String newTitle, String newContent) async {
    Database database = await _loadDatabase();

    int _ = await database.rawUpdate(
      'UPDATE notes SET title = "$newTitle", content = "$newContent" WHERE id = $noteID',
    );
  }

  Future<void> archiveNote(int noteID) async {
    Database database = await _loadDatabase();

    int _ = await database.rawUpdate(
      'UPDATE notes SET state = 1 WHERE id = $noteID',
    );
  }
}

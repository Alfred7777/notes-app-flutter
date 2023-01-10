import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class NoteRepository {
  final _dateFormatter = DateFormat("yyyy-MM-dd").add_Hm();
  
  Future<Database> _loadDatabase() async {
    String databasePath = '${await getDatabasesPath()}note.db';
    Database database = await openDatabase(
      databasePath, 
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, state INTEGER)',
        );
      },
    );

    return database;
  }

  Future<List<Note>> getNotes(String textFilter, String dateFilter, int stateFilter) async {
    Database database = await _loadDatabase();
    List<Map<String, dynamic>> notes = [];

    if (stateFilter > 0) {
      notes = await database.rawQuery(
        'SELECT * FROM notes WHERE (title LIKE "%$textFilter%" OR content LIKE "%$textFilter%") AND date LIKE "%$dateFilter%" AND state = $stateFilter',
      );
    } else {
      notes = await database.rawQuery(
        'SELECT * FROM notes WHERE (title LIKE "%$textFilter%" OR content LIKE "%$textFilter%") AND date LIKE "%$dateFilter%"',
      );
    }

    return List<Note>.from(notes.map((note) => Note.fromJson(note)));
  }

  Future<void> createNote(String title, String content) async {
    Database database = await _loadDatabase();

    String date = _dateFormatter.format(DateTime.now());
    int state = 1;

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
      'UPDATE notes SET state = 2 WHERE id = $noteID',
    );
  }
}

class Note extends Equatable {
  final int id;
  final String title;
  final String content;
  final String creationDate;
  final int state;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.creationDate,
    required this.state,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      creationDate: json['date'],
      state: json['state'],
    );
  }

  @override
  List<Object> get props => [id, title, content, creationDate, state];
}
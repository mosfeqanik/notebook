import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:KeepNote/models/notebook.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'notebook.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE note(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,content TEXT, date TEXT)"
          "");
    });
  }

  Future<int> addNote(NoteBook noteBook) async {
    final db = await initDatabase();
    return db.insert('note', noteBook.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<NoteBook>> fetchNoteList() async {
    final db = await initDatabase();

    final maps = await db.query('note');

    return List.generate(maps.length, (index) {
      return NoteBook(
        id: maps[index]['id'],
        title: maps[index]['title'],
        content: maps[index]['content'],
        date: maps[index]['date'],
      );
    });
  }

  Future<int> deleteNote(int id) async {
    final db = await initDatabase();
    return await db.delete('note', where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateNote(NoteBook noteBook) async {
    final db = await initDatabase();
    return await db.update('note', noteBook.toMap(),
        where: "id = ?", whereArgs: [noteBook.id]);
  }
  Future<int> deleteTable() async {
    final db = await initDatabase();
    return await db.delete('note');
  }
}

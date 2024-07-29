import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBase {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _createDatabase();
    return _database;
  }

  Future<Database> _createDatabase() async {
    final path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT NOT NULL,
        priority INTEGER NOT NULL,
        is_done INTEGER NOT NULL
        )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    await db?.insert('todos', task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db!.query('todos');
  }

  Future<void> updateTask(Map<String, dynamic> task) async {
    final db = await database;
    await db!.update(
      'todos',
      task,
      where: 'id = ?',
      whereArgs: [task['id']],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db!.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

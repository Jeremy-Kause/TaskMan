import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'data_dummy.dart';
import 'tables/category_table.dart';
import 'tables/event_table.dart';
import 'tables/habit_log_table.dart';
import 'tables/habit_table.dart';
import 'tables/task_table.dart';

class SqliteHelper {
  static const String _databaseName = 'taskman.db';
  static const int _databaseVersion = 2;

  static final SqliteHelper instance = SqliteHelper._init();

  static Database? _database;

  SqliteHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // ponytail: categories first (FK dependency) lalu seed data dummy terpusat
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(CategoryTable.createTable);
    await db.execute(TaskTable.createTable);
    await db.execute(EventTable.createTable);
    await db.execute(HabitTable.createTable);
    await db.execute(HabitLogTable.createTable);

    // Otomatis seed data dummy saat DB pertama kali dibuat
    await DataDummy.seed(db);
  }

  /// Memastikan data dummy terisi jika tabel masih kosong
  Future<void> seedIfEmpty() async {
    final db = await database;
    final taskCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${TaskTable.tableName}'),
    ) ?? 0;

    if (taskCount == 0) {
      await DataDummy.seed(db);
    }
  }

  Future<String> getDatabasePath() async {
    final databasePath = await getDatabasesPath();
    return join(databasePath, _databaseName);
  }

  Future<void> close() async {
    final db = _database;

    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

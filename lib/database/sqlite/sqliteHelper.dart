import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ==================== [DUMMY DATA - TESTING ONLY] ====================
// Hapus atau comment baris import ini jika tidak lagi butuh dummy data
import 'dummy_data.dart';
// =====================================================================
import 'tables/category_table.dart';
import 'tables/event_table.dart';
import 'tables/habit_log_table.dart';
import 'tables/habit_table.dart';
import 'tables/task_table.dart';

class SqliteHelper {
  static const String _databaseName = 'taskman.db';
  static const int _databaseVersion = 2; // ponytail: bumped for ERD v1.1

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

  // ponytail: categories first (FK dependency), lalu isi dummy data untuk testing UI
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(CategoryTable.createTable);
    await db.execute(TaskTable.createTable);
    await db.execute(EventTable.createTable);
    await db.execute(HabitTable.createTable);
    await db.execute(HabitLogTable.createTable);

    // ==================== [DUMMY DATA - TESTING ONLY] ====================
    // Hapus atau comment baris berikut untuk menonaktifkan isi data dummy otomatis
    await DummyData.seed(db);
    // =====================================================================
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

import '../database/sqlite/sqliteHelper.dart';
import '../database/sqlite/tables/habit_table.dart';
import '../models/habit.dart';

class HabitDAO {
  final _db = SqliteHelper.instance;
  static const _t = HabitTable.tableName;

  // CREATE
  Future<int> insert(Habit habit) async {
    final db = await _db.database;
    return db.insert(_t, habit.toMap());
  }

  // READ
  Future<Habit?> getById(int id) async {
    final db = await _db.database;
    final rows = await db.query(_t, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Habit.fromMap(rows.first);
  }

  Future<List<Habit>> getAll() async {
    final db = await _db.database;
    final rows = await db.query(_t, orderBy: 'name ASC');
    return rows.map(Habit.fromMap).toList();
  }

  Future<List<Habit>> getActive() async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'isActive = 1', orderBy: 'name ASC');
    return rows.map(Habit.fromMap).toList();
  }

  Future<List<Habit>> getInactive() async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'isActive = 0', orderBy: 'name ASC');
    return rows.map(Habit.fromMap).toList();
  }

  // UPDATE
  Future<int> update(Habit habit) async {
    final db = await _db.database;
    return db.update(_t, habit.toMap(), where: 'id = ?', whereArgs: [habit.id]);
  }

  // DELETE
  Future<int> delete(int id) async {
    final db = await _db.database;
    return db.delete(_t, where: 'id = ?', whereArgs: [id]);
  }
}

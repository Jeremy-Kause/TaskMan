import '../database/sqlite/sqliteHelper.dart';
import '../database/sqlite/tabels/task_table.dart';
import '../models/task.dart';

class TaskDAO {
  final _db = SqliteHelper.instance;
  static const _t = TaskTable.tableName;

  // CREATE
  Future<int> insert(Task task) async {
    final db = await _db.database;
    return db.insert(_t, task.toMap());
  }

  // READ
  Future<Task?> getById(int id) async {
    final db = await _db.database;
    final rows = await db.query(_t, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Task.fromMap(rows.first);
  }

  Future<List<Task>> getAll() async {
    final db = await _db.database;
    final rows = await db.query(_t, orderBy: 'deadline ASC');
    return rows.map(Task.fromMap).toList();
  }

  // UPDATE
  Future<int> update(Task task) async {
    final db = await _db.database;
    return db.update(_t, task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  // DELETE
  Future<int> delete(int id) async {
    final db = await _db.database;
    return db.delete(_t, where: 'id = ?', whereArgs: [id]);
  }

  // --- Date-range queries ---

  Future<List<Task>> getThisDay() =>
      _queryByRange(_today(), _today().add(const Duration(days: 1)));

  Future<List<Task>> getThisWeek() {
    final now = _today();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return _queryByRange(monday, monday.add(const Duration(days: 7)));
  }

  Future<List<Task>> getThisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month);
    final end = DateTime(now.year, now.month + 1); // ponytail: Dart handles month overflow
    return _queryByRange(start, end);
  }

  Future<List<Task>> getPending() async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'isComplite = 0', orderBy: 'deadline ASC');
    return rows.map(Task.fromMap).toList();
  }

  Future<List<Task>> getCompleted() async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'isComplite = 1', orderBy: 'completedAt DESC');
    return rows.map(Task.fromMap).toList();
  }

  Future<List<Task>> getOverdue() => _queryOverdue();

  // --- Helpers ---

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<List<Task>> _queryByRange(DateTime from, DateTime to) async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'deadline >= ? AND deadline < ?',
        whereArgs: [from.toIso8601String(), to.toIso8601String()],
        orderBy: 'deadline ASC');
    return rows.map(Task.fromMap).toList();
  }

  Future<List<Task>> _queryOverdue() async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'deadline < ? AND isComplite = 0',
        whereArgs: [_today().toIso8601String()],
        orderBy: 'deadline ASC');
    return rows.map(Task.fromMap).toList();
  }
}
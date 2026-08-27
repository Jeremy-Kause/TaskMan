import '../database/sqlite/sqlite_helper.dart';
import '../database/sqlite/tables/habit_log_table.dart';
import '../models/habit_log.dart';

class HabitLogDAO {
  final _db = SqliteHelper.instance;
  static const _t = HabitLogTable.tableName;

  // CREATE — check-in habit hari ini
  Future<int> checkIn(int habitId, {DateTime? date}) async {
    final db = await _db.database;
    final d = date ?? _today();
    return db.insert(_t, {
      'habitId': habitId,
      'checkInDate': DateTime(d.year, d.month, d.day).toIso8601String(),
      'isDone': 1,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // READ
  Future<List<HabitLog>> getByHabitId(int habitId) async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'habitId = ?', whereArgs: [habitId],
        orderBy: 'checkInDate DESC');
    return rows.map(HabitLog.fromMap).toList();
  }

  Future<bool> isCheckedInToday(int habitId) async {
    final db = await _db.database;
    final today = _today().toIso8601String();
    final rows = await db.query(_t,
        where: 'habitId = ? AND checkInDate = ?',
        whereArgs: [habitId, today]);
    return rows.isNotEmpty;
  }

  Future<List<HabitLog>> getLogsByDate(DateTime date) async {
    final db = await _db.database;
    final d = DateTime(date.year, date.month, date.day).toIso8601String();
    final rows = await db.query(_t,
        where: 'checkInDate = ?', whereArgs: [d]);
    return rows.map(HabitLog.fromMap).toList();
  }

  // ponytail: streak = count consecutive days backwards from today
  Future<int> getStreak(int habitId) async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'habitId = ?', whereArgs: [habitId],
        orderBy: 'checkInDate DESC');

    if (rows.isEmpty) return 0;

    int streak = 0;
    var expected = _today();

    for (final row in rows) {
      final date = DateTime.parse(row['checkInDate'] as String);
      final d = DateTime(date.year, date.month, date.day);
      if (d == expected) {
        streak++;
        expected = expected.subtract(const Duration(days: 1));
      } else if (d.isBefore(expected)) {
        break;
      }
    }
    return streak;
  }

  // DELETE — undo check-in
  Future<int> uncheckIn(int habitId, {DateTime? date}) async {
    final db = await _db.database;
    final d = date ?? _today();
    return db.delete(_t,
        where: 'habitId = ? AND checkInDate = ?',
        whereArgs: [habitId, DateTime(d.year, d.month, d.day).toIso8601String()]);
  }

  Future<int> deleteByHabitId(int habitId) async {
    final db = await _db.database;
    return db.delete(_t, where: 'habitId = ?', whereArgs: [habitId]);
  }

  // --- Helper ---

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }
}

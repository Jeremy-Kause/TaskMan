import '../database/sqlite/sqlite_helper.dart';
import '../database/sqlite/tables/event_table.dart';
import '../models/event.dart';

class EventDAO {
  final _db = SqliteHelper.instance;
  static const _t = EventTable.tableName;

  // CREATE
  Future<int> insert(Event event) async {
    final db = await _db.database;
    return db.insert(_t, event.toMap());
  }

  // READ
  Future<Event?> getById(int id) async {
    final db = await _db.database;
    final rows = await db.query(_t, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Event.fromMap(rows.first);
  }

  Future<List<Event>> getAll() async {
    final db = await _db.database;
    final rows = await db.query(_t, orderBy: 'startTime ASC');
    return rows.map(Event.fromMap).toList();
  }

  // UPDATE
  Future<int> update(Event event) async {
    final db = await _db.database;
    return db.update(_t, event.toMap(), where: 'id = ?', whereArgs: [event.id]);
  }

  // DELETE
  Future<int> delete(int id) async {
    final db = await _db.database;
    return db.delete(_t, where: 'id = ?', whereArgs: [id]);
  }

  // --- Date-range queries ---

  Future<List<Event>> getThisDay() =>
      _queryByRange(_today(), _today().add(const Duration(days: 1)));

  Future<List<Event>> getThisWeek() {
    final now = _today();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return _queryByRange(monday, monday.add(const Duration(days: 7)));
  }

  Future<List<Event>> getThisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month);
    final end = DateTime(now.year, now.month + 1); // ponytail: Dart handles month overflow
    return _queryByRange(start, end);
  }

  Future<List<Event>> getByDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    return _queryByRange(start, start.add(const Duration(days: 1)));
  }

  Future<List<Event>> getUpcoming() async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'startTime >= ?',
        whereArgs: [_today().toIso8601String()],
        orderBy: 'startTime ASC');
    return rows.map(Event.fromMap).toList();
  }

  Future<List<Event>> getRecurring() async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'isRecurring = 1',
        orderBy: 'startTime ASC');
    return rows.map(Event.fromMap).toList();
  }

  // --- Helpers ---

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Future<List<Event>> _queryByRange(DateTime from, DateTime to) async {
    final db = await _db.database;
    final rows = await db.query(_t,
        where: 'startTime >= ? AND startTime < ?',
        whereArgs: [from.toIso8601String(), to.toIso8601String()],
        orderBy: 'startTime ASC');
    return rows.map(Event.fromMap).toList();
  }
}

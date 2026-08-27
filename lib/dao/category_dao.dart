import '../database/sqlite/sqlite_helper.dart';
import '../database/sqlite/tables/category_table.dart';
import '../models/category.dart';

class CategoryDAO {
  final _db = SqliteHelper.instance;
  static const _t = CategoryTable.tableName;

  // CREATE
  Future<int> insert(Category category) async {
    final db = await _db.database;
    return db.insert(_t, category.toMap());
  }

  // READ
  Future<Category?> getById(int id) async {
    final db = await _db.database;
    final rows = await db.query(_t, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Category.fromMap(rows.first);
  }

  Future<List<Category>> getAll() async {
    final db = await _db.database;
    final rows = await db.query(_t, orderBy: 'name ASC');
    return rows.map(Category.fromMap).toList();
  }

  // UPDATE
  Future<int> update(Category category) async {
    final db = await _db.database;
    return db.update(_t, category.toMap(), where: 'id = ?', whereArgs: [category.id]);
  }

  // DELETE
  Future<int> delete(int id) async {
    final db = await _db.database;
    return db.delete(_t, where: 'id = ?', whereArgs: [id]);
  }
}

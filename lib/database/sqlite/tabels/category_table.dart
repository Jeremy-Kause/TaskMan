class CategoryTable {
  static const String tableName = 'categories';

  static const String createTable = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      colorHex TEXT NOT NULL,
      createdAt TEXT,
      updateAt TEXT NOT NULL
    )
  ''';
}

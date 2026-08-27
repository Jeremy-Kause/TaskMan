class HabitTable {
  static const String tableName = 'habits';

  static const String createTable = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryId INTEGER,
      name TEXT NOT NULL,
      frequency TEXT NOT NULL DEFAULT 'daily',
      targetCount INTEGER NOT NULL DEFAULT 1,
      reminderTime TEXT,
      isActive INTEGER NOT NULL DEFAULT 1,
      createdAt TEXT,
      updateAt TEXT NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE SET NULL
    )
  ''';
}

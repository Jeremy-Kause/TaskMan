class TaskTable {
  static const String tableName = 'tasks';

  static const String createTable = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryId INTEGER,
      title TEXT NOT NULL,
      description TEXT,
      type TEXT NOT NULL CHECK (type IN ('daily', 'weekly')),
      priority INTEGER NOT NULL DEFAULT 2,
      deadline TEXT NOT NULL,
      isComplite INTEGER NOT NULL DEFAULT 0,
      completedAt TEXT,
      createdAt TEXT,
      updateAt TEXT NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE SET NULL
    )
  ''';
}

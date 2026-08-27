class EventTable {
  static const String tableName = 'events';

  static const String createTable = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryId INTEGER,
      title TEXT NOT NULL,
      description TEXT,
      startTime TEXT NOT NULL,
      endTime TEXT,
      isRecurring INTEGER NOT NULL DEFAULT 0,
      recurrenceRule TEXT,
      location TEXT,
      type TEXT,
      createdAt TEXT,
      updateAt TEXT NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE SET NULL
    )
  ''';
}

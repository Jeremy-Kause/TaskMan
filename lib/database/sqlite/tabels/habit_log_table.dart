class HabitLogTable {
  static const String tableName = 'habit_logs';

  static const String createTable = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      habitId INTEGER NOT NULL,
      checkInDate TEXT NOT NULL,
      isDone INTEGER NOT NULL DEFAULT 1,
      createdAt TEXT,
      FOREIGN KEY (habitId) REFERENCES habits(id) ON DELETE CASCADE,
      UNIQUE (habitId, checkInDate)
    )
  ''';
}

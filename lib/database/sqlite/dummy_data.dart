import 'package:sqflite/sqflite.dart';
import 'tables/category_table.dart';
import 'tables/event_table.dart';
import 'tables/habit_log_table.dart';
import 'tables/habit_table.dart';
import 'tables/task_table.dart';

class DummyData {
  // ponytail: seed data sederhana untuk testing UI langsung tanpa input manual
  static Future<void> seed(Database db) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 1. Categories
    await db.insert(CategoryTable.tableName, {
      'id': 1,
      'name': 'Kuliah',
      'colorHex': '#0EA5E9', // Biru langit
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });
    await db.insert(CategoryTable.tableName, {
      'id': 2,
      'name': 'Pribadi',
      'colorHex': '#8B5CF6', // Ungu
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });
    await db.insert(CategoryTable.tableName, {
      'id': 3,
      'name': 'Kerja',
      'colorHex': '#F59E0B', // Oranye
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });
    await db.insert(CategoryTable.tableName, {
      'id': 4,
      'name': 'Kesehatan',
      'colorHex': '#10B981', // Hijau
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });

    // 2. Tasks
    await db.insert(TaskTable.tableName, {
      'categoryId': 1,
      'title': 'Tugas AI - Klasifikasi Dataset',
      'description': 'Implementasi algoritma decision tree di Python',
      'type': 'weekly',
      'priority': 3, // Tinggi
      'deadline': now.add(const Duration(hours: 5)).toIso8601String(),
      'isComplite': 0,
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });
    await db.insert(TaskTable.tableName, {
      'categoryId': 2,
      'title': 'Beli buku catatan & alat tulis',
      'description': 'Di toko buku depan kampus',
      'type': 'daily',
      'priority': 1, // Rendah
      'deadline': now.add(const Duration(hours: 8)).toIso8601String(),
      'isComplite': 0,
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });
    await db.insert(TaskTable.tableName, {
      'categoryId': 3,
      'title': 'Review arsitektur & PR Taksman',
      'description': 'Cek integrasi SQLite dan Provider',
      'type': 'daily',
      'priority': 2, // Sedang
      'deadline': now.subtract(const Duration(hours: 2)).toIso8601String(),
      'isComplite': 1,
      'completedAt': now.subtract(const Duration(hours: 3)).toIso8601String(),
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });

    // 3. Events
    await db.insert(EventTable.tableName, {
      'categoryId': 1,
      'title': 'Kuliah Pemrograman Mobile',
      'description': 'Materi State Management Provider',
      'startTime': today.add(const Duration(hours: 8)).toIso8601String(),
      'endTime': today.add(const Duration(hours: 10)).toIso8601String(),
      'isRecurring': 1,
      'recurrenceRule': 'FREQ=WEEKLY;BYDAY=TH',
      'location': 'Lab Komputer 3',
      'type': 'kuliah',
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });
    await db.insert(EventTable.tableName, {
      'categoryId': 3,
      'title': 'Rapat Proyek Tim',
      'description': 'Sinkronisasi progress mingguan',
      'startTime': today.add(const Duration(hours: 14)).toIso8601String(),
      'endTime': today.add(const Duration(hours: 15, minutes: 30)).toIso8601String(),
      'isRecurring': 0,
      'location': 'Google Meet',
      'type': 'meeting',
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });

    // 4. Habits
    await db.insert(HabitTable.tableName, {
      'id': 1,
      'categoryId': 4,
      'name': 'Minum Air 2 Liter',
      'frequency': 'daily',
      'targetCount': 1,
      'reminderTime': '07:00',
      'isActive': 1,
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });
    await db.insert(HabitTable.tableName, {
      'id': 2,
      'categoryId': 2,
      'name': 'Membaca Buku 15 Menit',
      'frequency': 'daily',
      'targetCount': 1,
      'reminderTime': '20:00',
      'isActive': 1,
      'createdAt': now.toIso8601String(),
      'updateAt': now.toIso8601String(),
    });

    // 5. Habit Logs (Check-in hari ini)
    await db.insert(HabitLogTable.tableName, {
      'habitId': 1,
      'checkInDate': today.toIso8601String(),
      'isDone': 1,
      'createdAt': now.toIso8601String(),
    });
  }
}

import 'package:sqflite/sqflite.dart';
import 'tables/category_table.dart';
import 'tables/event_table.dart';
import 'tables/habit_log_table.dart';
import 'tables/habit_table.dart';
import 'tables/task_table.dart';

class DataDummy {
  // ponytail: satu method seeder terpusat yang mengisi semua tabel dengan relasi konsisten
  static Future<void> seed(Database db) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nowIso = now.toIso8601String();

    // 1. Categories
    await db.insert(CategoryTable.tableName, {
      'id': 1,
      'name': 'Kuliah',
      'colorHex': '#0EA5E9',
      'createdAt': nowIso,
      'updateAt': nowIso,
    });
    await db.insert(CategoryTable.tableName, {
      'id': 2,
      'name': 'Kerja',
      'colorHex': '#10B981',
      'createdAt': nowIso,
      'updateAt': nowIso,
    });
    await db.insert(CategoryTable.tableName, {
      'id': 3,
      'name': 'Pribadi',
      'colorHex': '#8B5CF6',
      'createdAt': nowIso,
      'updateAt': nowIso,
    });
    await db.insert(CategoryTable.tableName, {
      'id': 4,
      'name': 'Organisasi',
      'colorHex': '#F59E0B',
      'createdAt': nowIso,
      'updateAt': nowIso,
    });

    // 2. Tasks
    final tasks = [
      {
        'categoryId': 1,
        'title': 'Kerjakan laporan akhir',
        'description': 'Laporan bab 1 sampai 4 untuk praktikum mobile',
        'type': 'daily',
        'priority': 3,
        'deadline': now.add(const Duration(hours: 3)).toIso8601String(),
        'isComplite': 0,
        'completedAt': null,
        'createdAt': nowIso,
        'updateAt': nowIso,
      },
      {
        'categoryId': 3,
        'title': 'Baca buku Bab 5',
        'description': 'Minimal 20 halaman',
        'type': 'daily',
        'priority': 2,
        'deadline': now.add(const Duration(hours: 6)).toIso8601String(),
        'isComplite': 0,
        'completedAt': null,
        'createdAt': nowIso,
        'updateAt': nowIso,
      },
      {
        'categoryId': 2,
        'title': 'Review PR teman',
        'description': 'Cek pull request modul autentikasi',
        'type': 'daily',
        'priority': 1,
        'deadline': now.add(const Duration(days: 1, hours: 2)).toIso8601String(),
        'isComplite': 0,
        'completedAt': null,
        'createdAt': nowIso,
        'updateAt': nowIso,
      },
      {
        'categoryId': 1,
        'title': 'Presentasi kelompok',
        'description': 'Siapkan slide materi sistem terdistribusi',
        'type': 'weekly',
        'priority': 3,
        'deadline': now.add(const Duration(days: 2)).toIso8601String(),
        'isComplite': 0,
        'completedAt': null,
        'createdAt': nowIso,
        'updateAt': nowIso,
      },
      {
        'categoryId': 1,
        'title': 'Kumpulkan tugas matematika',
        'description': 'Format PDF kirim ke portal e-learning',
        'type': 'weekly',
        'priority': 2,
        'deadline': now.add(const Duration(days: 3)).toIso8601String(),
        'isComplite': 0,
        'completedAt': null,
        'createdAt': nowIso,
        'updateAt': nowIso,
      },
      {
        'categoryId': 1,
        'title': 'Beli bahan praktikum',
        'description': 'Beli sensor dan kabel jumper',
        'type': 'daily',
        'priority': 1,
        'deadline': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'isComplite': 1,
        'completedAt': now.subtract(const Duration(hours: 3)).toIso8601String(),
        'createdAt': nowIso,
        'updateAt': nowIso,
      },
    ];

    for (final task in tasks) {
      await db.insert(TaskTable.tableName, task);
    }

    // 3. Events
    final events = [
      {
        'categoryId': 1,
        'title': 'Kuliah Pemrograman Mobile',
        'description': 'Materi State Management & SQLite',
        'startTime': DateTime(now.year, now.month, now.day, 8, 0).toIso8601String(),
        'endTime': DateTime(now.year, now.month, now.day, 10, 30).toIso8601String(),
        'isRecurring': 0,
        'location': 'Lab Komputer 3',
        'type': 'Kuliah',
        'createdAt': nowIso,
        'updateAt': nowIso,
      },
      {
        'categoryId': 2,
        'title': 'Meeting Proyek Kelompok',
        'description': 'Diskusi arsitektur dan pembagian task',
        'startTime': DateTime(now.year, now.month, now.day, 13, 0).toIso8601String(),
        'endTime': DateTime(now.year, now.month, now.day, 14, 30).toIso8601String(),
        'isRecurring': 0,
        'location': 'Ruang Diskusi Perpustakaan',
        'type': 'Meeting',
        'createdAt': nowIso,
        'updateAt': nowIso,
      },
      {
        'categoryId': 4,
        'title': 'Rapat Organisasi HIMA',
        'description': 'Persiapan acara seminar nasional',
        'startTime': DateTime(now.year, now.month, now.day + 1, 15, 0).toIso8601String(),
        'endTime': DateTime(now.year, now.month, now.day + 1, 17, 0).toIso8601String(),
        'isRecurring': 0,
        'location': 'Gedung Serbaguna',
        'type': 'Organisasi',
        'createdAt': nowIso,
        'updateAt': nowIso,
      },
      {
        'categoryId': 3,
        'title': 'Workshop Flutter Advanced',
        'description': 'Deep dive animasi dan performance',
        'startTime': DateTime(now.year, now.month, now.day + 3, 9, 0).toIso8601String(),
        'endTime': DateTime(now.year, now.month, now.day + 3, 12, 0).toIso8601String(),
        'isRecurring': 0,
        'location': 'Auditorium Utama',
        'type': 'Workshop',
        'createdAt': nowIso,
        'updateAt': nowIso,
      },
    ];

    for (final event in events) {
      await db.insert(EventTable.tableName, event);
    }

    // 4. Habits
    final habits = [
      {'id': 1, 'name': 'Olahraga pagi', 'frequency': 'daily', 'targetCount': 1, 'isActive': 1},
      {'id': 2, 'name': 'Membaca buku', 'frequency': 'daily', 'targetCount': 1, 'isActive': 1},
      {'id': 3, 'name': 'Minum 8 gelas air', 'frequency': 'daily', 'targetCount': 1, 'isActive': 1},
      {'id': 4, 'name': 'Meditasi 10 menit', 'frequency': 'daily', 'targetCount': 1, 'isActive': 1},
      {'id': 5, 'name': 'Journaling', 'frequency': 'daily', 'targetCount': 1, 'isActive': 1},
    ];

    for (final habit in habits) {
      await db.insert(HabitTable.tableName, {
        'id': habit['id'],
        'categoryId': 3,
        'name': habit['name'],
        'frequency': habit['frequency'],
        'targetCount': habit['targetCount'],
        'isActive': habit['isActive'],
        'createdAt': nowIso,
        'updateAt': nowIso,
      });
    }

    // 5. Habit Logs (untuk mengisi streak dan log 7 hari terakhir)
    // Habit 1: Olahraga (log 5 hari berturut-turut kecuali hari ini & kemarin)
    for (int i = 2; i <= 6; i++) {
      final date = today.subtract(Duration(days: i));
      await db.insert(HabitLogTable.tableName, {
        'habitId': 1,
        'checkInDate': DateTime(date.year, date.month, date.day).toIso8601String(),
        'isDone': 1,
        'createdAt': nowIso,
      });
    }

    // Habit 2: Membaca buku (log 7 hari berturut-turut termasuk hari ini)
    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      await db.insert(HabitLogTable.tableName, {
        'habitId': 2,
        'checkInDate': DateTime(date.year, date.month, date.day).toIso8601String(),
        'isDone': 1,
        'createdAt': nowIso,
      });
    }

    // Habit 3: Minum air (log hari ini dan 2 hari sebelumnya)
    for (int i = 0; i < 3; i++) {
      final date = today.subtract(Duration(days: i));
      await db.insert(HabitLogTable.tableName, {
        'habitId': 3,
        'checkInDate': DateTime(date.year, date.month, date.day).toIso8601String(),
        'isDone': 1,
        'createdAt': nowIso,
      });
    }

    // Habit 4: Meditasi (hanya 1 hari)
    final medDate = today.subtract(const Duration(days: 4));
    await db.insert(HabitLogTable.tableName, {
      'habitId': 4,
      'checkInDate': DateTime(medDate.year, medDate.month, medDate.day).toIso8601String(),
      'isDone': 1,
      'createdAt': nowIso,
    });

    // Habit 5: Journaling (log 21 hari berturut-turut)
    for (int i = 0; i < 21; i++) {
      final date = today.subtract(Duration(days: i));
      await db.insert(HabitLogTable.tableName, {
        'habitId': 5,
        'checkInDate': DateTime(date.year, date.month, date.day).toIso8601String(),
        'isDone': 1,
        'createdAt': nowIso,
      });
    }
  }
}

import 'package:flutter/foundation.dart';
import '../dao/habit_dao.dart';
import '../dao/habit_log_dao.dart';
import '../models/habit.dart';

class HabitItemState {
  final Habit habit;
  final int streak;
  final List<bool> weekLog; // Sen - Min (7 hari)
  final bool checkedToday;

  HabitItemState({
    required this.habit,
    required this.streak,
    required this.weekLog,
    required this.checkedToday,
  });
}

class HabitProvider extends ChangeNotifier {
  final HabitDAO _habitDAO = HabitDAO();
  final HabitLogDAO _logDAO = HabitLogDAO();

  List<HabitItemState> _items = [];
  bool _isLoading = false;

  List<HabitItemState> get items => _items;
  bool get isLoading => _isLoading;

  int get checkedTodayCount => _items.where((i) => i.checkedToday).length;
  int get bestStreak => _items.fold<int>(0, (max, i) => i.streak > max ? i.streak : max);

  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();

    try {
      final habits = await _habitDAO.getActive();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final monday = today.subtract(Duration(days: today.weekday - 1));

      final List<HabitItemState> states = [];

      for (final habit in habits) {
        if (habit.id == null) continue;
        final habitId = habit.id!;

        final streak = await _logDAO.getStreak(habitId);
        final checkedToday = await _logDAO.isCheckedInToday(habitId);

        // Ambil riwayat 7 hari minggu berjalan (Sen - Min)
        final logs = await _logDAO.getByHabitId(habitId);
        final logDates = logs.map((l) => DateTime(l.checkInDate.year, l.checkInDate.month, l.checkInDate.day)).toSet();

        final List<bool> weekLog = List.generate(7, (dayIndex) {
          final targetDay = monday.add(Duration(days: dayIndex));
          return logDates.contains(targetDay);
        });

        states.add(HabitItemState(
          habit: habit,
          streak: streak,
          weekLog: weekLog,
          checkedToday: checkedToday,
        ));
      }

      _items = states;
    } catch (e) {
      debugPrint('Error fetching habits: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleCheckIn(int habitId) async {
    final isChecked = await _logDAO.isCheckedInToday(habitId);
    if (isChecked) {
      await _logDAO.uncheckIn(habitId);
    } else {
      await _logDAO.checkIn(habitId);
    }
    await fetchAll();
  }

  Future<void> addHabit(Habit habit) async {
    await _habitDAO.insert(habit);
    await fetchAll();
  }

  Future<void> deleteHabit(int id) async {
    await _logDAO.deleteByHabitId(id);
    await _habitDAO.delete(id);
    await fetchAll();
  }
}

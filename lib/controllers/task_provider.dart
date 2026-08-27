import 'package:flutter/foundation.dart';
import '../dao/task_dao.dart';
import '../models/task.dart';
import '../utils/date_helper.dart';

class TaskProvider extends ChangeNotifier {
  final TaskDAO _dao = TaskDAO();

  List<Task> _tasks = [];
  bool _isLoading = false;
  int _filterIndex = 0;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  int get filterIndex => _filterIndex;

  List<Task> get filteredTasks {
    final now = DateTime.now();
    switch (_filterIndex) {
      case 1: // Hari Ini
        return _tasks.where((t) => !t.isComplite && DateHelper.isToday(t.deadline)).toList();
      case 2: // Minggu Ini
        final endOfWeek = now.add(Duration(days: 7 - now.weekday));
        return _tasks.where((t) => !t.isComplite && t.deadline.isBefore(endOfWeek)).toList();
      case 3: // Selesai
        return _tasks.where((t) => t.isComplite).toList();
      default: // Semua (belum selesai)
        return _tasks.where((t) => !t.isComplite).toList();
    }
  }

  int get completedCount => _tasks.where((t) => t.isComplite).length;
  int get totalCount => _tasks.length;

  void setFilter(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _dao.getAll();
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    await _dao.insert(task);
    await fetchAll();
  }

  Future<void> updateTask(Task task) async {
    await _dao.update(task);
    await fetchAll();
  }

  Future<void> deleteTask(int id) async {
    await _dao.delete(id);
    await fetchAll();
  }

  Future<void> toggleComplete(Task task) async {
    task.isComplite = !task.isComplite;
    task.completedAt = task.isComplite ? DateTime.now() : null;
    task.updateAt = DateTime.now();
    await _dao.update(task);
    await fetchAll();
  }
}

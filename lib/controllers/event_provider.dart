import 'package:flutter/foundation.dart';
import '../dao/event_dao.dart';
import '../models/event.dart';
import '../utils/date_helper.dart';

class EventProvider extends ChangeNotifier {
  final EventDAO _dao = EventDAO();

  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  List<Event> getEventsForDate(DateTime date) {
    return _events.where((e) => DateHelper.isSameDay(e.startTime, date)).toList();
  }

  bool hasEventOnDate(DateTime date) {
    return _events.any((e) => DateHelper.isSameDay(e.startTime, date));
  }

  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = await _dao.getAll();
    } catch (e) {
      debugPrint('Error fetching events: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(Event event) async {
    await _dao.insert(event);
    await fetchAll();
  }

  Future<void> updateEvent(Event event) async {
    await _dao.update(event);
    await fetchAll();
  }

  Future<void> deleteEvent(int id) async {
    await _dao.delete(id);
    await fetchAll();
  }
}

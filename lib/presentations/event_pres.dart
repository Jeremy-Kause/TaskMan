import 'package:flutter/material.dart';
import '../components/event_card.dart';
import '../components/expandable_calendar.dart';
import '../controllers/event_provider.dart';
import '../models/event.dart';
import '../utils/app_theme.dart';
import '../utils/date_helper.dart';

class CalenderPres extends StatefulWidget {
  const CalenderPres({super.key});

  @override
  State<CalenderPres> createState() => _CalenderPresState();
}

class _CalenderPresState extends State<CalenderPres> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  bool _isWeekView = false;
  final EventProvider _provider = EventProvider();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
    _provider.fetchAll();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  void _prev() {
    setState(() {
      if (_isWeekView) {
        _selectedDate = _selectedDate.subtract(const Duration(days: 7));
        _focusedMonth = DateTime(_selectedDate.year, _selectedDate.month);
      } else {
        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
      }
    });
  }

  void _next() {
    setState(() {
      if (_isWeekView) {
        _selectedDate = _selectedDate.add(const Duration(days: 7));
        _focusedMonth = DateTime(_selectedDate.year, _selectedDate.month);
      } else {
        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      }
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _focusedMonth = DateTime(now.year, now.month);
      _selectedDate = DateTime(now.year, now.month, now.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _provider,
      builder: (context, _) {
        final dayEvents = _provider.getEventsForDate(_selectedDate);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Kalender'),
            actions: [
              IconButton(
                tooltip: 'Hari Ini',
                icon: const Icon(Icons.today_outlined),
                onPressed: _goToToday,
              ),
            ],
          ),
          // ponytail: satu NotificationListener menangani kedua arah scroll
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                final delta = notification.scrollDelta ?? 0;
                if (delta > 3 && !_isWeekView) {
                  setState(() => _isWeekView = true);
                }
              }
              if (notification is OverscrollNotification) {
                if (notification.overscroll < -3 && _isWeekView) {
                  setState(() => _isWeekView = false);
                }
              }
              return false;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpandableCalendar(
                    focusedMonth: _focusedMonth,
                    selectedDate: _selectedDate,
                    isWeekView: _isWeekView,
                    hasEventOnDate: _provider.hasEventOnDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                        _focusedMonth = DateTime(date.year, date.month);
                      });
                    },
                    onPrev: _prev,
                    onNext: _next,
                    onToggleWeekView: (val) => setState(() => _isWeekView = val),
                  ),
                  const SizedBox(height: 20),
                  _buildSelectedDateInfo(),
                  const SizedBox(height: 16),
                  _buildEventsList(dayEvents),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {}, // TODO: form tambah event
            backgroundColor: AppColors.event,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildSelectedDateInfo() {
    final isSelectedToday = DateHelper.isToday(_selectedDate);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_month, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSelectedToday ? 'Hari Ini' : 'Tanggal Terpilih',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateHelper.formatFull(_selectedDate),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList(List<Event> dayEvents) {
    if (dayEvents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Column(
            children: [
              Icon(Icons.event_busy, size: 44, color: AppColors.textMuted.withValues(alpha: 0.5)),
              const SizedBox(height: 8),
              const Text(
                'Tidak ada jadwal kegiatan pada tanggal ini',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 72),
      itemCount: dayEvents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (_, i) => EventCard(event: dayEvents[i]),
    );
  }
}

import 'package:flutter/material.dart';
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

  final List<String> _weekDays = const ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
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
      // - scroll ke bawah (jari geser ke atas) di area MANAPUN → collapse ke 1 minggu
      // - overscroll di atas (sudah mentok atas, jari tarik ke bawah lagi) → expand ke 1 bulan
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
              // Card Kalender (Dapat langsung di-swipe ke atas untuk collapse, dan swipe ke bawah untuk expand)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragEnd: (details) {
                  final velocity = details.primaryVelocity ?? 0;
                  if (velocity < -100 && !_isWeekView) {
                    // Swipe ke Atas pada area Kalender -> Collapse ke 1 minggu
                    setState(() => _isWeekView = true);
                  } else if (velocity > 100 && _isWeekView) {
                    // Swipe ke Bawah pada area Kalender -> Expand ke 1 bulan
                    setState(() => _isWeekView = false);
                  }
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        _buildWeekDayHeader(),
                        const SizedBox(height: 8),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOutCubic,
                          alignment: Alignment.topCenter,
                          child: _isWeekView ? _buildWeekRow() : _buildDaysGrid(),
                        ),
                        const SizedBox(height: 6),
                        _buildSwipeHandle(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Info Tanggal Terpilih
              _buildSelectedDateInfo(),
              const SizedBox(height: 16),
              // Placeholder Kegiatan
              _buildScheduleListPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final monthName = DateHelper.formatFull(_focusedMonth).split(' ')[2];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$monthName ${_focusedMonth.year}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _prev,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _next,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekDayHeader() {
    return Row(
      children: _weekDays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeekRow() {
    final monday = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)
        .subtract(Duration(days: _selectedDate.weekday - 1));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: List.generate(7, (index) {
          final date = monday.add(Duration(days: index));
          return Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: _buildDateItem(date),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDaysGrid() {
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday;
    final leadingEmpty = firstWeekday - 1;
    final totalCells = leadingEmpty + daysInMonth;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        if (index < leadingEmpty) {
          return const SizedBox.shrink();
        }
        final dayNumber = index - leadingEmpty + 1;
        final date = DateTime(_focusedMonth.year, _focusedMonth.month, dayNumber);
        return _buildDateItem(date);
      },
    );
  }

  Widget _buildDateItem(DateTime date) {
    final isToday = DateHelper.isToday(date);
    final isSelected = DateHelper.isSameDay(date, _selectedDate);

    Color? bgColor;
    Color textColor = AppColors.textPrimary;

    if (isSelected) {
      bgColor = AppColors.primary;
      textColor = Colors.white;
    } else if (isToday) {
      textColor = AppColors.primary;
    }

    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () {
        setState(() {
          _selectedDate = date;
          _focusedMonth = DateTime(date.year, date.month);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: (isToday || isSelected) ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeHandle() {
    return InkWell(
      onTap: () => setState(() => _isWeekView = !_isWeekView),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
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

  Widget _buildScheduleListPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(Icons.event_note, size: 48, color: AppColors.textMuted.withOpacity(0.4)),
            const SizedBox(height: 8),
            const Text(
              'Belum ada kegiatan pada tanggal ini',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

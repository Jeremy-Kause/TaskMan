import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/date_helper.dart';

// ponytail: komponen kalender expandable (bulan/minggu) terisolasi
class ExpandableCalendar extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final bool isWeekView;
  final bool Function(DateTime date) hasEventOnDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<bool> onToggleWeekView;

  static const List<String> _weekDays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  const ExpandableCalendar({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.isWeekView,
    required this.hasEventOnDate,
    required this.onDateSelected,
    required this.onPrev,
    required this.onNext,
    required this.onToggleWeekView,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < -100 && !isWeekView) {
          onToggleWeekView(true);
        } else if (velocity > 100 && isWeekView) {
          onToggleWeekView(false);
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
                child: isWeekView ? _buildWeekRow() : _buildDaysGrid(),
              ),
              const SizedBox(height: 6),
              _buildSwipeHandle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final monthName = DateHelper.formatFull(focusedMonth).split(' ')[2];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$monthName ${focusedMonth.year}',
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
              onPressed: onPrev,
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: onNext,
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
    final monday = DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
        .subtract(Duration(days: selectedDate.weekday - 1));

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
    final daysInMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(focusedMonth.year, focusedMonth.month, 1).weekday;
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
        final date = DateTime(focusedMonth.year, focusedMonth.month, dayNumber);
        return _buildDateItem(date);
      },
    );
  }

  Widget _buildDateItem(DateTime date) {
    final isToday = DateHelper.isToday(date);
    final isSelected = DateHelper.isSameDay(date, selectedDate);
    final hasEvent = hasEventOnDate(date);

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
      onTap: () => onDateSelected(date),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: (isToday || isSelected) ? FontWeight.bold : FontWeight.normal,
                color: textColor,
              ),
            ),
            if (hasEvent)
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : AppColors.event,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeHandle() {
    return InkWell(
      onTap: () => onToggleWeekView(!isWeekView),
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
}

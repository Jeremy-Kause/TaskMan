import 'package:flutter/material.dart';
import '../controllers/habit_provider.dart';
import '../utils/app_theme.dart';

class HabitPres extends StatefulWidget {
  const HabitPres({super.key});

  @override
  State<HabitPres> createState() => _HabitPresState();
}

class _HabitPresState extends State<HabitPres> {
  final HabitProvider _provider = HabitProvider();
  static const _weekDays = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];

  @override
  void initState() {
    super.initState();
    _provider.fetchAll();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _provider,
      builder: (context, _) {
        final items = _provider.items;
        final checkedCount = _provider.checkedTodayCount;
        final bestStreak = _provider.bestStreak;

        return Scaffold(
          appBar: AppBar(title: const Text('Kebiasaan')),
          body: _provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Row(
                        children: [
                          _buildStatChip(Icons.check_circle_outline, '$checkedCount/${items.length}', 'Hari ini'),
                          const SizedBox(width: 12),
                          _buildStatChip(Icons.local_fire_department, '$bestStreak Hari', 'Streak terbaik'),
                        ],
                      ),
                    ),
                    // Habit list
                    Expanded(
                      child: items.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.repeat, size: 48, color: AppColors.textMuted.withValues(alpha: 0.5)),
                                  const SizedBox(height: 8),
                                  const Text('Belum ada kebiasaan', style: TextStyle(color: AppColors.textMuted)),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                              itemCount: items.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                              itemBuilder: (_, i) => _buildHabitCard(items[i]),
                            ),
                    ),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {}, // TODO: buka form tambah habit
            backgroundColor: AppColors.habit,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.habit.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.habit.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.habit),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCard(HabitItemState item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.habit.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  // Streak
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: item.streak > 0 ? Colors.orange : AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.streak > 0 ? '${item.streak} hari berturut' : 'Belum ada streak',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: item.streak > 0 ? FontWeight.w600 : FontWeight.normal,
                          color: item.streak > 0 ? Colors.orange.shade700 : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 7-day dots
                  Row(
                    children: List.generate(7, (d) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Column(
                        children: [
                          Text(_weekDays[d], style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                          const SizedBox(height: 2),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: item.weekLog[d] ? AppColors.habit : AppColors.surfaceVariant,
                              border: Border.all(
                                color: item.weekLog[d] ? AppColors.habit : AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: item.weekLog[d]
                                ? const Icon(Icons.check, size: 10, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ),
            // Check-in button
            GestureDetector(
              onTap: () {
                if (item.habit.id != null) {
                  _provider.toggleCheckIn(item.habit.id!);
                }
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.checkedToday ? AppColors.habit : AppColors.surfaceVariant,
                  border: Border.all(
                    color: item.checkedToday ? AppColors.habit : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Icon(
                  item.checkedToday ? Icons.check : Icons.add,
                  color: item.checkedToday ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../controllers/task_provider.dart';
import '../models/task.dart';
import '../utils/app_theme.dart';
import '../utils/date_helper.dart';

class TaskPres extends StatefulWidget {
  const TaskPres({super.key});

  @override
  State<TaskPres> createState() => _TaskPresState();
}

class _TaskPresState extends State<TaskPres> {
  final TaskProvider _provider = TaskProvider();
  final _filters = const ['Semua', 'Hari Ini', 'Minggu Ini', 'Selesai'];

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
        final filtered = _provider.filteredTasks;
        final doneCount = _provider.completedCount;
        final totalCount = _provider.totalCount;

        return Scaffold(
          appBar: AppBar(title: const Text('Tugas')),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary progress bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$doneCount dari $totalCount tugas selesai',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: totalCount == 0 ? 0 : doneCount / totalCount,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(AppColors.success),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Filter chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filters.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => ChoiceChip(
                    label: Text(_filters[i]),
                    selected: _provider.filterIndex == i,
                    onSelected: (_) => _provider.setFilter(i),
                    selectedColor: AppColors.primaryLight,
                    labelStyle: TextStyle(
                      color: _provider.filterIndex == i ? AppColors.primaryDark : AppColors.textSecondary,
                      fontWeight: _provider.filterIndex == i ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                    side: BorderSide(
                      color: _provider.filterIndex == i ? AppColors.primary : AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Task list
              Expanded(
                child: _provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.task_alt, size: 48, color: AppColors.textMuted.withValues(alpha: 0.5)),
                                const SizedBox(height: 8),
                                const Text('Tidak ada tugas', style: TextStyle(color: AppColors.textMuted)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (_, i) => _buildTaskCard(filtered[i]),
                          ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {}, // TODO: buka modal tambah tugas
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    final isOverdue = !task.isComplite && task.deadline.isBefore(DateTime.now());
    final priorityColor = switch (task.priority) {
      3 => AppColors.priorityHigh,
      1 => AppColors.priorityLow,
      _ => AppColors.priorityMedium,
    };

    return Card(
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Garis prioritas kiri
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            // Checkbox
            Checkbox(
              value: task.isComplite,
              onChanged: (_) => _provider.toggleComplete(task),
              shape: const CircleBorder(),
              activeColor: AppColors.success,
            ),
            // Konten
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        decoration: task.isComplite ? TextDecoration.lineThrough : null,
                        color: task.isComplite ? AppColors.textMuted : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: isOverdue ? AppColors.priorityHigh : AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateHelper.formatDeadline(task.deadline),
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue ? AppColors.priorityHigh : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: priorityColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            switch (task.priority) { 3 => 'Tinggi', 1 => 'Rendah', _ => 'Sedang' },
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: priorityColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

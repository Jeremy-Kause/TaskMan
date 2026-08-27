import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ProfilePres extends StatelessWidget {
  const ProfilePres({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryLight,
                      child: const Icon(Icons.person, size: 36, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jeremy Zadrimman Kause',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'zekkey24@gmail.com',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Statistik Produktivitas
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Statistik Produktivitas',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard('Tugas Selesai', '24', Icons.check_circle, AppColors.success),
                const SizedBox(width: 12),
                _buildStatCard('Streak Terbaik', '21 Hari', Icons.local_fire_department, Colors.orange),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard('Total Habit Aktif', '5', Icons.repeat, AppColors.habit),
                const SizedBox(width: 12),
                _buildStatCard('Event Bulan Ini', '12', Icons.calendar_month, AppColors.event),
              ],
            ),
            const SizedBox(height: 20),
            // Menu Pengaturan
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                    title: const Text('Notifikasi & Reminder', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),
                  ListTile(
                    leading: const Icon(Icons.backup_outlined, color: AppColors.primary),
                    title: const Text('Ekspor / Backup Data', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppColors.primary),
                    title: const Text('Tentang Taskman v1.0.0', style: TextStyle(fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

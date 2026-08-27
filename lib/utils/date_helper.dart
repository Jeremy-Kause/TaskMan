class DateHelper {
  static const List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  static const List<String> _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];

  // ponytail: formatter mandiri tanpa wajib package eksternal
  /// Contoh: "Rabu, 26 Agustus 2026"
  static String formatFull(DateTime date) {
    final dayName = _days[date.weekday - 1];
    final monthName = _months[date.month - 1];
    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  /// Contoh: "26 Agu 2026"
  static String formatShort(DateTime date) {
    return '${date.day} ${_shortMonths[date.month - 1]} ${date.year}';
  }

  /// Contoh: "26 Agu"
  static String formatDayMonth(DateTime date) {
    return '${date.day} ${_shortMonths[date.month - 1]}';
  }

  /// Contoh: "14:30"
  static String formatTime(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Contoh: "Hari ini", "Besok", "Kemarin", atau "26 Agu"
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final diff = target.difference(today).inDays;
    if (diff == 0) return 'Hari ini';
    if (diff == 1) return 'Besok';
    if (diff == -1) return 'Kemarin';
    return formatDayMonth(date);
  }

  /// Format Deadline lengkap: "Hari ini, 14:30" atau "28 Agu, 10:00"
  static String formatDeadline(DateTime date) {
    return '${formatRelative(date)}, ${formatTime(date)}';
  }

  /// Cek apakah tanggal adalah hari ini
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Cek apakah dua tanggal berada di hari yang sama
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Awal hari (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Akhir hari (23:59:59)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}

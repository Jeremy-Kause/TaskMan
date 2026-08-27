class HabitLog {
  final int? id;
  final int habitId;
  DateTime checkInDate;
  bool isDone;
  final DateTime? createdAt;

  HabitLog({
    this.id,
    required this.habitId,
    required this.checkInDate,
    this.isDone = true,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'checkInDate': checkInDate.toIso8601String(),
      'isDone': isDone ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory HabitLog.fromMap(Map<String, dynamic> map) {
    return HabitLog(
      id: map['id'],
      habitId: map['habitId'],
      checkInDate: DateTime.parse(map['checkInDate']),
      isDone: map['isDone'] == 1,
      createdAt: map['createdAt'] == null ? null : DateTime.parse(map['createdAt']),
    );
  }
}

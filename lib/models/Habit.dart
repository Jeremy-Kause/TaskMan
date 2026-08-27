class Habit {
  final int? id;
  int? categoryId;
  String name;
  String frequency;
  int targetCount;
  String? reminderTime;
  bool isActive;
  final DateTime? createdAt;
  DateTime updateAt;

  Habit({
    this.id,
    this.categoryId,
    required this.name,
    this.frequency = 'daily',
    this.targetCount = 1,
    this.reminderTime,
    this.isActive = true,
    this.createdAt,
    required this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'frequency': frequency,
      'targetCount': targetCount,
      'reminderTime': reminderTime,
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      categoryId: map['categoryId'],
      name: map['name'],
      frequency: map['frequency'] ?? 'daily',
      targetCount: map['targetCount'] ?? 1,
      reminderTime: map['reminderTime'],
      isActive: map['isActive'] == 1,
      createdAt: map['createdAt'] == null ? null : DateTime.parse(map['createdAt']),
      updateAt: DateTime.parse(map['updateAt']),
    );
  }
}

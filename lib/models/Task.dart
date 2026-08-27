class Task {
  final int? id;
  int? categoryId;
  String title;
  String? description;
  String type;
  int priority;
  DateTime deadline;
  bool isComplite;
  final DateTime? createdAt;
  DateTime? completedAt;
  DateTime updateAt;

  Task({
    this.id,
    this.categoryId,
    required this.title,
    this.description,
    required this.type,
    this.priority = 2,
    required this.deadline,
    this.isComplite = false,
    this.createdAt,
    this.completedAt,
    required this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'type': type,
      'priority': priority,
      'deadline': deadline.toIso8601String(),
      'isComplite': isComplite ? 1 : 0,
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      categoryId: map['categoryId'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      priority: map['priority'] is int ? map['priority'] : int.tryParse(map['priority'].toString()) ?? 2,
      deadline: DateTime.parse(map['deadline']),
      isComplite: map['isComplite'] == 1,
      createdAt: map['createdAt'] == null ? null : DateTime.parse(map['createdAt']),
      completedAt: map['completedAt'] == null ? null : DateTime.parse(map['completedAt']),
      updateAt: DateTime.parse(map['updateAt']),
    );
  }
}

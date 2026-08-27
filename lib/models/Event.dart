class Event {
  final int? id;
  int? categoryId;
  String title;
  String? description;
  DateTime startTime;
  DateTime? endTime;
  bool isRecurring;
  String? recurrenceRule;
  String? location;
  String? type;
  final DateTime? createdAt;
  DateTime updateAt;

  Event({
    this.id,
    this.categoryId,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
    this.isRecurring = false,
    this.recurrenceRule,
    this.location,
    this.type,
    this.createdAt,
    required this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isRecurring': isRecurring ? 1 : 0,
      'recurrenceRule': recurrenceRule,
      'location': location,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      categoryId: map['categoryId'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] == null ? null : DateTime.parse(map['endTime']),
      isRecurring: map['isRecurring'] == 1,
      recurrenceRule: map['recurrenceRule'],
      location: map['location'],
      type: map['type'],
      createdAt: map['createdAt'] == null ? null : DateTime.parse(map['createdAt']),
      updateAt: DateTime.parse(map['updateAt']),
    );
  }
}

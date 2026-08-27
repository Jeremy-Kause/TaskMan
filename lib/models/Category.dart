class Category {
  final int? id;
  String name;
  String colorHex;
  final DateTime? createdAt;
  DateTime updateAt;

  Category({
    this.id,
    required this.name,
    required this.colorHex,
    this.createdAt,
    required this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
      'createdAt': createdAt?.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      colorHex: map['colorHex'],
      createdAt: map['createdAt'] == null ? null : DateTime.parse(map['createdAt']),
      updateAt: DateTime.parse(map['updateAt']),
    );
  }
}

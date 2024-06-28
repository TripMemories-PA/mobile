class PoiType {
  PoiType({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PoiType.fromJson(Map<String, dynamic> json) {
    return PoiType(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
}

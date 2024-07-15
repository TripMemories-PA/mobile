class Quest {
  const Quest({
    required this.id,
    required this.title,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'],
      title: json['title'],
    );
  }
  final int id;
  final String title;

  Quest copyWith({
    int? id,
    String? title,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }
}

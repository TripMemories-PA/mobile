class CreatePostQuery {
  CreatePostQuery({
    required this.title,
    required this.content,
    this.imageId,
    required this.poiId,
    required this.note,
  });

  factory CreatePostQuery.fromJson(Map<String, dynamic> json) {
    return CreatePostQuery(
      title: json['title'],
      content: json['content'],
      imageId: json['imageId'],
      poiId: json['poiId'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['title'] = title;
    json['content'] = content;
    if (imageId != null) {
      json['imageId'] = imageId;
    }
    json['poiId'] = poiId;
    json['note'] = note;
    return json;
  }

  CreatePostQuery copyWith({
    String? title,
    String? content,
    int? imageId,
    int? poiId,
    double? note,
  }) {
    return CreatePostQuery(
      title: title ?? this.title,
      content: content ?? this.content,
      imageId: imageId ?? this.imageId,
      poiId: poiId ?? this.poiId,
      note: note ?? this.note,
    );
  }

  String title;
  String content;
  int? imageId;
  int poiId;
  double note;
}

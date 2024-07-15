class CreatePostResponse {
  CreatePostResponse({
    required this.createdById,
    required this.poiId,
    required this.content,
    required this.imageId,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) {
    return CreatePostResponse(
      createdById: json['createdById'],
      poiId: json['poiId'],
      content: json['content'],
      imageId: json['imageId'],
      note: double.parse(json['note'].toString()),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      id: json['id'],
    );
  }

  int createdById;
  int poiId;
  String content;
  int imageId;
  double note;
  DateTime createdAt;
  DateTime updatedAt;
  int id;
}

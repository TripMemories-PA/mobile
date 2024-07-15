class PostQuestQueryModel {
  PostQuestQueryModel({
    required this.id,
    required this.title,
  });
  int id;
  String title;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

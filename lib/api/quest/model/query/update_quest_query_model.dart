class UpdateQuestQueryModel {
  UpdateQuestQueryModel({
    required this.title,
    required this.description,
    this.image,
  });
  final String title;
  final String description;
  final String? image;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
    };
  }
}

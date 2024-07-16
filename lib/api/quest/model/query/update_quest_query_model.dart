class UpdateQuestQueryModel {
  UpdateQuestQueryModel({
    required this.title,
  });

  final String title;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }
}

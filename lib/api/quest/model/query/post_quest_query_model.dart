class PostQuestQueryModel {
  const PostQuestQueryModel({
    required this.title,
    required this.label,
    required this.poiId,
    required this.imageId,
  });
  final String title;
  final String label;
  final int poiId;
  final int imageId;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'label': label,
      'poiId': poiId,
      'imageId': imageId,
    };
  }
}

class UpdateMeetQuery {
  UpdateMeetQuery({
    required this.title,
    required this.description,
    required this.id,
  });

  final int id;
  final String title;
  final String description;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

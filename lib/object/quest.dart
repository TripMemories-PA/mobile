import 'uploaded_file.dart';

class Quest {
  const Quest({
    required this.id,
    required this.title,
    this.image,
    this.done = false,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'],
      title: json['title'],
      image: json['image'] != null ? UploadFile.fromJson(json['image']) : null,
      done: json['done'] ?? false,
    );
  }

  final int id;
  final String title;
  final UploadFile? image;
  final bool done;

  Quest copyWith({
    int? id,
    String? title,
    UploadFile? image,
    bool? done,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      done: done ?? this.done,
    );
  }
}

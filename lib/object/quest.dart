import 'uploaded_file.dart';

class Quest {
  const Quest({
    required this.id,
    required this.title,
    this.image,
    this.done = false,
    required this.poiId,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'],
      title: json['title'],
      image: json['image'] != null ? UploadFile.fromJson(json['image']) : null,
      done: json['done'] ?? false,
      poiId: json['poiId'],
    );
  }

  final int id;
  final String title;
  final UploadFile? image;
  final bool done;
  final int poiId;

  Quest copyWith({
    int? id,
    String? title,
    UploadFile? image,
    bool? done,
    int? poiId,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      done: done ?? this.done,
      poiId: poiId ?? this.poiId,
    );
  }
}

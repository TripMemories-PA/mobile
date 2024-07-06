import 'uploaded_file.dart';

class City {
  City({
    required this.id,
    required this.name,
    required this.zipCode,
    required this.coverId,
    required this.cover,
    required this.averageNote,
    required this.postsCount,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      name: json['name'] as String,
      zipCode: json['zipCode'] as String,
      coverId: json['coverId'] as int,
      cover: json['cover'] == null
          ? null
          : UploadFile.fromJson(json['cover'] as Map<String, dynamic>),
      averageNote: json['averageNote'] as num?,
      postsCount: json['postsCount'] as num?,
    );
  }

  int id;
  String name;
  String zipCode;
  int coverId;
  UploadFile? cover;
  num? averageNote;
  num? postsCount;
}

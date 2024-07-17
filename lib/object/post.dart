import 'poi/poi.dart';
import 'profile.dart';
import 'uploaded_file.dart';

class Post {
  Post({
    required this.id,
    required this.poiId,
    required this.title,
    required this.content,
    required this.note,
    this.image,
    this.imageId,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.poi,
    this.isReported,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      poiId: json['poiId'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      note: json['note'] as String,
      image: json['image'] == null
          ? null
          : UploadFile.fromJson(json['image'] as Map<String, dynamic>),
      imageId: json['imageId'] as int?,
      createdBy: Profile.fromJson(json['createdBy'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      likesCount: json['likesCount'] as int,
      commentsCount: json['commentsCount'] as int,
      isLiked: json['isLiked'] as bool,
      poi: Poi.fromJson(json['poi'] as Map<String, dynamic>),
      isReported: json['isReported'] as bool?,
    );
  }

  Post copyWith({
    int? id,
    int? poiId,
    String? title,
    String? content,
    String? note,
    UploadFile? image,
    int? imageId,
    Profile? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    Poi? poi,
    bool? isReported,
  }) {
    return Post(
      id: id ?? this.id,
      poiId: poiId ?? this.poiId,
      title: title ?? this.title,
      content: content ?? this.content,
      note: note ?? this.note,
      image: image ?? this.image,
      imageId: imageId ?? this.imageId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      poi: poi ?? this.poi,
      isReported: isReported ?? this.isReported,
    );
  }

  final int id;
  final int poiId;
  final String title;
  final String content;
  final String note;
  final UploadFile? image;
  final int? imageId;
  final Profile createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final Poi poi;
  final bool? isReported;
}

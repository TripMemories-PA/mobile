import 'profile.dart';

class Comment {
  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.createdBy,
    required this.likesCount,
    required this.isLiked,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      postId: json['postId'] as int,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: Profile.fromJson(json['createdBy'] as Map<String, dynamic>),
      likesCount: json['likesCount'] as int,
      isLiked: json['isLiked'] as bool,
    );
  }

  Comment copyWith({
    int? id,
    int? postId,
    String? content,
    DateTime? createdAt,
    Profile? createdBy,
    int? likesCount,
    bool? isLiked,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  int id;
  int postId;
  String content;
  DateTime createdAt;
  Profile createdBy;
  int likesCount;
  bool isLiked;
}

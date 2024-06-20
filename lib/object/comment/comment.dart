import 'package:freezed_annotation/freezed_annotation.dart';

import '../profile/profile.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@Freezed()
class Comment with _$Comment {
  const factory Comment({
    required int id,
    required int postId,
    required String content,
    DateTime? createdAt,
    required Profile createdBy,
    required int likesCount,
    required bool isLiked,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}

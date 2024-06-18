import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_comment_query.freezed.dart';
part 'post_comment_query.g.dart';

@Freezed()
class PostCommentQuery with _$PostCommentQuery {
  @JsonSerializable(explicitToJson: true)
  const factory PostCommentQuery({
    required String content,
    required int postId,
  }) = _PostCommentQuery;

  factory PostCommentQuery.fromJson(Map<String, dynamic> json) =>
      _$PostCommentQueryFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../object/comment/comment.dart';
import '../../../../meta_object/meta.dart';

part 'get_comment_response.freezed.dart';
part 'get_comment_response.g.dart';

@Freezed()
class CommentResponse with _$CommentResponse {
  const factory CommentResponse({
    required Meta meta,
    required List<Comment> data,
  }) = _CommentResponse;

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseFromJson(json);
}

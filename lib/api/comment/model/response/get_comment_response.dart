import '../../../../object/comment.dart';
import '../../../../object/meta_object.dart';

class CommentResponse {
  CommentResponse({
    required this.meta,
    required this.data,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      meta: MetaObject.fromJson(json['meta']),
      data: List<Comment>.from(json['data'].map((x) => Comment.fromJson(x))),
    );
  }

  CommentResponse copyWith({
    MetaObject? meta,
    List<Comment>? data,
  }) {
    return CommentResponse(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  MetaObject meta;
  List<Comment> data;
}

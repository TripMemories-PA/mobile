import '../../../../object/meta_object.dart';
import '../../../../object/post.dart';

class GetAllPostsResponse {
  GetAllPostsResponse({
    required this.meta,
    required this.data,
  });

  factory GetAllPostsResponse.fromJson(Map<String, dynamic> json) {
    return GetAllPostsResponse(
      meta: MetaObject.fromJson(json['meta']),
      data: List<Post>.from(json['data'].map((x) => Post.fromJson(x))),
    );
  }

  GetAllPostsResponse copyWith({
    MetaObject? meta,
    List<Post>? data,
  }) {
    return GetAllPostsResponse(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  MetaObject meta;
  List<Post> data;
}

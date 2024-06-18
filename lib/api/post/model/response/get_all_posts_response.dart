import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../object/post/post.dart';
import '../../../meta_object/meta.dart';

part 'get_all_posts_response.freezed.dart';
part 'get_all_posts_response.g.dart';

@Freezed()
class GetAllPostsResponse with _$GetAllPostsResponse {
  const factory GetAllPostsResponse({
    required Meta meta,
    required List<Post> data,
  }) = _GetAllPostsResponse;

  factory GetAllPostsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllPostsResponseFromJson(json);
}

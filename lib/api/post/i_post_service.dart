import 'package:image_picker/image_picker.dart';

import '../../object/post/post.dart';
import 'model/query/create_post/create_post_query.dart';
import 'model/query/update_post_query/update_post_query.dart';
import 'model/response/create_post_response/create_post_response.dart';
import 'model/response/get_all_posts_response.dart';

abstract class IPostService {
  Future<CreatePostResponse> createPost({
    required CreatePostQuery query,
  });

  Future<Post> getPostById({
    required int postId,
  });

  Future<GetAllPostsResponse> getPosts({
    required int page,
    required int perPage,
    required int? userId,
  });

  Future<Post> updatePost({
    required UpdatePostQuery query,
  });

  Future<void> deletePost({
    required int postId,
  });

  Future<int> publishImage({
    required XFile image,
  });

  Future<void> likePost({
    required int postId,
  });

  Future<void> dislikePost({
    required int postId,
  });
}

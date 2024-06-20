import '../../api/post/model/response/get_all_posts_response.dart';
import '../../object/post/post.dart';

abstract class IPostRepository {
  Future<Post> getPostById({
    required int postId,
  });

  Future<GetAllPostsResponse> getPosts({
    required int page,
    required int perPage,
    int? userId,
  });

  Future<GetAllPostsResponse> getMyPosts({
    required int page,
    required int perPage,
  });
}

import '../../api/post/model/response/get_all_posts_response.dart';
import '../../object/post.dart';

abstract class IPostRepository {
  Future<Post> getPostById({
    required int postId,
  });

  Future<GetAllPostsResponse> getPosts({
    required int page,
    required int perPage,
    int? userId,
    bool isMyFeed = false,
  });

  Future<GetAllPostsResponse> getMyPosts({
    required int page,
    required int perPage,
  });

  Future<GetAllPostsResponse> getCityPosts({
    required int cityId,
    required int page,
    required int perPage,
  });
}

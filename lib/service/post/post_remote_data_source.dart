import '../../api/post/model/response/get_all_posts_response.dart';
import '../../api/post/post_service.dart';
import '../../object/post.dart';
import '../../repository/post/i_post_repository.dart';

class PostRemoteDataSource extends IPostRepository {
  final PostService _postService = PostService();

  @override
  Future<Post> getPostById({
    required int postId,
  }) async {
    final Post post = await _postService.getPostById(postId: postId);
    return post;
  }

  @override
  Future<GetAllPostsResponse> getPosts({
    required int page,
    required int perPage,
    int? userId,
    bool isMyFeed = false,
  }) async {
    final GetAllPostsResponse posts = await _postService.getPosts(
      page: page,
      perPage: perPage,
      userId: userId,
      isMyFeed: isMyFeed,
    );
    return posts;
  }

  @override
  Future<GetAllPostsResponse> getMyPosts({
    required int page,
    required int perPage,
  }) async {
    final GetAllPostsResponse posts = await _postService.getMyPosts(
      page: page,
      perPage: perPage,
    );
    return posts;
  }

  @override
  Future<GetAllPostsResponse> getCityPosts({
    required int cityId,
    required int page,
    required int perPage,
  }) {
    return _postService.getCityPosts(
      cityId: cityId,
      page: page,
      perPage: perPage,
    );
  }
}

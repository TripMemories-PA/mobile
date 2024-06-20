import '../../api/post/model/response/get_all_posts_response.dart';
import '../../api/post/post_service.dart';
import '../../object/post/post.dart';
import '../../repository/post/i_post_repository.dart';

class PostRemoteDataSource extends IPostRepository {
  final PostService _profileService = PostService();

  @override
  Future<Post> getPostById({
    required int postId,
  }) async {
    final Post post = await _profileService.getPostById(postId: postId);
    return post;
  }

  @override
  Future<GetAllPostsResponse> getPosts({
    required int page,
    required int perPage,
    int? userId,
  }) async {
    final GetAllPostsResponse posts = await _profileService.getPosts(
      page: page,
      perPage: perPage,
      userId: userId,
    );
    return posts;
  }

  @override
  Future<GetAllPostsResponse> getMyPosts({
    required int page,
    required int perPage,
  }) async {
    final GetAllPostsResponse posts = await _profileService.getMyPosts(
      page: page,
      perPage: perPage,
    );
    return posts;
  }
}

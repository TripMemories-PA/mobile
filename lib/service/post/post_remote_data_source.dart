import '../../api/post/model/response/get_all_posts_response.dart';
import '../../api/post/post_service.dart';
import 'post_interface.dart';

class PostRemoteDataSource extends PostDataSourceInterface {
  final PostService _profileService = PostService();

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

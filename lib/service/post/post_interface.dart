import '../../api/post/model/response/get_all_posts_response.dart';

abstract class PostDataSourceInterface {
  Future<GetAllPostsResponse> getPosts({
    required int page,
    required int perPage,
  });

  Future<GetAllPostsResponse> getMyPosts({
    required int page,
    required int perPage,
  });
}

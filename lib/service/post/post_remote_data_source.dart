import '../../api/post/model/response/get_all_posts_response.dart';
import '../../api/profile/profile_service.dart';
import 'post_interface.dart';

class PostRemoteDataSource extends PostDataSourceInterface {
  final ProfileService _profileService = ProfileService();

  @override
  Future<GetAllPostsResponse> getMyPosts({
    required int page,
    required int perPage,
  }) async {
    final GetAllPostsResponse posts =
        await _profileService.getMyPosts(page: page, perPage: perPage);
    return posts;
  }
}

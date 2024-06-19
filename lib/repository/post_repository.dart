import '../api/post/model/response/get_all_posts_response.dart';
import '../service/post/post_remote_data_source.dart';

// TODO(nono): implement the profilelocalDataSource
class PostRepository {
  PostRepository({
    required this.postRemoteDataSource,
    //required this.profilelocalDataSource,
  });

  final PostRemoteDataSource postRemoteDataSource;

  //final ProfileLocalDataSource profilelocalDataSource;

  Future<GetAllPostsResponse> getMyPosts({
    required int page,
    required int perPage,
  }) async {
    return postRemoteDataSource.getMyPosts(
      page: page,
      perPage: perPage,
    );
  }
}

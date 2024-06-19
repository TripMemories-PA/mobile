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

  Future<GetAllPostsResponse> getPosts({
    required int page,
    required int perPage,
    int? userId,
  }) async {
    return postRemoteDataSource.getPosts(
      page: page,
      perPage: perPage,
      userId: userId,
    );
  }
}

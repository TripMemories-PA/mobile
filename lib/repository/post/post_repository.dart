import '../../api/post/model/response/get_all_posts_response.dart';
import '../../object/post/post.dart';
import '../../service/post/post_remote_data_source.dart';
import 'i_post_repository.dart';

// TODO(nono): implement the profilelocalDataSource
class PostRepository implements IPostRepository {
  PostRepository({
    required this.postRemoteDataSource,
    //required this.profilelocalDataSource,
  });

  final PostRemoteDataSource postRemoteDataSource;
  //final ProfileLocalDataSource profilelocalDataSource;

  @override
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

  @override
  Future<GetAllPostsResponse> getMyPosts({
    required int page,
    required int perPage,
    int? userId,
  }) async {
    return postRemoteDataSource.getMyPosts(
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<Post> getPostById({required int postId}) {
    return postRemoteDataSource.getPostById(postId: postId);
  }

  @override
  Future<GetAllPostsResponse> getCityPosts({
    required int cityId,
    required int page,
    required int perPage,
  }) {
    return postRemoteDataSource.getCityPosts(
      cityId: cityId,
      page: page,
      perPage: perPage,
    );
  }
}

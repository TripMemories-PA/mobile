import '../../api/comment/model/response/get_comment_response.dart';
import '../../service/comment/comment_remote_data_source.dart';
import 'i_comment_repository.dart';

// TODO(nono): implement the commentLocalDataSource
class CommentRepository implements ICommentRepository {
  CommentRepository(this._commentRemoteDataSource);

  final CommentRemoteDataSource _commentRemoteDataSource;

  //final ProfileLocalDataSource profilelocalDataSource;

  @override
  Future<CommentResponse> getComments({
    required int page,
    required int perPage,
    required int postId,
  }) async {
    return _commentRemoteDataSource.getComments(
      page: page,
      perPage: perPage,
      postId: postId,
    );
  }
}

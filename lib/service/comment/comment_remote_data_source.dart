import '../../api/comment/comment_service.dart';
import '../../api/comment/model/response/get_comment_response.dart';
import '../../repository/comment/i_comment_repository.dart';

class CommentRemoteDataSource implements ICommentRepository {
  final CommentService _commentService = CommentService();

  @override
  Future<CommentResponse> getComments({
    required int page,
    required int perPage,
    required int postId,
  }) async {
    final CommentResponse posts = await _commentService.getComments(
      page: page,
      perPage: perPage,
      postId: postId,
    );
    return posts;
  }
}

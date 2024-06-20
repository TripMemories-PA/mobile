import '../../api/comment/comment_service.dart';
import '../../api/comment/model/response/get_comment_response/get_comment_response.dart';
import 'comment_interface.dart';

class CommentRemoteDataSource extends CommentDataSourceInterface {
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

import '../../api/comment/model/response/get_comment_response/get_comment_response.dart';

abstract class CommentDataSourceInterface {
  Future<CommentResponse> getComments({
    required int page,
    required int perPage,
    required int postId,
  });
}

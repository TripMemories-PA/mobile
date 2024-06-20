import 'model/query/post_comment_query/post_comment_query.dart';
import 'model/response/get_comment_response/get_comment_response.dart';

abstract class ICommentService {
  Future<void> commentPost({
    required PostCommentQuery query,
  });

  Future<void> deleteComment({
    required int commentId,
  });

  Future<void> likeComment({
    required int commentId,
  });

  Future<void> dislikeComment({
    required int commentId,
  });

  Future<CommentResponse> getComments({
    required int page,
    required int perPage,
    required int postId,
  });
}

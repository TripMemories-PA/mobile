import 'model/query/post_comment_query/post_comment_query.dart';

abstract class ICommentService {
  Future<void> commentPost({
    required PostCommentQuery query,
  });

  Future<void> deleteComment({
    required String commentId,
  });

  Future<void> likeComment({
    required String commentId,
  });

  Future<void> unlikeComment({
    required String commentId,
  });
}

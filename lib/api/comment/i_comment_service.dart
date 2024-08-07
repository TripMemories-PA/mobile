import 'model/query/post_comment_query.dart';

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

  Future<void> reportComment({
    required int commentId,
  });
}

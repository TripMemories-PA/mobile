import '../../api/comment/model/response/get_comment_response/get_comment_response.dart';

abstract class ICommentRepository {
  Future<void> commentPost({
    required int postId,
    required String content,
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

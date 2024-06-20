import '../../api/comment/i_comment_service.dart';
import '../../api/comment/model/query/post_comment_query/post_comment_query.dart';
import '../../api/comment/model/response/get_comment_response/get_comment_response.dart';
import '../../service/comment/comment_remote_data_source.dart';
import 'i_comment_repository.dart';

// TODO(nono): implement the commentLocalDataSource
class CommentRepository implements ICommentRepository {
  CommentRepository(this._commentRemoteDataSource, this._commentService);

  final CommentRemoteDataSource _commentRemoteDataSource;
  final ICommentService _commentService;

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

  @override
  Future<void> commentPost({
    required int postId,
    required String content,
  }) async {
    final PostCommentQuery query =
        PostCommentQuery(postId: postId, content: content);
    await _commentService.commentPost(query: query);
  }

  @override
  Future<void> deleteComment({required int commentId}) async {
    await _commentService.deleteComment(commentId: commentId);
  }

  @override
  Future<void> dislikeComment({required int commentId}) async {
    await _commentService.dislikeComment(commentId: commentId);
  }

  @override
  Future<void> likeComment({required int commentId}) async {
    await _commentService.likeComment(commentId: commentId);
  }
}

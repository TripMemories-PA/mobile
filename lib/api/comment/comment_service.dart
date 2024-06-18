import '../../app.config.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../exception/bad_request_exception.dart';
import 'i_comment_service.dart';
import 'model/query/post_comment_query/post_comment_query.dart';

class CommentService implements ICommentService {
  static const String apiCommentBaseUrl = '${AppConfig.apiUrl}/comments';

  @override
  Future<void> commentPost({required PostCommentQuery query}) async {
    try {
      await DioClient.instance.post(
        apiCommentBaseUrl,
        data: query.toJson(),
      );
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
  }

  @override
  Future<void> deleteComment({required String commentId}) async {
    try {
      await DioClient.instance.delete('$apiCommentBaseUrl/$commentId');
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
  }

  @override
  Future<void> likeComment({
    required String commentId,
  }) async {
    try {
      await DioClient.instance.post('$apiCommentBaseUrl/$commentId/like');
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
  }

  @override
  Future<void> unlikeComment({
    required String commentId,
  }) async {
    try {
      await DioClient.instance.delete('$apiCommentBaseUrl/$commentId/like');
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
  }
}

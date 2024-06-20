import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../exception/bad_request_exception.dart';
import 'i_comment_service.dart';
import 'model/query/post_comment_query/post_comment_query.dart';
import 'model/response/get_comment_response/get_comment_response.dart';

class CommentService implements ICommentService {
  static const String apiCommentBaseUrl = '${AppConfig.apiUrl}/comments';
  static const String apiGetCommentsUrl =
      '${AppConfig.apiUrl}/posts/{POST_ID}/comments';

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
  Future<void> deleteComment({required int commentId}) async {
    try {
      await DioClient.instance.delete('$apiCommentBaseUrl/$commentId');
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
  }

  @override
  Future<void> likeComment({
    required int commentId,
  }) async {
    try {
      await DioClient.instance.post('$apiCommentBaseUrl/$commentId/like');
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
  }

  @override
  Future<void> dislikeComment({
    required int commentId,
  }) async {
    try {
      await DioClient.instance.delete('$apiCommentBaseUrl/$commentId/like');
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
  }

  @override
  Future<CommentResponse> getComments({
    required int page,
    required int perPage,
    required int postId,
  }) async {
    Response response;
    try {
      String url = apiGetCommentsUrl.replaceAll('{POST_ID}', postId.toString());
      url = '$url?page=$page&perPage=$perPage';
      response = await DioClient.instance.get(url);
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
    try {
      return CommentResponse.fromJson(response.data);
    } catch (e) {
      throw BadRequestException(ApiError.errorOccurredWhileParsingResponse());
    }
  }
}

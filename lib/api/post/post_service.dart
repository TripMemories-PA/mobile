import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../app.config.dart';
import '../../object/avatar/uploaded_file.dart';
import '../../object/post/post.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_post_service.dart';
import 'model/query/create_post/create_post_query.dart';
import 'model/query/update_post_query/update_post_query.dart';
import 'model/response/create_post_response/create_post_response.dart';
import 'model/response/get_all_posts_response.dart';

class PostService implements IPostService {
  static const String apiPostBaseUrl = '${AppConfig.apiUrl}/posts';
  static const String apiGetUserPostUrl =
      '${AppConfig.apiUrl}/users/[user_id]/posts';

  @override
  Future<CreatePostResponse> createPost({
    required CreatePostQuery query,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.post(
        apiPostBaseUrl,
        data: query.toJson(),
      );
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
    try {
      return CreatePostResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> deletePost({required int postId}) async {
    try {
      await DioClient.instance.delete(
        '$apiPostBaseUrl/$postId',
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<Post> getPostById({required int postId}) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        '$apiPostBaseUrl/$postId',
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return Post.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<GetAllPostsResponse> getPosts({
    required int page,
    required int perPage,
    int? userId,
  }) async {
    Response response;
    try {
      String url;
      if (userId != null) {
        url = '$apiGetUserPostUrl?page=$page&perPage=$perPage';
        url = url.replaceAll('[user_id]', userId.toString());
      } else {
        url = '$apiPostBaseUrl?page=$page&perPage=$perPage';
      }
      response = await DioClient.instance.get(
        url,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return GetAllPostsResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<Post> updatePost({
    required UpdatePostQuery query,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.put(
        apiPostBaseUrl,
        data: query.toJson(),
      );
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
    try {
      return Post.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<int> publishImage({required XFile image}) async {
    Response response;
    try {
      response = await DioClient.instance.post(
        '$apiPostBaseUrl/image',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path),
        }),
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return UploadFile.fromJson(response.data).id;
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> likePost({required int postId}) async {
    try {
      await DioClient.instance.post('$apiPostBaseUrl/$postId/like');
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
  }

  @override
  Future<void> dislikePost({required int postId}) async {
    try {
      await DioClient.instance.delete('$apiPostBaseUrl/$postId/like');
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
  }
}

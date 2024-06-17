import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import '../post/model/response/get_all_posts_response.dart';
import 'i_poi_service.dart';
import 'model/response/pois_response/pois_response.dart';

class PoiService implements IPoiService {
  static const String apiPoisBaseUrl = '${AppConfig.apiUrl}/pois';

  @override
  Future<PoisResponse> getPois({
    required int page,
    required int perPage,
    required double xx,
    required double xy,
    required double yx,
    required double yy,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        '$apiPoisBaseUrl?page=$page&perPage=$perPage',
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return PoisResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<GetAllPostsResponse> getPoisPosts(
      {required int poiId, required int page, required int perPage,}) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        '$apiPoisBaseUrl/$poiId/posts?page=$page&perPage=$perPage',
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
}

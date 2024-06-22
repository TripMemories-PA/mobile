import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../../object/position.dart';
import '../../object/radius.dart';
import '../../object/sort_possibility.dart';
import '../../repository/monument/i_monument_repository.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import '../post/model/response/get_all_posts_response.dart';
import 'i_monument_service.dart';
import 'model/response/poi/poi.dart';
import 'model/response/pois_response/pois_response.dart';

class MonumentService implements IMonumentService, IMonumentRepository {
  static const String apiPoisBaseUrl = '${AppConfig.apiUrl}/pois';

  @override
  Future<PoisResponse> getMonuments({
    required int page,
    required int perPage,
    Position? position,
    required bool sortByName,
    required AlphabeticalSortPossibility order,
    String? searchingCriteria,
    RadiusQueryInfos? radius,
  }) async {
    Response response;
    try {
      String url = '$apiPoisBaseUrl?page=$page&perPage=$perPage';
      if (searchingCriteria != null) {
        url += '&search=$searchingCriteria';
      }
      if (position != null) {
        url +=
            '&swLng=${position.swLng}&swLat=${position.swLat}&neLng=${position.neLng}&neLat=${position.neLat}';
      } else if (radius != null) {
        url += '&radius=${radius.km}&lng=${radius.lng}&lat=${radius.lat}';
      }

      response = await DioClient.instance.get(
        url,
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
  Future<GetAllPostsResponse> getMonumentPosts({
    required int poiId,
    required int page,
    required int perPage,
  }) async {
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

  @override
  Future<Poi> getMonument(int id) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        '$apiPoisBaseUrl/$id',
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return Poi.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }
}

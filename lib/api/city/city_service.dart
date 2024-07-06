import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../../object/position.dart';
import '../../object/radius.dart';
import '../../object/sort_possibility.dart';
import '../../repository/city/i_cities_repository.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import '../monument/model/response/pois_response.dart';
import 'i_city_service.dart';
import 'model/response/cities_response.dart';

class CityServiceService implements ICityService, ICityRepository {
  static const String apiCitiesBaseUrl = '${AppConfig.apiUrl}/cities';

  @override
  Future<CitiesResponse> getCities({
    Position? position,
    required bool sortByName,
    required AlphabeticalSortPossibility order,
    required int page,
    required int perPage,
    String? searchingCriteria,
    RadiusQueryInfos? radius,
  }) async {
    Response response;
    try {
      String url = '$apiCitiesBaseUrl?page=$page&perPage=$perPage';
      if (searchingCriteria != null) {
        url += '&search=$searchingCriteria';
      }

      response = await DioClient.instance.get(
        url,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return CitiesResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<PoisResponse> getCityMonuments({
    required int cityId,
    required int page,
    required int perPage,
  }) async {
    Response response;
    try {
      final String url =
          '$apiCitiesBaseUrl/$cityId/pois?page=$page&perPage=$perPage&sortBy=name&order=desc';
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
}

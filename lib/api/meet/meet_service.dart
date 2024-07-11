import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../../repository/meet/i_meet_repository.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_meet_service.dart';
import 'model/response/meet_response.dart';
import 'model/response/meet_users.dart';

class MeetService implements IMeetRepository, IMeetService {
  static const String apiMeetsBaseUrl = '${AppConfig.apiUrl}/meets';

  @override
  Future<MeetUsers> getMeetUsers(int meetId,
      {required int page, required int perPage,}) async {
    Response response;
    try {
      final String url =
          '$apiMeetsBaseUrl/$meetId/users?page=$page&perPage=$perPage';
      response = await DioClient.instance.get(url);
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return MeetUsers.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
          ApiError.errorOccurredWhileParsingResponse(),);
    }
  }

  @override
  Future<void> deleteUserFromMeet(int meetId, int userId) async {
    try {
      final String url = '$apiMeetsBaseUrl/$meetId/users/$userId';
      await DioClient.instance.delete(url);
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<MeetResponse> createMeet(Map<String, dynamic> data) async {
    Response response;
    try {
      const String url = apiMeetsBaseUrl;
      response = await DioClient.instance.post(url, data: data);
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return MeetResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
          ApiError.errorOccurredWhileParsingResponse(),);
    }
  }

  @override
  Future<MeetResponse> getMeet(int meetId) async {
    Response response;
    try {
      final String url = '$apiMeetsBaseUrl/$meetId';
      response = await DioClient.instance.get(url);
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return MeetResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
          ApiError.errorOccurredWhileParsingResponse(),);
    }
  }

  @override
  Future<MeetResponse> updateMeet(int meetId, Map<String, dynamic> data) async {
    Response response;
    try {
      final String url = '$apiMeetsBaseUrl/$meetId';
      response = await DioClient.instance.put(url, data: data);
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return MeetResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
          ApiError.errorOccurredWhileParsingResponse(),);
    }
  }

  @override
  Future<void> deleteMeet(int meetId) async {
    try {
      final String url = '$apiMeetsBaseUrl/$meetId';
      await DioClient.instance.delete(url);
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<void> joinMeet(int meetId) async {
    try {
      final String url = '$apiMeetsBaseUrl/$meetId/join';
      await DioClient.instance.post(url);
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<void> leaveMeet(int meetId) async {
    try {
      final String url = '$apiMeetsBaseUrl/$meetId/leave';
      await DioClient.instance.post(url);
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<void> payForMeet(int meetId) async {
    try {
      final String url = '$apiMeetsBaseUrl/$meetId/pay';
      await DioClient.instance.post(url);
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<MeetResponse> getPoiMeet({
    required int poiId,
    required int page,
    required int perPage,
  }) async {
    Response response;
    try {
      final String url = '${AppConfig.apiUrl}/pois/$poiId/meets?page=$page&perPage=$perPage';
      response = await DioClient.instance.get(url);
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return MeetResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
          ApiError.errorOccurredWhileParsingResponse(),);
    }
  }
}
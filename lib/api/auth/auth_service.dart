import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../../object/profile.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_auth_service.dart';
import 'model/query/login_model.dart';
import 'model/query/subscribe_model.dart';
import 'model/response/auth_success_response.dart';
import 'model/response/subscribe_success_response.dart';

class AuthService implements IAuthService {
  static const String apiAuthBaseUrl = '${AppConfig.apiUrl}/auth';

  static const String apiLoginUrl = '$apiAuthBaseUrl/login';

  static const String apiSubscribeUrl = '$apiAuthBaseUrl/register';

  static const String apiMeUrl = '${AppConfig.apiUrl}/me';

  @override
  Future<SubscribeSuccessResponse> subscribe({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    final body = SubscribeModel.createJson(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      password: password,
    );

    Response response;
    try {
      response = await DioClient.instance.post(
        apiSubscribeUrl,
        data: body,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.alreadyExists());
    }
    try {
      return SubscribeSuccessResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<AuthSuccessResponse> login({
    required String email,
    required String password,
  }) async {
    final body = LoginModel.createJson(
      email: email,
      password: password,
    );

    Response response;
    try {
      response = await DioClient.instance.post(
        apiLoginUrl,
        data: body,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.wrongEmailOrPassword());
    }
    try {
      return AuthSuccessResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<Profile> whoAmI() async {
    Response response;
    try {
      response = await DioClient.instance.get(
        apiMeUrl,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return Profile.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await DioClient.instance.delete(
        apiMeUrl,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<AuthSuccessResponse> refresh() async {
    Response response;
    try {
      response = await DioClient.instance.post(
        '$apiAuthBaseUrl/refresh',
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.tokenExpired());
    }
    try {
      return AuthSuccessResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> updateMyLocation(double latitude, double longitude) {
    return DioClient.instance.put(
      apiMeUrl,
      data: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }
}

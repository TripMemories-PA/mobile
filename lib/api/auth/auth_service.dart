import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_auth_service.dart';
import 'model/query/login_model.dart';
import 'model/query/subscribe_model.dart';
import 'model/response/auth_success_response/auth_success_response.dart';
import 'model/response/who_am_i_response/who_am_i_response.dart';

class AuthService implements IAuthService {
  static const String apiAuthBaseUrl = '${AppConfig.apiUrl}/auth';

  static const String apiLoginUrl = '$apiAuthBaseUrl/login';

  static const String apiSubscribeUrl = '$apiAuthBaseUrl/register';

  static const String apiMeUrl = '${AppConfig.apiUrl}/me';

  @override
  Future<AuthSuccessResponse> subscribe({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final body = SubscribeModel.createJson(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
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
      return AuthSuccessResponse.fromJson(response.data);
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
  Future<WhoAmIResponse> whoAmI({required String token}) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        apiMeUrl,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return WhoAmIResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }
}

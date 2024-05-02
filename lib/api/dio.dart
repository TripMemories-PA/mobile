import 'dart:async';

import 'package:dio/dio.dart';

import '../app.config.dart';
import '../local_storage/secure_storage/auth_token_handler.dart';
import 'error/api_error.dart';
import 'exception/bad_request_exception.dart';
import 'exception/query_api_exception.dart';
import 'exception/query_timeout_exception.dart';

class DioClient {
  DioClient._(this._authTokenHandler);

  static final instance = DioClient._(AuthTokenHandler());

  final AuthTokenHandler _authTokenHandler;

  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final authToken = await _authTokenHandler.getAuthToken();
          options.headers.addAll({
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          });
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401) {
            throw QueryApiException(ApiError.unauthorized());
          } else {
            return handler.next(response);
          }
        },
      ),
    );
    return dio;
  }

  Future<Response> _handleDioExceptions(
    Future<Response> Function() dioCall,
  ) async {
    try {
      Response response = await dioCall();
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw QueryApiException(ApiError.hostUnreachable());
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw QueryTimeoutException(ApiError.requestTimeout());
      } else if (e.type == DioExceptionType.badResponse) {
        throw BadRequestException(ApiError.badRequest());
      } else {
        throw QueryApiException(ApiError.errorOccurred());
      }
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleDioExceptions(
      () => dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response> post(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final Response response = await _handleDioExceptions(
      () => dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
    return response;
  }

  Future<Response> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleDioExceptions(
      () => dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleDioExceptions(
      () => dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }
}

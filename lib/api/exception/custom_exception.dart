import '../error/api_error.dart';

abstract class CustomException implements Exception {
  CustomException(this.apiError);
  final ApiError apiError;
}

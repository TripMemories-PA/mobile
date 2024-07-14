import '../../constants/string_constants.dart';

class ApiError {
  const ApiError(this._description);

  final String _description;

  static ApiError hostUnreachable() {
    return ApiError(StringConstants().hostUnreachable);
  }

  static ApiError cannotReachLocalData() {
    return ApiError(StringConstants().cannotReachLocalData);
  }

  static ApiError unknown() {
    return ApiError(StringConstants().unknownError);
  }

  static ApiError errorOccurredWhileQueryingServer() {
    return ApiError(StringConstants().errorOccurredWhileQueryingServer);
  }

  static ApiError errorOccurredWhileParsingResponse() {
    return ApiError(StringConstants().errorOccurredWhileParsingResponse);
  }

  static ApiError requestTimeout() {
    return ApiError(StringConstants().requestTimeout);
  }

  static ApiError errorAppendedWhileGettingData() {
    return ApiError(StringConstants().errorAppendedWhileGettingData);
  }

  static ApiError badRequest() {
    return ApiError(StringConstants().badRequest);
  }

  static ApiError unauthorized() {
    return ApiError(StringConstants().unauthorized);
  }

  static ApiError errorOccurred() {
    return ApiError(StringConstants().errorOccurred);
  }

  static ApiError errorWhilePostingMessage() {
    return ApiError(StringConstants().errorWhilePostingMessage);
  }

  static ApiError errorWhileFetchingMessages() {
    return ApiError(StringConstants().errorWhileFetchingMessages);
  }

  String getDescription() {
    return _description;
  }
}

import '../../constants/string_constants.dart';

class ApiError {
  const ApiError(this._description);

  final String _description;

  static ApiError hostUnreachable() {
    return const ApiError(StringConstants.hostUnreachable);
  }

  static ApiError cannotReachLocalData() {
    return const ApiError(StringConstants.cannotReachLocalData);
  }

  static ApiError unknown() {
    return const ApiError(StringConstants.unknownError);
  }

  static ApiError errorOccurredWhileQueryingServer() {
    return const ApiError(StringConstants.errorOccurredWhileQueryingServer);
  }

  static ApiError errorOccurredWhileParsingResponse() {
    return const ApiError(StringConstants.errorOccurredWhileParsingResponse);
  }

  static ApiError requestTimeout() {
    return const ApiError(StringConstants.requestTimeout);
  }

  static ApiError errorAppendedWhileGettingData() {
    return const ApiError(StringConstants.errorAppendedWhileGettingData);
  }

  static ApiError badRequest() {
    return const ApiError(StringConstants.badRequest);
  }

  static ApiError unauthorized() {
    return const ApiError(StringConstants.unauthorized);
  }

  static ApiError errorOccurred() {
    return const ApiError(StringConstants.errorOccurred);
  }

  static ApiError errorWhilePostingMessage() {
    return const ApiError(StringConstants.errorWhilePostingMessage);
  }

  static ApiError errorWhileFetchingMessages() {
    return const ApiError(StringConstants.errorWhileFetchingMessages);
  }

  String getDescription() {
    return _description;
  }
}

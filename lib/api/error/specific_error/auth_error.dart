import '../../../constants/string_constants.dart';
import '../api_error.dart';

class AuthError extends ApiError {
  const AuthError(super.description);

  static AuthError wrongEmailOrPassword() {
    return const AuthError(StringConstants.wrongEmailOrPassword);
  }

  static AuthError alreadyExists() {
    return const AuthError(StringConstants.emailOrUsernameAlreadyExists);
  }

  static AuthError notAuthenticated() {
    return const AuthError(StringConstants.notAuthenticated);
  }

  static AuthError errorOccurredWhileLoggingIn() {
    return const AuthError(StringConstants.errorOccurredWhileLoggingIn);
  }

  static AuthError tokenExpired() {
    return const AuthError(StringConstants.tokenExpired);
  }
}

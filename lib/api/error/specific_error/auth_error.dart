import '../../../constants/string_constants.dart';
import '../api_error.dart';

class AuthError extends ApiError {
  const AuthError(super.description);

  static AuthError wrongEmailOrPassword() {
    return AuthError(StringConstants().wrongEmailOrPassword);
  }

  static AuthError alreadyExists() {
    return AuthError(StringConstants().emailOrUsernameAlreadyExists);
  }

  static AuthError notAuthenticated() {
    return AuthError(StringConstants().notAuthenticated);
  }

  static AuthError errorOccurredWhileLoggingIn() {
    return AuthError(StringConstants().errorOccurredWhileLoggingIn);
  }

  static AuthError tokenExpired() {
    return AuthError(StringConstants().tokenExpired);
  }
}

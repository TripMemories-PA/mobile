import '../../api/error/api_error.dart';

enum AuthStatus { authenticated, guest }

class AuthState {
  const AuthState._({
    this.status = AuthStatus.guest,
    this.error,
    this.userId,
    this.name,
  });

  const AuthState.authenticated({
    required String userId,
    required String name,
  }) : this._(
          status: AuthStatus.authenticated,
          userId: userId,
          name: name,
        );

  const AuthState.guest({ApiError? error})
      : this._(
          status: AuthStatus.guest,
          error: error,
          userId: null,
          name: null,
        );
  final AuthStatus status;
  final ApiError? error;
  final String? userId;
  final String? name;
}

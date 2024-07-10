import '../../api/error/api_error.dart';
import '../../object/profile.dart';

enum AuthStatus { authenticated, guest }

class AuthState {
  const AuthState._({
    this.status = AuthStatus.guest,
    this.error,
    this.user,
    this.appStarted = false,
  });

  const AuthState.authenticated({
    required Profile user,
  }) : this._(
          status: AuthStatus.authenticated,
          user: user,
        );

  const AuthState.guest({ApiError? error})
      : this._(
          status: AuthStatus.guest,
          error: error,
          user: null,
        );

  const AuthState.appStarted()
      : this._(
          appStarted: true,
        );
  final AuthStatus status;
  final ApiError? error;
  final Profile? user;
  final bool appStarted;
}

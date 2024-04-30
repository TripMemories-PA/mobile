import '../../api/auth/model/response/who_am_i_response/who_am_i_response.dart';
import '../../api/error/api_error.dart';

enum AuthStatus { authenticated, guest }

class AuthState {
  const AuthState._({
    this.status = AuthStatus.guest,
    this.error,
    this.user,
  });

  const AuthState.authenticated({
    required WhoAmIResponse user,
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
  final AuthStatus status;
  final ApiError? error;
  final WhoAmIResponse? user;
}

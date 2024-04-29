import '../../api/error/api_error.dart';

class LoginState {
  const LoginState._({
    this.loading = false,
    this.error,
  });

  const LoginState.loading()
      : this._(
          loading: true,
          error: null,
        );

  const LoginState.notLoading()
      : this._(
          loading: false,
          error: null,
        );

  LoginState.error({ApiError? error})
      : this._(loading: false, error: error ?? ApiError.unknown());
  final bool loading;
  final ApiError? error;
}

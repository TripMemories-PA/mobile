import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/auth/model/response/auth_success_response/auth_success_response.dart';
import '../../api/auth/model/response/who_am_i_response/who_am_i_response.dart';
import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../auth_bloc/auth_bloc.dart';
import '../auth_bloc/auth_event.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.authBloc) : super(const LoginState.notLoading()) {
    on<LoginRequested>(
      (event, emit) async {
        emit(const LoginState.loading());
        try {
          final AuthSuccessResponse authResponse =
              await authBloc.authService.login(
            email: event.email,
            password: event.password,
          );
          await authBloc.authTokenHandler.saveToken(authResponse.token);
          final WhoAmIResponse user =
              await authBloc.authService.whoAmI(token: authResponse.token);

          authBloc.add(
            ChangeToLoggedInStatus(
              user: user,
              authToken: authResponse.token,
            ),
          );
          emit(const LoginState.notLoading());
        } catch (exception) {
          if (exception is CustomException) {
            emit(
              LoginState.error(
                error: exception.apiError,
              ),
            );
          } else {
            emit(
              LoginState.error(
                error: ApiError.errorOccurred(),
              ),
            );
          }
        }
      },
    );

    on<LogoutRequested>((event, emit) async {
      try {
        await authBloc.authTokenHandler.logout();
        authBloc.add(const ChangeToLoggedOutStatus());
      } catch (_) {
        emit(LoginState.error(error: ApiError.errorOccurred()));
      }
    });
  }

  final AuthBloc authBloc;
}

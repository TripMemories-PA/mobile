import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/auth/i_auth_service.dart';
import '../../api/auth/model/response/who_am_i_response/who_am_i_response.dart';
import '../../api/error/api_error.dart';
import '../../api/error/specific_error/auth_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../local_storage/secure_storage/auth_token_handler.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authService, this.authTokenHandler)
      : super(const AuthState.guest()) {
    on<AppStarted>((event, emit) async {
      final String? token = await authTokenHandler.getAuthToken();
      if (token == null) {
        emit(const AuthState.guest());
        return;
      }
      try {
        final WhoAmIResponse whoAmIResponse =
            await authService.whoAmI(token: token);
        emit(
          AuthState.authenticated(
            userId: whoAmIResponse.id.toString(),
            name: whoAmIResponse.name,
          ),
        );
      } catch (exception) {
        authTokenHandler.logout();
        if (exception is CustomException) {
          emit(
            AuthState.guest(
              error: exception.apiError,
            ),
          );
        } else {
          emit(
            AuthState.guest(
              error: ApiError.errorOccurred(),
            ),
          );
        }
      }
    });

    on<ChangeAuthState>((event, emit) {
      if (event.newState.status == AuthStatus.authenticated) {
        final String? userId = event.newState.userId;
        if (userId == null) {
          emit(
            AuthState.guest(error: AuthError.errorOccurredWhileLoggingIn()),
          );
        } else {
          String name = '';
          if (event.newState.name != null) {
            name = event.newState.name!;
          }
          emit(
            AuthState.authenticated(
              userId: userId,
              name: name,
            ),
          );
        }
      } else {
        emit(const AuthState.guest());
      }
    });
  }

  final IAuthService authService;
  final AuthTokenHandler authTokenHandler;
}

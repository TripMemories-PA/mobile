import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/auth/i_auth_service.dart';
import '../../api/auth/model/response/who_am_i_response/who_am_i_response.dart';
import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../local_storage/secure_storage/auth_token_handler.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authService, required this.authTokenHandler})
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
            user: whoAmIResponse,
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

    on<ChangeToLoggedInStatus>((event, emit) async {
      await authTokenHandler.saveToken(event.authToken);
      final WhoAmIResponse user =
          await authService.whoAmI(token: event.authToken);
      emit(
        AuthState.authenticated(
          user: user,
        ),
      );
    });

    on<ChangeToLoggedOutStatus>((event, emit) {
      emit(
        const AuthState.guest(),
      );
    });

    on<DeleteAccountEvent>(
      (event, emit) async {
        try {
          await authService.deleteAccount();
          emit(
            const AuthState.guest(),
          );
        } catch (e) {
          emit(
            AuthState.guest(
              error: e is CustomException ? e.apiError : ApiError.unknown(),
            ),
          );
        }
      },
    );
  }

  final IAuthService authService;
  final AuthTokenHandler authTokenHandler;
}

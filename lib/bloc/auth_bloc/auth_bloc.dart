import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/auth/i_auth_service.dart';
import '../../api/auth/model/response/auth_success_response/auth_success_response.dart';
import '../../api/auth/model/response/who_am_i_response.dart';
import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../local_storage/local_storage/login_handler.dart';
import '../../local_storage/secure_storage/auth_token_handler.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authService, required this.authTokenHandler})
      : super(const AuthState.guest()) {
    on<AppStarted>((event, emit) async {
      final StayLoggedInHandler stayLoggedInHandler = StayLoggedInHandler();
      final bool? stayLoggedIn = await stayLoggedInHandler.getLoginPref();
      final String? token = await authTokenHandler.getAuthToken();
      if (token == null && stayLoggedIn == null) {
        emit(const AuthState.guest());
        return;
      } else if (stayLoggedIn != null && token != null) {
        if (!stayLoggedIn) {
          authTokenHandler.logout();
          emit(const AuthState.guest());
          return;
        } else {
          try {
            final AuthSuccessResponse authSuccessResponse =
                await authService.refresh();
            await authTokenHandler.saveToken(
              authSuccessResponse.token,
              stayLoggedIn,
            );

            final WhoAmIResponse whoAmIResponse = await authService.whoAmI();
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
        }
        add(
          ChangeToLoggedInStatus(
            authToken: token,
            stayLoggedIn: stayLoggedIn,
          ),
        );
        return;
      }
    });

    on<ChangeToLoggedInStatus>((event, emit) async {
      try {
        await authTokenHandler.saveToken(event.authToken, event.stayLoggedIn);
        final WhoAmIResponse user = await authService.whoAmI();
        emit(
          AuthState.authenticated(
            user: user,
          ),
        );
      } catch (e) {
        authTokenHandler.logout();
        if (e is CustomException) {
          emit(
            AuthState.guest(
              error: e.apiError,
            ),
          );
        } else {
          emit(
            const AuthState.guest(),
          );
        }
      }
    });

    on<ChangeToLoggedOutStatus>((event, emit) {
      authTokenHandler.logout();

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

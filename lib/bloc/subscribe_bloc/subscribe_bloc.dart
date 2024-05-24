import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/auth/model/response/auth_success_response/auth_success_response.dart';
import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../auth_bloc/auth_bloc.dart';
import '../auth_bloc/auth_event.dart';
import 'subscribe_event.dart';
import 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState> {
  SubscribeBloc(this.authBloc) : super(const SubscribeState.notLoading()) {
    on<SubscribeRequested>(
      (event, emit) async {
        emit(const SubscribeState.loading());
        try {
          await authBloc.authService.subscribe(
            firstName: event.firstName,
            lastName: event.lastName,
            username: event.username,
            email: event.email,
            password: event.password,
          );
          emit(const SubscribeState.subscribed());
          final AuthSuccessResponse response = await authBloc.authService.login(
            email: event.email,
            password: event.password,
          );
          authBloc.add(
            ChangeToLoggedInStatus(
              authToken: response.token,
            ),
          );
        } catch (exception) {
          if (exception is CustomException) {
            emit(
              SubscribeState.error(
                error: exception.apiError,
              ),
            );
          } else {
            emit(
              SubscribeState.error(
                error: ApiError.errorOccurred(),
              ),
            );
          }
        }
      },
    );
  }

  final AuthBloc authBloc;
}

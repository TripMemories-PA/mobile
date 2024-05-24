import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/auth/i_auth_service.dart';
import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import 'subscribe_event.dart';
import 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState> {
  SubscribeBloc(this.authService) : super(const SubscribeState.notLoading()) {
    on<SubscribeRequested>(
      (event, emit) async {
        emit(const SubscribeState.loading());
        try {
          await authService.subscribe(
            firstName: event.firstName,
            lastName: event.lastName,
            username: event.username,
            email: event.email,
            password: event.password,
          );
          emit(const SubscribeState.subscribed());
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

  final IAuthService authService;
}

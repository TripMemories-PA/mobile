import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifier_event.dart';
import 'notifier_state.dart';

class NotifierBloc extends Bloc<NotifierEvent, NotifierState> {
  NotifierBloc() : super(const NotifierState.initial()) {
    on<AppendNotification>(
      (event, emit) {
        emit(
          NotifierState.notification(
            notification: event.notification,
            type: event.type,
          ),
        );
      },
    );
  }
}

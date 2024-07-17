import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/quest/i_quest_service.dart';
import '../../api/quest/model/response/check_quest_validity_response.dart';

part 'quest_validation_event.dart';
part 'quest_validation_state.dart';

class QuestValidationBloc
    extends Bloc<QuestValidationEvent, QuestValidationState> {
  QuestValidationBloc({required this.questService})
      : super(QuestValidationState()) {
    on<ValidateQuestEvent>((event, emit) async {
      emit(state.copyWith(status: QuestValidationStatus.loading));
      try {
        final CheckQuestValidityResponse response =
            await questService.validateQuest(id: event.id, file: event.file);
        emit(
          state.copyWith(
            status: response.valid
                ? QuestValidationStatus.success
                : QuestValidationStatus.failed,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: QuestValidationStatus.error,
            error: ApiError.errorOccurred(),
          ),
        );
      }
    });
  }

  final IQuestService questService;
}

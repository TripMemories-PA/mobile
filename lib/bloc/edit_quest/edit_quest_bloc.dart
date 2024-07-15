import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/quest/i_quest_service.dart';
import '../../api/quest/model/response/post_quest_imaage_response.dart';
import 'edit_quest_event.dart';

part 'edit_quest_state.dart';

class EditQuestBloc extends Bloc<EditQuestEvent, EditQuestState> {
  EditQuestBloc({
    required this.questService,
  }) : super(EditQuestState()) {
    on<StoreQuestImageEvent>(_onStoreImage);
    on<StoreQuestEvent>(_onStoreQuest);
    on<UpdateQuestEvent>(_onUpdateQuest);
    on<ValidateQuestEvent>(_onValidateQuest);
    on<SelectTitleEvent>(_onSelectTitle);
  }

  final IQuestService questService;

  Future<void> _onStoreImage(
    StoreQuestImageEvent event,
    Emitter<EditQuestState> emit,
  ) async {
    emit(state.copyWith(pickImageStatus: QuestStatus.loading));
    try {
      final PostQuestImageResponse response =
          await questService.storeImage(XFile(event.file.path));
      emit(
        state.copyWith(
          status: QuestStatus.initial,
          postQuestImageResponse: response,
          publishQuestStep: PublishQuestStep.selectLabels,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: QuestStatus.error,
          error: e is CustomException ? e.apiError : ApiError.unknown(),
        ),
      );
    }
  }

  Future<void> _onStoreQuest(
    StoreQuestEvent event,
    Emitter<EditQuestState> emit,
  ) async {
    emit(state.copyWith(status: QuestStatus.loading));
    try {
      await questService.storeQuest(questData: event.queryModel);
      emit(
        state.copyWith(
          status: QuestStatus.initial,
          publishQuestStep: PublishQuestStep.posted,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: QuestStatus.error,
          error: e is CustomException ? e.apiError : ApiError.unknown(),
        ),
      );
    }
  }

  Future<void> _onUpdateQuest(
    UpdateQuestEvent event,
    Emitter<EditQuestState> emit,
  ) async {
    emit(state.copyWith(status: QuestStatus.loading));
    try {
      await questService.updateQuest(
        id: event.id,
        questData: event.queryModel,
      );
      emit(state.copyWith(status: QuestStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          status: QuestStatus.error,
          error: e is CustomException ? e.apiError : ApiError.unknown(),
        ),
      );
    }
  }

  Future<void> _onValidateQuest(
    ValidateQuestEvent event,
    Emitter<EditQuestState> emit,
  ) async {
    emit(state.copyWith(status: QuestStatus.loading));
    try {
      await questService.validateQuest(id: event.id, file: event.file);
      emit(state.copyWith(status: QuestStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(
          status: QuestStatus.error,
          error: ApiError(
            e.toString(),
          ),
        ),
      );
    }
  }

  void _onSelectTitle(
    SelectTitleEvent event,
    Emitter<EditQuestState> emit,
  ) {
    if (event.title.isNotEmpty) {
      emit(state.copyWith(publishQuestStep: PublishQuestStep.pickImage));
    }
  }
}

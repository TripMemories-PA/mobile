import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/quest/i_quest_service.dart';
import '../../api/quest/model/response/get_quest_list.dart';
import '../../object/quest.dart';
import '../../repository/quest/i_repository.dart';
import 'quest_event.dart';

part 'quest_state.dart';

class QuestBloc extends Bloc<QuestEvent, QuestState> {
  QuestBloc({
    required this.questService,
    required this.questRepository,
  }) : super(QuestState()) {
    on<StoreQuestImageEvent>(_onStoreImage);
    on<StoreQuestEvent>(_onStoreQuest);
    on<GetQuestEvent>(_onGetQuest);
    on<GetPoiQuestEvent>(_onGetPoiQuests);
    on<UpdateQuestEvent>(_onUpdateQuest);
    on<DeleteQuestEvent>(_onDeleteQuest);
    on<ValidateQuestEvent>(_onValidateQuest);
  }

  final IQuestService questService;
  final IQuestRepository questRepository;

  Future<void> _onStoreImage(
    StoreQuestImageEvent event,
    Emitter<QuestState> emit,
  ) async {
    emit(state.copyWith(status: QuestStatus.loading));
    try {
      await questService.storeImage(XFile(event.file.path));
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

  Future<void> _onStoreQuest(
    StoreQuestEvent event,
    Emitter<QuestState> emit,
  ) async {
    emit(state.copyWith(status: QuestStatus.loading));
    try {
      await questService.storeQuest(questData: event.queryModel);
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

  Future<void> _onGetQuest(
    GetQuestEvent event,
    Emitter<QuestState> emit,
  ) async {
    emit(state.copyWith(status: QuestStatus.loading));
    try {
      final Quest quest = await questRepository.getQuest(event.id);
      emit(
        state.copyWith(
          status: QuestStatus.initial,
          selectedQuest: quest,
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

  Future<void> _onGetPoiQuests(
    GetPoiQuestEvent event,
    Emitter<QuestState> emit,
  ) async {
    event.isRefresh
        ? emit(state.copyWith(status: QuestStatus.loading))
        : emit(state.copyWith(moreQuestStatus: QuestStatus.loading));
    try {
      final GetQuestList quests = await questRepository.getQuestsFromPoi(
        poiId: event.id,
        page: event.isRefresh ? 1 : state.page + 1,
        perPage: state.perPage,
      );
      emit(
        state.copyWith(
          status: QuestStatus.initial,
          questList: quests,
          page: event.isRefresh ? 0 : state.page + 1,
          moreQuestStatus: QuestStatus.initial,
          hasMoreQuest: quests.meta.total != state.questList?.quests.length,
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
    Emitter<QuestState> emit,
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

  Future<void> _onDeleteQuest(
    DeleteQuestEvent event,
    Emitter<QuestState> emit,
  ) async {
    emit(state.copyWith(status: QuestStatus.loading));
    try {
      await questService.deleteQuest(event.id);
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
    Emitter<QuestState> emit,
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
}

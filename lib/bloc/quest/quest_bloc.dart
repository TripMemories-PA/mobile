import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/quest/i_quest_service.dart';
import '../../api/quest/model/response/get_quest_list.dart';
import '../../api/quest/model/response/post_quest_imaage_response.dart';
import '../../object/quest.dart';
import '../../repository/quest/i_repository.dart';
import 'quest_event.dart';

part 'quest_state.dart';

class QuestBloc extends Bloc<QuestEvent, QuestState> {
  QuestBloc({
    required this.questService,
    required this.questRepository,
  }) : super(QuestState()) {
    on<GetQuestEvent>(_onGetQuest);
    on<GetPoiQuestEvent>(_onGetPoiQuests);
    on<DeleteQuestEvent>(_onDeleteQuest);
  }

  final IQuestService questService;
  final IQuestRepository questRepository;

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
      final List<Quest> questList =
          event.isRefresh ? quests.quests : state.questList + quests.quests;
      emit(
        state.copyWith(
          status: QuestStatus.initial,
          questList: questList,
          page: event.isRefresh ? 1 : state.page + 1,
          moreQuestStatus: QuestStatus.initial,
          hasMoreQuest: quests.meta.total != questList.length,
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

  Future<void> _onDeleteQuest(
    DeleteQuestEvent event,
    Emitter<QuestState> emit,
  ) async {
    try {
      await questService.deleteQuest(event.id);
      final List<Quest> updatedQuests =
          state.questList.where((element) => element.id != event.id).toList();
      emit(
        state.copyWith(
          status: QuestStatus.deleted,
          questList: updatedQuests,
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
    emit(state.copyWith(status: QuestStatus.initial));
  }
}

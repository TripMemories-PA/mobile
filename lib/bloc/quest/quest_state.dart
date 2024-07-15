part of 'quest_bloc.dart';

enum QuestStatus {
  initial,
  loading,
  error,
}

class QuestState {
  QuestState({
    this.status = QuestStatus.initial,
    this.error,
    this.questList,
    this.selectedQuest,
    this.page = 0,
    this.perPage = 10,
    this.moreQuestStatus = QuestStatus.initial,
    this.hasMoreQuest = true,
  });

  final QuestStatus status;
  final ApiError? error;
  final GetQuestList? questList;
  final Quest? selectedQuest;
  final int page;
  final int perPage;
  final QuestStatus moreQuestStatus;
  final bool hasMoreQuest;

  QuestState copyWith({
    QuestStatus? status,
    ApiError? error,
    GetQuestList? questList,
    Quest? selectedQuest,
    int? page,
    int? perPage,
    QuestStatus? moreQuestStatus,
    bool? hasMoreQuest,
  }) {
    return QuestState(
      status: status ?? this.status,
      error: error,
      questList: questList ?? this.questList,
      selectedQuest: selectedQuest ?? this.selectedQuest,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      moreQuestStatus: moreQuestStatus ?? this.moreQuestStatus,
      hasMoreQuest: hasMoreQuest ?? this.hasMoreQuest,
    );
  }
}

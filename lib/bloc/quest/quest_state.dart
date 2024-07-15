part of 'quest_bloc.dart';

enum QuestStatus {
  initial,
  loading,
  error,
  deleted,
  updated,
}

enum PublishQuestStep {
  selectTitle,
  pickImage,
  selectLabels,
  storeQuest,
  posted
}

class QuestState {
  QuestState({
    this.status = QuestStatus.initial,
    this.error,
    this.questList = const [],
    this.selectedQuest,
    this.page = 1,
    this.perPage = 10,
    this.moreQuestStatus = QuestStatus.initial,
    this.hasMoreQuest = true,
    this.editedQuest,
    this.pickImageStatus = QuestStatus.initial,
    this.postQuestImageResponse,
    this.publishQuestStep = PublishQuestStep.selectTitle,
  });

  final QuestStatus status;
  final ApiError? error;
  final List<Quest> questList;
  final Quest? selectedQuest;
  final int page;
  final int perPage;
  final QuestStatus moreQuestStatus;
  final bool hasMoreQuest;
  final Quest? editedQuest;
  final QuestStatus pickImageStatus;
  final PostQuestImageResponse? postQuestImageResponse;
  final PublishQuestStep publishQuestStep;

  QuestState copyWith({
    QuestStatus? status,
    ApiError? error,
    List<Quest>? questList,
    Quest? selectedQuest,
    int? page,
    int? perPage,
    QuestStatus? moreQuestStatus,
    bool? hasMoreQuest,
    Quest? editedQuest,
    QuestStatus? pickImageStatus,
    PostQuestImageResponse? postQuestImageResponse,
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
      editedQuest: editedQuest,
      pickImageStatus: pickImageStatus ?? this.pickImageStatus,
      postQuestImageResponse:
          postQuestImageResponse ?? this.postQuestImageResponse,
    );
  }
}

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
  });

  final QuestStatus status;
  final ApiError? error;
  final GetQuestList? questList;
  final Quest? selectedQuest;

  QuestState copyWith({
    QuestStatus? status,
    ApiError? error,
    GetQuestList? questList,
    Quest? selectedQuest,
  }) {
    return QuestState(
      status: status ?? this.status,
      error: error ?? this.error,
      questList: questList ?? this.questList,
      selectedQuest: selectedQuest ?? this.selectedQuest,
    );
  }
}

part of 'edit_quest_bloc.dart';

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
  posted,
  updated,
}

class EditQuestState {
  EditQuestState({
    this.status = QuestStatus.initial,
    this.error,
    this.pickImageStatus = QuestStatus.initial,
    this.postQuestImageResponse = const PostQuestImageResponse(
      labels: [],
    ),
    this.publishQuestStep = PublishQuestStep.selectTitle,
  });

  final QuestStatus status;
  final ApiError? error;
  final QuestStatus pickImageStatus;
  final PostQuestImageResponse postQuestImageResponse;
  final PublishQuestStep publishQuestStep;

  EditQuestState copyWith({
    QuestStatus? status,
    ApiError? error,
    QuestStatus? pickImageStatus,
    PostQuestImageResponse? postQuestImageResponse,
    PublishQuestStep? publishQuestStep,
  }) {
    return EditQuestState(
      status: status ?? this.status,
      pickImageStatus: pickImageStatus ?? this.pickImageStatus,
      postQuestImageResponse:
          postQuestImageResponse ?? this.postQuestImageResponse,
      publishQuestStep: publishQuestStep ?? this.publishQuestStep,
    );
  }
}

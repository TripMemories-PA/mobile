part of 'quest_validation_bloc.dart';

enum QuestValidationStatus { initial, loading, error, success, failed }

class QuestValidationState {
  QuestValidationState({
    this.status = QuestValidationStatus.initial,
    this.error,
  });

  final QuestValidationStatus status;
  final ApiError? error;

  QuestValidationState copyWith({
    QuestValidationStatus? status,
    ApiError? error,
  }) {
    return QuestValidationState(
      status: status ?? this.status,
      error: error,
    );
  }
}

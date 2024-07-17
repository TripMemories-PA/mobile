part of 'quiz_bloc.dart';

sealed class QuizEvent {}

class GetQuizEvent extends QuizEvent {
  GetQuizEvent({
    this.poiId,
  });

  final int? poiId;
}

class GetNextQuestionEvent extends QuizEvent {
  GetNextQuestionEvent();
}

class CheckQuestionEvent extends QuizEvent {
  CheckQuestionEvent({required this.questionId, required this.answerId});

  final int questionId;
  final int answerId;
}

class StoreImageEvent extends QuizEvent {
  StoreImageEvent(this.image);

  final XFile image;
}

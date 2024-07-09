part of 'quiz_bloc.dart';

sealed class QuizEvent {}

class GetQuizEvent extends QuizEvent {
  GetQuizEvent({
    required this.page,
    required this.perPage,
    this.poiId,
  });

  final int page;
  final int perPage;
  final int? poiId;
}

class UpdateQuestionEvent extends QuizEvent {
  UpdateQuestionEvent(this.id);

  final int id;
}

class DeleteQuestionEvent extends QuizEvent {
  DeleteQuestionEvent(this.id);

  final int id;
}

class PostQuestionEvent extends QuizEvent {
  PostQuestionEvent(this.postQuestionQuery);

  final PostQuestionQuery postQuestionQuery;
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
part of 'edit_quiz_bloc.dart';

sealed class EditQuizEvent {}

class GetMyQuizEvent extends EditQuizEvent {
  GetMyQuizEvent({
    this.poiId,
    this.isRefresh = false,
  });

  final int? poiId;
  final bool isRefresh;
}

class UpdateQuestionEvent extends EditQuizEvent {
  UpdateQuestionEvent(this.id);

  final int id;
}

class DeleteQuestionEvent extends EditQuizEvent {
  DeleteQuestionEvent(this.id);

  final int id;
}

class PostQuestionEvent extends EditQuizEvent {
  PostQuestionEvent(this.postQuestionQuery);

  final PostQuestionQuery postQuestionQuery;
}

class StoreImageEvent extends EditQuizEvent {
  StoreImageEvent(this.image);

  final XFile image;
}

part of 'edit_quiz_bloc.dart';

enum EditQuizStatus { notLoading, loading, error }

enum EditQuizSmallEvent {
  updateQuestion,
  deleteQuestion,
  postQuestion,
}

class EditQuizState {
  EditQuizState({
    this.questions = const [],
    this.status = EditQuizStatus.notLoading,
    this.error,
    this.page = 1,
    this.perPage = 10,
    this.searchingMoreQuestionsStatus = EditQuizStatus.notLoading,
    this.hasMoreQuestions = true,
    this.smallEvent,
  });

  List<Question> questions;
  EditQuizStatus status;
  EditQuizStatus searchingMoreQuestionsStatus;
  bool hasMoreQuestions;
  ApiError? error;
  int page;
  int perPage;
  EditQuizSmallEvent? smallEvent;

  EditQuizState copyWith({
    List<Question>? questions,
    EditQuizStatus? status,
    ApiError? error,
    int? page,
    int? perPage,
    EditQuizStatus? searchingMoreQuestionsStatus,
    bool? hasMoreQuestions,
    EditQuizSmallEvent? smallEvent,
  }) {
    return EditQuizState(
      questions: questions ?? this.questions,
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      searchingMoreQuestionsStatus:
          searchingMoreQuestionsStatus ?? this.searchingMoreQuestionsStatus,
      hasMoreQuestions: hasMoreQuestions ?? this.hasMoreQuestions,
      smallEvent: smallEvent,
    );
  }
}

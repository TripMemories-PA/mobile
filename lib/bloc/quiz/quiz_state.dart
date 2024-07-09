part of 'quiz_bloc.dart';

enum QuizStatus { initial, loading, error }

class QuizState {
  QuizState({
    this.quiz,
    this.status = QuizStatus.initial,
    this.error,
    this.page = 1,
    this.perPage = 10,
    this.currentQuestionIndex,
  });

  Quiz? quiz;
  QuizStatus status;
  ApiError? error;
  int page;
  int perPage;
  int? currentQuestionIndex;

  QuizState copyWith({
    Quiz? quiz,
    QuizStatus? status,
    ApiError? error,
    int? page,
    int? perPage,
    int? currentQuestionIndex
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }
}

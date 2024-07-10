part of 'quiz_bloc.dart';

enum QuizStatus { initial, loading, error }

enum QuizGameStatus { inProgress, ended }

class QuizState {
  QuizState({
    this.quiz,
    this.status = QuizStatus.initial,
    this.error,
    this.page = 1,
    this.perPage = 10,
    this.currentQuestionIndex = 0,
    this.isValidAnswer,
    this.quizGameStatus = QuizGameStatus.inProgress,
    this.score = 0,
  });

  Quiz? quiz;
  QuizStatus status;
  ApiError? error;
  int page;
  int perPage;
  int currentQuestionIndex;
  bool? isValidAnswer;
  QuizGameStatus quizGameStatus;
  int score;

  QuizState copyWith({
    Quiz? quiz,
    QuizStatus? status,
    ApiError? error,
    int? page,
    int? perPage,
    int? currentQuestionIndex,
    bool? isValidAnswer,
    QuizGameStatus? quizGameStatus,
    int? score,
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isValidAnswer: isValidAnswer,
      quizGameStatus: quizGameStatus ?? this.quizGameStatus,
      score: score ?? this.score,
    );
  }
}

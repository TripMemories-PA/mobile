import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/quiz/i_quiz_service.dart';
import '../../api/quiz/model/query/post_question_query.dart';
import '../../object/quiz/quiz.dart';
import '../../repository/quiz/i_quiz_repository.dart';

part 'quiz_event.dart';

part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({
    required this.quizRepository,
    required this.quizService,
  }) : super(QuizState()) {
    on<GetQuizEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: QuizStatus.loading));
        final Quiz quiz = await quizRepository.getQuiz(
          poiId: event.poiId,
          page: state.page,
          perPage: state.perPage,
        );
        emit(state.copyWith(
          quiz: quiz,
          status: QuizStatus.initial,
          currentQuestionIndex: 0,
        ));
      } catch (e) {
        emit(
          state.copyWith(
            error: e is CustomException ? e.apiError : ApiError.unknown(),
            status: QuizStatus.error,
          ),
        );
      }
    });

    on<GetNextQuestionEvent>((event, emit) {
      final int currentQuestionIndex = state.currentQuestionIndex ?? -1;
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex! + 1));
    });

    on<UpdateQuestionEvent>((event, emit) {
      throw UnimplementedError();
    });

    on<DeleteQuestionEvent>((event, emit) {
      throw UnimplementedError();
    });

    on<PostQuestionEvent>((event, emit) {
      throw UnimplementedError();
    });

    on<CheckQuestionEvent>((event, emit) {
      throw UnimplementedError();
    });

    on<StoreImageEvent>((event, emit) {
      throw UnimplementedError();
    });
  }

  IQuizRepository quizRepository;
  IQuizService quizService;
}

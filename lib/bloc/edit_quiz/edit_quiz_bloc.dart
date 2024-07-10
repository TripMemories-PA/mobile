import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/quiz/i_quiz_service.dart';
import '../../api/quiz/model/query/post_question_query.dart';
import '../../object/quiz/question.dart';
import '../../object/quiz/quiz.dart';
import '../../repository/quiz/i_quiz_repository.dart';

part 'edit_quiz_event.dart';
part 'edit_quiz_state.dart';

class EditQuizBloc extends Bloc<EditQuizEvent, EditQuizState> {
  EditQuizBloc({
    required this.quizRepository,
    required this.quizService,
  }) : super(EditQuizState()) {
    on<GetMyQuizEvent>((event, emit) async {
      try {
        if (event.isRefresh) {
          emit(
            state.copyWith(
              status: EditQuizStatus.loading,
              searchingMoreQuestionsStatus: EditQuizStatus.loading,
            ),
          );
        } else {
          emit(
            state.copyWith(
              searchingMoreQuestionsStatus: EditQuizStatus.loading,
            ),
          );
        }
        final Quiz quiz = await quizRepository.getQuiz(
          poiId: event.poiId,
          page: event.isRefresh ? 1 : state.page + 1,
          perPage: state.perPage,
        );
        emit(
          state.copyWith(
            questions: event.isRefresh
                ? quiz.data
                : [
                    ...state.questions,
                    ...quiz.data,
                  ],
            page: event.isRefresh ? 0 : state.page + 1,
            hasMoreQuestions: quiz.data.length == state.perPage,
            status: EditQuizStatus.notLoading,
            searchingMoreQuestionsStatus: EditQuizStatus.notLoading,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            error: e is CustomException ? e.apiError : ApiError.unknown(),
            status: EditQuizStatus.error,
          ),
        );
      }
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

    on<StoreImageEvent>((event, emit) {
      throw UnimplementedError();
    });
  }

  IQuizRepository quizRepository;
  IQuizService quizService;
}

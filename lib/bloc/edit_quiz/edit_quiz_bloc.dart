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

    on<UpdateQuestionEvent>((event, emit) async {
      try {
        int? imageId;
        if (event.postQuestionQueryDto.image != null) {
          imageId =
              await quizService.storeImage(event.postQuestionQueryDto.image!);
        }
        final PostQuestionQuery postQuestionQuery = PostQuestionQuery(
          question: event.postQuestionQueryDto.question,
          answers: event.postQuestionQueryDto.answers,
          imageId: imageId,
        );
        final Question updatedQuestion =
            await quizService.updateQuestion(event.id, postQuestionQuery);
        emit(
          state.copyWith(
            smallEvent: EditQuizSmallEvent.updateQuestion,
            questions: state.questions.map((question) {
              if (question.id == event.id) {
                return updatedQuestion;
              }
              return question;
            }).toList(),
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

    on<DeleteQuestionEvent>((event, emit) async {
      try {
        await quizService.deleteQuestion(event.id);
        final List<Question> questions = state.questions;
        questions.removeWhere((element) => element.id == event.id);
        emit(
          state.copyWith(
            smallEvent: EditQuizSmallEvent.deleteQuestion,
            questions: questions,
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

    on<PostQuestionEvent>((event, emit) async {
      try {
        int? imageId;
        if (event.postQuestionQueryDto.image != null) {
          imageId =
              await quizService.storeImage(event.postQuestionQueryDto.image!);
        }
        final PostQuestionQuery postQuestionQuery = PostQuestionQuery(
          question: event.postQuestionQueryDto.question,
          answers: event.postQuestionQueryDto.answers,
          imageId: imageId,
        );
        final Question newQuestion =
            await quizService.postQuestion(postQuestionQuery);
        emit(
          state.copyWith(
            smallEvent: EditQuizSmallEvent.postQuestion,
            questions: [
              newQuestion,
              ...state.questions,
            ],
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
  }

  IQuizRepository quizRepository;
  IQuizService quizService;
}

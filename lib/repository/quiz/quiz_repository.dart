import '../../object/quiz/quiz.dart';
import '../../service/quiz/quiz_remote_data_source.dart';
import 'i_quiz_repository.dart';

class QuizRepository implements IQuizRepository {
  QuizRepository({required this.quizRemoteDataSource});

  final QuizRemoteDataSource quizRemoteDataSource;

  @override
  Future<Quiz> getQuiz({required int page, required int perPage, int? poiId}) {
    return quizRemoteDataSource.getQuiz(
      page: page,
      perPage: perPage,
      poiId: poiId,
    );
  }
}

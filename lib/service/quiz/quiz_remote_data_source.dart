import '../../api/quiz/quiz_service.dart';
import '../../object/quiz/quiz.dart';
import '../../repository/quiz/i_quiz_repository.dart';

class QuizRemoteDataSource extends IQuizRepository {
  final QuizService _quizService = QuizService();

  @override
  Future<Quiz> getQuiz({required int page, required int perPage, int? poiId}) {
    return _quizService.getQuiz(page: page, perPage: perPage, poiId: poiId);
  }
}

import '../../object/quiz/quiz.dart';

abstract class IQuizRepository {
  Future<Quiz> getQuiz({required int page, required int perPage, int? poiId});
}

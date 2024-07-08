import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../../object/quiz/quiz.dart';
import '../../repository/quiz/i_quiz_repository.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../exception/bad_request_exception.dart';
import 'i_quiz_service.dart';

class QuizService implements IQuizService, IQuizRepository {
  static const String apiGetQuizUrl = '${AppConfig.apiUrl}/questions';
  static const String apiGetPoiQizzUrl =
      '${AppConfig.apiUrl}/pois/{POI_ID}/questions';

  @override
  Future<Quiz> getQuiz({
    required int page,
    required int perPage,
    int? poiId,
  }) async {
    Response response;
    try {
      String url = poiId == null
          ? apiGetQuizUrl
          : apiGetPoiQizzUrl.replaceAll('{POI_ID}', poiId.toString());
      url = '$url?page=$page&perPage=$perPage';
      response = await DioClient.instance.get(url);
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
    try {
      return Quiz.fromJson(response.data);
    } catch (e) {
      throw BadRequestException(ApiError.errorOccurredWhileParsingResponse());
    }
  }
}

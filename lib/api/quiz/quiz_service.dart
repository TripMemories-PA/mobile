import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../app.config.dart';
import '../../object/quiz/question.dart';
import '../../object/quiz/quiz.dart';
import '../../object/uploaded_file.dart';
import '../../repository/quiz/i_quiz_repository.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_quiz_service.dart';
import 'model/query/post_question_query.dart';
import 'model/response/check_question_response.dart';

class QuizService implements IQuizService, IQuizRepository {
  static const String apiGetQuizUrl = '${AppConfig.apiUrl}/questions';
  static const String apiGetPoiQuizUrl =
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
          : apiGetPoiQuizUrl.replaceAll('{POI_ID}', poiId.toString());
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

  @override
  Future<Question> updateQuestion(int id, PostQuestionQuery query) async {
    Response response;
    try {
      response = await DioClient.instance
          .put('$apiGetQuizUrl/$id', data: query.toJson());
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
    try {
      return Question.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> deleteQuestion(int id) async {
    try {
      await DioClient.instance.delete('$apiGetQuizUrl/$id');
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
  }

  @override
  Future<Question> postQuestion(PostQuestionQuery postQuestionQuery) async {
    Response response;
    try {
      response = await DioClient.instance
          .post(apiGetQuizUrl, data: postQuestionQuery.toJson());
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
    try {
      return Question.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<CheckQuestionResponse> checkQuestionResponse({
    required int questionId,
    required int answerId,
  }) async {
    Response response;
    try {
      response = await DioClient.instance
          .post('$apiGetQuizUrl/$questionId/answers/$answerId');
    } on BadRequestException {
      throw BadRequestException(ApiError.errorOccurred());
    }
    try {
      return CheckQuestionResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<int> storeImage(XFile image) async {
    Response response;
    try {
      response = await DioClient.instance.post(
        '$apiGetQuizUrl/image',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path),
        }),
      );
    } on BadRequestException {
      throw BadRequestException(ApiError.badRequest());
    }
    try {
      return UploadFile.fromJson(response.data).id;
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }
}

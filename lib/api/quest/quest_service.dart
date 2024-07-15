import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../app.config.dart';
import '../../object/quest.dart';
import '../../repository/quest/i_repository.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_quest_service.dart';
import 'model/query/post_quest_query_model.dart';
import 'model/query/update_quest_query_model.dart';
import 'model/response/get_quest_list.dart';
import 'model/response/post_quest_imaage_response.dart';

class QuestService implements IQuestService, IQuestRepository {
  static const String apiQuestsBaseUrl = '${AppConfig.apiUrl}/quests';

  @override
  Future<PostQuestImageResponse> storeImage(XFile file) async {
    Response response;
    try {
      final FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: 'image.jpg'),
      });
      response = await DioClient.instance.post(
        '$apiQuestsBaseUrl/image',
        data: formData,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return PostQuestImageResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> storeQuest({required PostQuestQueryModel questData}) async {
    try {
      await DioClient.instance.post(
        apiQuestsBaseUrl,
        data: jsonEncode(questData),
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<Quest> getQuest(int id) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        '$apiQuestsBaseUrl/$id',
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return Quest.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> updateQuest({
    required int id,
    required UpdateQuestQueryModel questData,
  }) async {
    try {
      await DioClient.instance.put(
        '$apiQuestsBaseUrl/$id',
        data: jsonEncode(questData),
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<void> deleteQuest(int id) async {
    try {
      await DioClient.instance.delete(
        '$apiQuestsBaseUrl/$id',
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<void> validateQuest({required int id, required XFile file}) async {
    try {
      final FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: 'image.jpg'),
      });
      await DioClient.instance.post(
        '$apiQuestsBaseUrl/$id/validate',
        data: formData,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
  }

  @override
  Future<GetQuestList> getQuestsFromPoi({
    required int poiId,
    required int page,
    required int perPage,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        '${AppConfig.apiUrl}/pois/$poiId/quests?page=$page&perPage=$perPage',
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return GetQuestList.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }
}

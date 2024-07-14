import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../../object/conversation.dart';
import '../../repository/chat/i_chat_repository.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_chat_service.dart';

class ChatService implements IChatService, IChatRepository {
  @override
  Future<void> postPrivateMessage({
    required int userId,
    required String content,
  }) async {
    try {
      await DioClient.instance.post(
        '${AppConfig.apiUrl}/users/$userId/messages',
        data: {
          'content': content,
        },
      );
    } on BadRequestException {
      throw BadRequestException(ApiError.errorWhilePostingMessage());
    }
  }

  @override
  Future<void> postMeetMessage({
    required int meetId,
    required String content,
  }) async {
    try {
      await DioClient.instance.post(
        '${AppConfig.apiUrl}/meets/$meetId/messages',
        data: {
          'content': content,
        },
      );
    } on BadRequestException {
      throw BadRequestException(ApiError.errorWhilePostingMessage());
    }
  }

  @override
  Future<Conversation> getMeetConversationMessages({
    required int meetId,
    required int page,
    required int perPage,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        '${AppConfig.apiUrl}/meets/$meetId/messages',
        queryParameters: {
          'page': page,
          'perPage': perPage,
        },
      );
    } on BadRequestException {
      throw BadRequestException(ApiError.errorWhileFetchingMessages());
    }
    try {
      return Conversation.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<Conversation> getPrivateConversationMessages({
    required int userId,
    required int page,
    required int perPage,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        '${AppConfig.apiUrl}/users/$userId/messages',
        queryParameters: {
          'page': page,
          'perPage': perPage,
        },
      );
    } on BadRequestException {
      throw BadRequestException(ApiError.errorWhileFetchingMessages());
    }
    try {
      return Conversation.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }
}

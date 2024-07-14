import '../../object/conversation.dart';

abstract class IChatRepository {
  Future<Conversation> getPrivateConversationMessages({
    required int userId,
    required int page,
    required int perPage,
  });

  Future<Conversation> getMeetConversationMessages({
    required int meetId,
    required int page,
    required int perPage,
  });
}

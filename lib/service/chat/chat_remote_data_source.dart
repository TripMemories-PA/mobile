import '../../api/chat/chat_service.dart';
import '../../object/conversation.dart';
import '../../repository/chat/i_chat_repository.dart';

class ChatRemoteDataSource implements IChatRepository {
  final ChatService _chatService = ChatService();

  @override
  Future<Conversation> getMeetConversationMessages({
    required int meetId,
    required int page,
    required int perPage,
  }) async {
    return _chatService.getMeetConversationMessages(
      meetId: meetId,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<Conversation> getPrivateConversationMessages({
    required int userId,
    required int page,
    required int perPage,
  }) async {
    return _chatService.getPrivateConversationMessages(
      userId: userId,
      page: page,
      perPage: perPage,
    );
  }
}

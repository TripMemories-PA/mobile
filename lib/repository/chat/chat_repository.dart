import '../../object/conversation.dart';
import '../../service/chat/chat_remote_data_source.dart';
import 'i_chat_repository.dart';

class ChatRepository implements IChatRepository {
  const ChatRepository({
    required this.chatRemoteDataSource,
  });

  final ChatRemoteDataSource chatRemoteDataSource;

  @override
  Future<Conversation> getPrivateConversationMessages({
    required int userId,
    required int page,
    required int perPage,
  }) {
    return chatRemoteDataSource.getPrivateConversationMessages(
      userId: userId,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<Conversation> getMeetConversationMessages({
    required int meetId,
    required int page,
    required int perPage,
  }) {
    return chatRemoteDataSource.getMeetConversationMessages(
      meetId: meetId,
      page: page,
      perPage: perPage,
    );
  }
}
